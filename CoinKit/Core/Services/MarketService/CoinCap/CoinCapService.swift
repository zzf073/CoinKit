//
//  CoinCapService.swift
//  AFNetworking
//
//  Created by Dmitry on 27.02.2018.
//

import Foundation

fileprivate class CoinCapCoinDescription:CoinDescription {
    
    var name: String
    var symbol: String
    
    init?(dictionary:[String:Any]) {
        
        guard let name = dictionary["long"] as? String, let symbol = dictionary["short"] as? String else {
            return nil
        }
        
        self.name = name
        self.symbol = symbol
    }
}

fileprivate class CoinCapCoinSummary:CoinSummary {
    var coin: CoinDescription
    var marketCapUSD: Amount
    var priceUSD: Amount
    var dailyVolume: Double
    var dailyPriceChange: Double
    
    init?(dictionary:[String:Any]) {
        
        guard let description = CoinCapCoinDescription.init(dictionary: dictionary) else {
            return nil
        }
        
        guard let price = dictionary["price"] as? Double else {
            return nil
        }
        
        guard let mcap = dictionary["mktcap"] as? Double else {
            return nil
        }
        
        guard let dvol = dictionary["volume"] as? Double else {
            return nil
        }
        
        guard let change = dictionary["perc"] as? Double else {
            return nil
        }
        
        self.coin = description
        
        self.marketCapUSD = USDAmount.init(value: mcap)
        self.priceUSD = USDAmount.init(value: price)
        self.dailyVolume = dvol
        self.dailyPriceChange = change
    }
}

open class CoinCapService:MarketService {
    
    private var transport:HTTPTransport
    
    public init(transport:HTTPTransport) {
        self.transport = transport
    }
    
    private func constructURLWithPath(_ path:String) -> String {
        
        let baseURLString = "https://coincap.io"
        
        return baseURLString + path
    }
    
    public func getCoins(offset: UInt, count: UInt, completition: @escaping GetCoinsCompletition) {
        
        let URLString = self.constructURLWithPath("/front")
        
        self.transport.executeRequest(withURL: URLString, params: [String:Any](), method: .GET) { (result, error) in
            
            guard error == nil else {
                
                completition(nil, error)
                return
            }
            
            var operationResult = [CoinSummary]()
            
            if let array = result as? [[String:Any]] {
                
                array.forEach({ (dictionary) in
                    if let summary = CoinCapCoinSummary.init(dictionary: dictionary) {
                        operationResult.append(summary)
                    }
                })
            }
            
            completition(operationResult, nil)
        }
    }
}
