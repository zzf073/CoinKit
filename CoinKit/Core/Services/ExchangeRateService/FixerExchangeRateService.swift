//
//  FixerExchangeRateService.swift
//  AFNetworking
//
//  Created by Dmitry on 28.02.2018.
//

import Foundation

public class FixerExchangeRateService:ExchangeRateService {
    
    private var rates:[String:Double]? { //rates agains USD (eg "RUB":55.0)
        didSet {
            self.updateOperationQueueSuspendedState()
        }
    }
    private var coinPrices:[String:Double]? { //coin prices agains USD (eg "BTC":10102)
        didSet {
            self.updateOperationQueueSuspendedState()
        }
    }
    private var updatingRates = false
    
    private var transport:HTTPTransport
    private var marketService:MarketService
    private var operationQueue:OperationQueue
    
    public init(transport:HTTPTransport, marketService:MarketService) {
        
        self.transport = transport
        self.marketService = marketService
        self.operationQueue = OperationQueue()
        
        self.updateOperationQueueSuspendedState()
    }
    
    public func getExchangeRatesForCoinSymbols(_ coinSymbols: [String],
                                               targetCurrency: FiatType,
                                               completition: @escaping (FiatType, [String : Double]) -> Void)
    {
        if self.rates == nil && self.coinPrices == nil && !self.updatingRates {
            self.reloadExchangeRates(nil)
        }
        
        self.operationQueue.addOperation {
            
            var result = [String:Double]()
            
            coinSymbols.forEach({ (symbol) in
                
                if let coinPrice = self.coinPrices?[symbol] {
                    
                    if let fiatPriceInUSD = self.rates?[targetCurrency.rawValue] {
                        result[symbol] = coinPrice * fiatPriceInUSD
                    }
                }
            })
            
            completition(targetCurrency, result)
        }
    }
    
    public func reloadExchangeRates(_ completition: ReloadExchangeRatesCompletition?) {
        
        self.updatingRates = true
        
        self.coinPrices = nil
        self.rates = nil
        
        self.marketService.getCoins(offset: 0, count: UInt.max) { (result, error) in
            
            var prices = [String:Double]()
            
            result?.forEach({ (summary) in
                prices[summary.coin.symbol] = summary.priceUSD.value
            })
            
            self.coinPrices = prices
        }
        
        self.transport.executeRequest(withURL: "https://api.fixer.io/latest?base=USD",
                                      params: nil,
                                      method: .GET)
        { (result, error) in
            
            var rates = [String:Double]()
            
            if let dictionary = result as? [String:Any], let dictionaryRates = dictionary["rates"] as? [String:Double] {
                rates = dictionaryRates
            }
            
            rates["USD"] = 1.0
            
            self.rates = rates
        }
    }
    
    private func updateOperationQueueSuspendedState() {
        self.operationQueue.isSuspended = (self.rates == nil) || (self.coinPrices == nil)
        
        if !self.operationQueue.isSuspended && self.updatingRates { //updating finished
            self.updatingRates = false
        }
    }
}
