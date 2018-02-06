//
//  BlockchainInfoService.swift
//  AFNetworking
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

import Foundation
import AFNetworking

fileprivate class BlockChainInfoTransaction:BitcoinTransaction {
    
    fileprivate convenience init?(withDictionary dictionary:[String:Any]) {
        
        var outputAddresses = [String]()
        var outputAmmounts = [BitcoinAmmount]()
        
        var inputAddresses = [String]()
        var inputAmmounts = [BitcoinAmmount]()
        
        guard let hash = dictionary["hash"] as? String, let timeInterval = dictionary["time"] as? Double else {
            return nil
        }
        
        (dictionary["inputs"] as? [[String:Any]])?.forEach({ (inputDictionary) in
            
            if let prevOut = inputDictionary["prev_out"] as? [String:Any] {
                
                if let inputAddress = prevOut["addr"] as? String, let value = prevOut["value"] as? Double {
                    
                    inputAddresses.append(inputAddress)
                    inputAmmounts.append(BitcoinAmmount.init(withValue: value))
                }
            }
        })
        
        (dictionary["out"] as? [[String:Any]])?.forEach({ (outputDictionary) in
            
            if let outputAddress = outputDictionary["addr"] as? String, let value = outputDictionary["value"] as? Double {
                
                outputAddresses.append(outputAddress)
                outputAmmounts.append(BitcoinAmmount.init(withValue: value))
            }
        })
        
        self.init(transactionHash:hash,
                  time:Date.init(timeIntervalSince1970: timeInterval),
                  inputAddressed: inputAddresses,
                  inputAmmounts: inputAmmounts,
                  outputAddresses: outputAddresses,
                  outputAmmounts: outputAmmounts)
    }
}

fileprivate class BlockChainAmmount:BitcoinAmmount {
    
    fileprivate convenience init?(withDictionary dictionary:[String:Any]) {
        
        guard let finalBalance = dictionary["final_balance"] as? Double else {
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
    
    public func getWalletBallance(_ wallet: Wallet, withCompletition completition: @escaping GetWalletBallanceCompletition) {
        
        BlockchainAPI.shared.GETPath("/balance", withParams: ["active" : wallet.address]) { (result, error) in
            
            guard error == nil else {
                
                completition(nil, error)
                return
            }
            
            if let dictionary = (result as? [String:Any])?.first?.value as? [String:Any], let ballance = BlockChainAmmount.init(withDictionary: dictionary) {
                
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
}
