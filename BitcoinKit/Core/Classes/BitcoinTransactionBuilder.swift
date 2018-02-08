//
//  BitcoinTransactionBuilder.swift
//  AFNetworking
//
//  Created by Dmitry on 08.02.2018.
//

import Foundation
import CoreBitcoin

class BitcoinTransactionBuilder: TransactionBuilder {
    
    func buildTransaction(for amount: Amount, to receiverWallet: Wallet, from senderWallet: Wallet, fee: Amount, completition: (TransactionBuilderResult?, Error?) -> Void) {
        
        completition(TransactionBuilderResult.init(transactionData: Data.init()), nil)
        
        return
        
        var data:Data?
        
        if let privateKeyData = senderWallet.keypair?.privateKey.data {
            
            data = self.buildTransactionSync(amount: amount.value,
                                             receiverAddress: receiverWallet.address,
                                             privateKey: privateKeyData,
                                             fee: fee.value)
        }
        
        completition(data != nil ? TransactionBuilderResult.init(transactionData: data!) : nil, nil)
    }
    
    
    private func buildTransactionSync(amount:Int64, receiverAddress:String, privateKey:Data, fee:Int64) -> Data? {
        
        NSLog("Transaction build log:")
        
        guard let key = BTCKey.init(privateKey: privateKey) else {
            
            NSLog("Private key inited with data")
            
            return nil
        }
        
        NSLog("Key inited with private key: %@", key)
        
        let bci = BTCBlockchainInfo.init()
        
        if key.compressedPublicKeyAddress == nil {
            
            NSLog("Unable to receive public key address")
            
            return nil
        }
        
        NSLog("Address received from private key")
        
        var utxos:[BTCTransactionOutput]! = nil
        
        do {
            utxos = try bci.unspentOutputs(withAddresses: [key.uncompressedPublicKeyAddress]) as? [BTCTransactionOutput]
        }
        catch {
            NSLog("Error getting outputs: %@", error.localizedDescription)
        }
        
        guard utxos != nil else {
            
            NSLog("Unable to receive unspent outputs")
            
            return nil
        }
        
        NSLog("Unspent outputs received: %@", utxos)
        
        let totalAmount = amount + fee
        
        utxos.sort {
            Int64($0.value - $1.value) < 0
        }
        
        var txouts = [BTCTransactionOutput]()
        var total:Int64 = 0
        
        for txout in utxos {
            
            if txout.script.isHash160Script {
                
                txouts.append(txout)
                
                total += txout.value
            }
            
            if total >= totalAmount {
                break
            }
        }
        
        
        // Create a new transaction
        
        let tx = BTCTransaction.init()
        
        var spentCoins:BTCAmount = 0
        
        // Add all outputs as inputs
        
        for txout in txouts {
            
            let txin = BTCTransactionInput.init()
            txin.previousHash = txout.transactionHash
            txin.previousIndex = txout.index
            
            tx.addInput(txin)
            
            spentCoins += txout.value
        }
        
        // Add required outputs - payment and change
        
        let paymentOutput = BTCTransactionOutput.init(value: amount, address: BTCAddress.init(string: receiverAddress))
        let changeOutput = BTCTransactionOutput.init(value: (spentCoins - (amount + fee)), address: key.compressedPublicKeyAddress)
        
        tx.addOutput(paymentOutput)
        
        if changeOutput!.value > 0 {
            tx.addOutput(changeOutput)
        }
        
        for i in 0..<txouts.count {
            
            let txout = txouts[i]
            let txin = (tx.inputs as! [BTCTransactionInput])[i]
            
            let sigScript = BTCScript.init()!
            
            let d1 = tx.data
            let hash = try? tx.signatureHash(for: txout.script, inputIndex: UInt32(i), hashType: BTCSignatureHashType.BTCSignatureHashTypeAll)
            let d2 = tx.data
            
            assert(d1 == d2, "Transaction must not change within signatureHashForScript!")
            
            if hash == nil {
                return nil
            }
            
            let signature = key.signature(forHash: hash) as NSData
            let signatureForScript = signature.mutableCopy() as! NSMutableData
            var hashType = BTCSignatureHashType.BTCSignatureHashTypeAll
            signatureForScript.append(&hashType, length: 1)
            
            sigScript.appendData(signatureForScript as Data)
            sigScript.appendData(key.publicKey as Data)
            
            assert(key.isValidSignature(signature as Data, hash: hash), "Signature must be valid")
            
            txin.signatureScript = sigScript
        }
        
        if let sm = BTCScriptMachine.init(transaction: tx, inputIndex: 0) {
            
            let outsc = txouts.first!.script
            
            do {
                try sm.verify(withOutputScript: outsc)
            }catch {
                NSLog("Verify error: %@", error.localizedDescription)
                
                return nil
            }
            
            return tx.data
        }
        
        return nil
    }
}
