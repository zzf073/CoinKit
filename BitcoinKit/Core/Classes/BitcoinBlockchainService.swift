//
//  BitcoinBlockchainService.swift
//  BitcoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation
import AFNetworking

fileprivate class BlockChainTransaction:BitcoinTransaction {
    
    fileprivate convenience init?(withDictionary dictionary:[String:Any]) {
        
        self.init(senderAddress: "sender", receiverAddress: "receiver")
    }
}

fileprivate class BlockChainWalletBallance:BitcoinWalletBallance {
    
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

public class BitcoinBlockchainService: BlockchainService {
    
    public init() {
        
    }
    
    public func getWalletBallance(_ wallet: Wallet, withCompletition completition: @escaping GetWalletBallanceCompletition) {
        
        let address = "1PMR1kHE7aZD9k37g2W61gdMtWEZd27G2N"
        
        BlockchainAPI.shared.GETPath("/balance", withParams: ["active" : address]) { (result, error) in
            
            guard error == nil else {
                
                completition(nil, error)
                return
            }
            
            if let dictionary = (result as? [String:Any])?.first?.value as? [String:Any], let ballance = BlockChainWalletBallance.init(withDictionary: dictionary) {
                
                completition(ballance, nil)
            }
            else {
                //TODO: Generate error
            }
        }
    }
    
    public func getWalletTransactions(_ wallet: Wallet, offset: UInt, count: UInt, withCompletition completition: @escaping GetWalletTransactionsCompletition) {
        
        let address = "1PMR1kHE7aZD9k37g2W61gdMtWEZd27G2N"
        
        BlockchainAPI.shared.GETPath("/rawaddr/\(address)", withParams: ["offset" : offset, "limit" : count]) { (result, error) in
            
            guard error == nil else {
                
                completition(nil, error)
                return
            }
            
            
        }
    }
}
