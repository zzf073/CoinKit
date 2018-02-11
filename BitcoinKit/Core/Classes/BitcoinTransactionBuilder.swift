//
//  BitcoinTransactionBuilder.swift
//  AFNetworking
//
//  Created by Dmitry on 08.02.2018.
//

import Foundation
import CoreBitcoin

fileprivate class BitcoinTransactionBuilderDataSource:NSObject, BTCTransactionBuilderDataSource {
    
    private var privateKey:Data
    private var unspentOutputs:[BTCTransactionOutput]
    
    init(privateKey:Data, unspentOutputs:[BTCTransactionOutput]) {
        self.privateKey = privateKey
        self.unspentOutputs = unspentOutputs
    }
    
    func unspentOutputs(for txbuilder: BTCTransactionBuilder!) -> NSEnumerator! {
        return NSArray.init(array: self.unspentOutputs).objectEnumerator()
    }
    
    func transactionBuilder(_ txbuilder: BTCTransactionBuilder!, keyForUnspentOutput txout: BTCTransactionOutput!) -> BTCKey! {
        return BTCKey.init(privateKey: self.privateKey)
    }
}

class BitcoinTransactionBuilder:NSObject, TransactionBuilder  {
    
    lazy private var operationQueue = OperationQueue.init()
    
    func buildTransaction(for amount: Amount, to receiverWallet: Wallet, from senderWallet: Wallet, fee: Amount, completition: @escaping (BroadcastableTransaction?, Error?) -> Void) {
        
        self.operationQueue.addOperation {
            
            var data:Data?
            
            if let privateKeyData = senderWallet.keypair?.privateKey.data {
                
                data = self.buildTransactionSync(amount: amount.value,
                                                 receiverAddress: receiverWallet.address,
                                                 privateKey: privateKeyData,
                                                 fee: fee.value)
            }
            
            completition(data != nil ? BroadcastableTransaction.init(transactionData: data!) : nil, nil)
        }
    }
    
    
    private func buildTransactionSync(amount:Int64, receiverAddress:String, privateKey:Data, fee:Int64) -> Data? {
        
       let key = BTCKey.init(privateKey: privateKey)!
        
        guard let senderAddress = key.compressedPublicKeyAddress else {
            return nil
        }
        
        var unspentOutputs:[BTCTransactionOutput]!
        
        do {
            unspentOutputs = try BTCBlockchainInfo.init().unspentOutputs(withAddresses: [senderAddress]) as! [BTCTransactionOutput]
        }
        catch {
            
            NSLog("Error getting unspent outputs: %@", error.localizedDescription)
            
            return nil
        }
        
        let dataSource = BitcoinTransactionBuilderDataSource.init(privateKey: privateKey, unspentOutputs: unspentOutputs)
        
        let builder = BTCTransactionBuilder.init()
        builder.dataSource = dataSource
        builder.outputs = [BTCTransactionOutput.init(value: amount, address: BTCAddress.init(string: receiverAddress))!]
        builder.changeAddress = BTCAddress.init(string: senderAddress.string)
        
        var result:BTCTransactionBuilderResult?
        
        do {
            result = try builder.buildTransaction()
        }
        catch {
            NSLog("Error building transaction: %@", error.localizedDescription)
        }
        
        return result?.transaction.data
    }
}
