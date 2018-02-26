//
//  CoinMarketCapService.swift
//  AFNetworking
//
//  Created by Dmitry on 26.02.2018.
//

import Foundation

fileprivate class CoinMarketCapCoinDescription:CoinDescription {
    
    var name: String
    var symbol: String
    
    init?(dictionary:[String:Any]) {
        
        guard let name = dictionary["name"] as? String else {
            return nil
        }
        
        guard let symbol = dictionary["symbol"] as? String else {
            return nil
        }
        
        self.name = name
        self.symbol = symbol
    }
}

fileprivate class CoinMarketCapCoinSummary:CoinSummary {
    
    var coin: CoinDescription
    var USDPrice: Amount
    var hourChange: Double?
    var dayChange: Double?
    var weekChange: Double?
    
    init?(dictionary:[String:Any]) {
        
        guard let coinDescription = CoinMarketCapCoinDescription.init(dictionary: dictionary) else {
            return nil
        }
        
        guard let stringValue = dictionary["price_usd"] as? String, let USDValue = Double(stringValue) else {
            return nil
        }
        
        guard let hourChange = dictionary["percent_change_1h"] as? String, let dayChange = dictionary["percent_change_24h"] as? String, let weekChange = dictionary["percent_change_7d"] as? String else {
            return nil
        }
        
        self.coin = coinDescription
        self.USDPrice = USDAmount.init(value: USDValue)
        
        self.hourChange = Double(hourChange)
        self.dayChange = Double(dayChange)
        self.weekChange = Double(weekChange)
    }
}

open class CoinMarketCapService:MarketService {
    
    private var transport:HTTPTransport
    
    public init(transport:HTTPTransport) {
        self.transport = transport
    }
    
    private func constructURLWithPath(_ path:String) -> String {
        
        let baseURLString = "https://api.coinmarketcap.com/v1/"
        
        return baseURLString + path
    }
    
    public func getCoins(offset: UInt, count: UInt, completition: @escaping ([CoinSummary]?, Error?) -> Void) {
        
        let URLString = self.constructURLWithPath("/ticker")
        
        self.transport.executeRequest(withURL: URLString,
                                      params: ["start" : offset, "limit" : count],
                                      method: .GET)
        { (result, error) in
            
            guard error == nil else {
                
                completition(nil, error)
                return
            }
            
            var operationResult = [CoinSummary]()
            
            if let array = result as? [[String:Any]] {
                
                array.forEach({ (summaryDictionary) in
                    
                    if let summary = CoinMarketCapCoinSummary.init(dictionary: summaryDictionary) {
                        operationResult.append(summary)
                    }
                })
            }
            
            completition(operationResult, nil)
        }
    }
}
