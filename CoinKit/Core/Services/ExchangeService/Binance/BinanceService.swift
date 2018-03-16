//
//  BinanceService.swift
//  AFNetworking
//
//  Created by Dmitry on 09.03.2018.
//

import Foundation

public class BinanceService: ExchangeService {
    
    private var engine:BinanceApi?
    
    public var authCredentials: ExchangeServiceAuthCredentials? {
        didSet {
            
            if let key = authCredentials?.apiKey, let secret = authCredentials?.secretKey {
                self.engine = BinanceApi.init(apiKey: key, secretKey: secret)
            }
        }
    }
    
    public init() {
        
    }
    
    public func getAccountBalance(_ completition: @escaping ([String : Amount]?, Error?) -> Void) {
        
        completition(["BTC" : BaseAmount.init(value: 0.05, symbol: "BTC") ,
                      "ETH" : BaseAmount.init(value: 0.2, symbol: "ETH"),
                      "ADA" : BaseAmount.init(value: 10, symbol: "ADA"),
                      "XRP" : BaseAmount.init(value: 240, symbol: "XRP")], nil)
        
//        return
//        
//        self.engine?.send(BinanceAccountInformationRequest.init(), completionHandler: { (response) in
//            
//            if let error = response.error {
//                
//            }
////
////            let account = response.result.value!
////            let balances = account.balances
////            for (asset, balance) in balances {
////                print("\(balance.total) \(asset)")
////            }
//        })
    }
}
