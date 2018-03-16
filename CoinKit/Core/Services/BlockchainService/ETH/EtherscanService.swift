//
//  EtherscanService.swift
//  AFNetworking
//
//  Created by Dmitry on 12.02.2018.
//

import Foundation
import ethers
import AFNetworking

fileprivate class EtherscanAmount:BaseAmount {
    
    convenience init(weiValue:Decimal) {
        
        let numberOfWeiInEth = Decimal.init(string: "1000000000000000000")!
        
        let value = NSDecimalNumber.init(decimal:(weiValue / numberOfWeiInEth)).doubleValue
        
        self.init(value: value)
    }
    
    public init(value: Double) {
        super.init(value: value, symbol: "ETH")
    }
}


open class EtherscanService: BlockchainService {
    
    private var apiKey:String
    private var transport:HTTPTransport
    private var apiURLString = "https://api.etherscan.io/api"
    
    public init(apiKey:String, transport:HTTPTransport) {
        
        self.apiKey = apiKey
        self.transport = transport
    }
    
    public func getWalletsBalance(_ walletAddresses: [String], withCompletition completition: @escaping GetWalletBalanceCompletition) {
        
        var params = [String:Any]()
        
        params["module"] = "account"
        params["action"] = "balancemulti"
        params["tag"] = "latest"
        params["apikey"] = self.apiKey
        params["address"] = walletAddresses.joined(separator: ",")
        
        self.transport.executeRequest(withURL: self.apiURLString, params: params, method: .GET) { (result, error) in
            
            guard error == nil else {
                
                completition(nil, error)
                return
            }
            
            var operationResult = [String:Amount]()
            
            if let dictionary = result as? [String:Any] {
                
                if let array = dictionary["result"] as? [[String:Any]] {
                    
                    array.forEach({ (object) in
                        
                        if let address = object["account"] as? String {
                            
                            let amount = EtherscanAmount.init(weiValue: NSDecimalNumber.init(string: object["balance"] as? String).decimalValue)
                            
                            operationResult[address] = amount
                        }
                    })
                }
            }
            
            completition(operationResult, nil)
        }
    }
}
