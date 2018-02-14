//
//  ETHBlockchainService.swift
//  AFNetworking
//
//  Created by Dmitry on 12.02.2018.
//

import Foundation
import ethers
import AFNetworking

fileprivate class EtherscanAPI {
    
    typealias EtherscanAPICompletition = (Any?, Error?) -> Void
    
    private static let baseURLString = "https://api.etherscan.io"
    static let shared = EtherscanAPI.init()
    
    func GETPath(_ path:String, withParams params:[String:Any]?, completition:@escaping EtherscanAPICompletition) {
        
        let manager = AFHTTPSessionManager.init(sessionConfiguration: URLSessionConfiguration.default)
        
        manager.get(EtherscanAPI.baseURLString + path,
                    parameters: params,
                    progress: nil,
                    success: {
        (task, result) in
                        
            completition(result, nil)
        }) {
            (task, error) in
            
            completition(nil, error)
        }
    }
}


public class ETHBlockchainService: BlockchainService {
    
    let provider: Provider = EtherscanProvider(chainId: ChainId.ChainIdRinkeby, apiKey: "5Z553MKCV35Y73ANP1C9NCEFMCD39GXZM1")
    
    public required init() {
        
    }
    
    public func getWalletBalance(_ wallet: Wallet, withCompletition completition: @escaping GetWalletBalanceCompletition) {
        
        self.checkAPIKeySet()
        
        var params = [String:Any]()
        
        params["module"] = "account"
        params["action"] = "balance"
        params["tag"] = "latest"
        params["apikey"] = CoinKitConfig.etherscanAPIKey!
        params["address"] = wallet.address
        
        EtherscanAPI.shared.GETPath("/api", withParams: params) { (result, error) in
            
            guard error == nil else {
                
                completition(nil, error)
                return
            }
            
            if let dictionary = result as? [String:Any] {
                
                if let value = dictionary["result"] as? String {
                    
                    let amount = ETHAmount.init(withOriginalValue: Decimal.init(string: value)!)
                    
                    completition(amount, nil)
                }
            }
        }
    }
    
    public func getWalletTransactions(_ wallet: Wallet, offset: UInt, count: UInt, withCompletition completition: @escaping GetWalletTransactionsCompletition) {
        
    }
    
    public func getTransactionFee(_ completition: (Amount?, Error?) -> Void) {
        
    }
    
    public func broadcastTransaction(from senderWallet: Wallet, to receiverWallet: Wallet, amount: Amount, fee: Amount, completition: @escaping BroadcastTransactionCompletition) {
        
    }
    
    //MARK: - Private
    
    private func checkAPIKeySet() {
        
        if CoinKitConfig.etherscanAPIKey == nil {
            fatalError("CoinKitConfig.etherscanAPIKey is not set! Obtain your key at https://etherscan.io/myapikey")
        }
        
    }
}
