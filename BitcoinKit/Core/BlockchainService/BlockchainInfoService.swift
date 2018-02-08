//
//  BlockchainInfoService.swift
//  AFNetworking
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation
import CoreBitcoin
import Foundation
import AFNetworking

fileprivate class BlockChainInfoTransaction:BitcoinTransaction {
    
    fileprivate convenience init?(withDictionary dictionary:[String:Any]) {
        
        guard let hash = dictionary["hash"] as? String else { return nil }
        guard let timeInterval = dictionary["time"] as? Double else { return nil }
        guard let size = dictionary["size"] as? Int else { return nil }
        guard let blockHeight = dictionary["block_height"] as? Int else { return nil }
        guard let txWeight = dictionary["weight"] as? Int else { return nil }
        
        var outputAddresses = [String]()
        var outputAmounts = [BitcoinAmount]()
        
        var inputAddresses = [String]()
        var inputAmounts = [BitcoinAmount]()
        
        (dictionary["inputs"] as? [[String:Any]])?.forEach({ (inputDictionary) in
            
            if let prevOut = inputDictionary["prev_out"] as? [String:Any] {
                
                if let inputAddress = prevOut["addr"] as? String, let value = prevOut["value"] as? Int64 {
                    
                    inputAddresses.append(inputAddress)
                    inputAmounts.append(BitcoinAmount.init(withValue: value))
                }
            }
        })
        
        (dictionary["out"] as? [[String:Any]])?.forEach({ (outputDictionary) in
            
            if let outputAddress = outputDictionary["addr"] as? String, let value = outputDictionary["value"] as? Int64 {
                
                outputAddresses.append(outputAddress)
                outputAmounts.append(BitcoinAmount.init(withValue: value))
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

fileprivate class BlockChainAmount:BitcoinAmount {
    
    fileprivate convenience init?(withDictionary dictionary:[String:Any]) {
        
        guard let finalBalance = dictionary["final_balance"] as? Int64 else {
            return nil
        }
        
        self.init(withValue: finalBalance)
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

public class BlockchainInfoService: BlockchainService {
    
    public init() {
        
    }
    
    public var transactionBuilder: TransactionBuilder {
        return BitcoinTransactionBuilder()
    }
    
    public func getWalletBallance(_ wallet: Wallet, withCompletition completition: @escaping GetWalletBallanceCompletition) {
        
        BlockchainAPI.shared.GETPath("/balance", withParams: ["active" : wallet.address]) { (result, error) in
            
            guard error == nil else {
                
                completition(nil, error)
                return
            }
            
            if let dictionary = (result as? [String:Any])?.first?.value as? [String:Any], let ballance = BlockChainAmount.init(withDictionary: dictionary) {
                
                completition(ballance, nil)
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
    
    public func pushTransaction(_ transaction: TransactionBuilderResult, completition: (Error?) -> Void) {
        
        completition(nil)
        
    }
}
