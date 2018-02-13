//
//  BTCBlockchainService.swift
//  AFNetworking
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation
import CoreBitcoin
import Foundation
import AFNetworking

fileprivate class BlockChainInfoTransaction:BTCTransaction {
    
    fileprivate convenience init?(withDictionary dictionary:[String:Any]) {
        
        guard let hash = dictionary["hash"] as? String else { return nil }
        guard let timeInterval = dictionary["time"] as? Double else { return nil }
        guard let size = dictionary["size"] as? Int else { return nil }
        guard let blockHeight = dictionary["block_height"] as? Int else { return nil }
        guard let txWeight = dictionary["weight"] as? Int else { return nil }
        
        var outputAddresses = [String]()
        var outputAmounts = [BTCAmount]()
        
        var inputAddresses = [String]()
        var inputAmounts = [BTCAmount]()
        
        (dictionary["inputs"] as? [[String:Any]])?.forEach({ (inputDictionary) in
            
            if let prevOut = inputDictionary["prev_out"] as? [String:Any] {
                
                if let inputAddress = prevOut["addr"] as? String, let value = prevOut["value"] as? Double {
                    
                    inputAddresses.append(inputAddress)
                    inputAmounts.append(BTCAmount.init(withOriginalValue: value))
                }
            }
        })
        
        (dictionary["out"] as? [[String:Any]])?.forEach({ (outputDictionary) in
            
            if let outputAddress = outputDictionary["addr"] as? String, let value = outputDictionary["value"] as? Double {
                
                outputAddresses.append(outputAddress)
                outputAmounts.append(BTCAmount.init(withOriginalValue: value))
            }
        })
        
        self.init(transactionHash: hash,
                  time: Date.init(timeIntervalSince1970: timeInterval),
                  size: size,
                  blockHeight: blockHeight,
                  weight: txWeight,
                  inputAddressed: inputAddresses,
                  inputAmounts: inputAmounts,
                  outputAddresses: outputAddresses,
                  outputAmounts: outputAmounts)
    }
}

fileprivate class BlockChainAmount:BTCAmount {
    
    fileprivate convenience init?(withDictionary dictionary:[String:Any]) {
        
        guard let finalBalance = dictionary["final_balance"] as? Double else {
            return nil
        }
        
        self.init(withOriginalValue: finalBalance)
    }
}

fileprivate class BlockchainAPI {
    
    typealias BlockchainAPICompletition = (Any?, Error?) -> Void
    
    private static let baseURLString = "https://blockchain.info"
    static let shared = BlockchainAPI.init()
    
    func GETPath(_ path:String, withParams params:[String:Any]?, completition:@escaping BlockchainAPICompletition) {
        
        let manager = AFHTTPSessionManager.init(sessionConfiguration: URLSessionConfiguration.default)
        
        manager.get(BlockchainAPI.baseURLString + path, parameters: params, progress: nil, success: { (task, result) in
            completition(result, nil)
        }) { (task, error) in
            completition(nil, error)
        }
    }
}

public class BTCBlockchainService: BlockchainService {
    
    lazy private var transactionBuilder = BitcoinTransactionBuilder.init()
    
    public required init() {
        
    }
    
    public func getWalletBalance(_ wallet: Wallet, withCompletition completition: @escaping GetWalletBalanceCompletition) {
        
        BlockchainAPI.shared.GETPath("/balance", withParams: ["active" : wallet.address]) { (result, error) in
            
            guard error == nil else {
                
                completition(nil, error)
                return
            }
            
            if let dictionary = (result as? [String:Any])?.first?.value as? [String:Any], let balance = BlockChainAmount.init(withDictionary: dictionary) {
                
                completition(balance, nil)
            }
            else {
                //TODO: Generate error
            }
        }
    }
    
    public func getWalletTransactions(_ wallet: Wallet, offset: UInt, count: UInt, withCompletition completition: @escaping GetWalletTransactionsCompletition) {
        
        BlockchainAPI.shared.GETPath("/rawaddr/\(wallet.address)", withParams: ["offset" : offset, "limit" : count]) { (result, error) in
            
            guard error == nil else {
                
                completition(nil, error)
                return
            }
            
            if let dictionary = result as? [String:Any], let transactionsArray = dictionary["txs"] as? [[String:Any]] {
                
                var transactions = [Transaction]()
                
                transactionsArray.forEach({ (dictionary) in
                    
                    if let transaction = BlockChainInfoTransaction.init(withDictionary: dictionary) {
                        
                        transactions.append(transaction)
                    }
                })
                
                completition(transactions, nil)
            }
            else {
                //TODO: Generate error
            }
        }
    }
    
    public func getTransactionFee(_ completition: (Amount?, Error?) -> Void) {
        completition(BTCAmount.init(withOriginalValue: Double(CoreBitcoin.BTCTransaction.init().estimatedFee)), nil)
    }
    
    public func broadcastTransaction(from senderWallet: Wallet, to receiverWallet: Wallet, amount: Amount, fee: Amount, completition: @escaping BroadcastTransactionCompletition) {
        
        self.transactionBuilder.buildTransaction(for: amount, to: receiverWallet, from: senderWallet, fee: fee) { (transaction, error) in
            
            guard error == nil, transaction != nil else {
                completition(error)
                return
            }
            
            let request = BTCBlockchainInfo.init().requestForTransactionBroadcast(with: transaction!.transactionData)! as URLRequest
            
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.init(), completionHandler: { (response, data, error) in
                
                DispatchQueue.main.async {
                    completition(error)
                }
            })
        }
    }
}

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

fileprivate class BitcoinTransactionBuilder:NSObject  {
    
    lazy private var operationQueue = OperationQueue.init()
    
    func buildTransaction(for amount: Amount, to receiverWallet: Wallet, from senderWallet: Wallet, fee: Amount, completition: @escaping (BroadcastableTransaction?, Error?) -> Void) {
        
        self.operationQueue.addOperation {
            
            var data:Data?
            
            if let privateKeyData = senderWallet.privateKey?.data {
                
                do {
                    data = try self.buildTransactionSync(amount: Int64(amount.originalValue),
                                                         receiverAddress: receiverWallet.address,
                                                         privateKey: privateKeyData,
                                                         fee: Int64(fee.originalValue))
                }
                catch {
                    completition(nil, error)
                    return
                }
                
            }
            
            completition(data != nil ? BroadcastableTransaction.init(transactionData: data!) : nil, nil)
        }
    }
    
    private func buildTransactionSync(amount:Int64, receiverAddress:String, privateKey:Data, fee:Int64) throws -> Data? {
        
        let key = BTCKey.init(privateKey: privateKey)!
        
        guard let senderAddress = key.compressedPublicKeyAddress else {
            return nil
        }
        
        let unspentOutputs = try BTCBlockchainInfo.init().unspentOutputs(withAddresses: [senderAddress]) as! [BTCTransactionOutput]
        
        let dataSource = BitcoinTransactionBuilderDataSource.init(privateKey: privateKey, unspentOutputs: unspentOutputs)
        
        let builder = BTCTransactionBuilder.init()
        builder.dataSource = dataSource
        builder.outputs = [BTCTransactionOutput.init(value: amount, address: BTCAddress.init(string: receiverAddress))!]
        builder.changeAddress = BTCAddress.init(string: senderAddress.string)
        
        return try builder.buildTransaction().transaction.data
    }
}

