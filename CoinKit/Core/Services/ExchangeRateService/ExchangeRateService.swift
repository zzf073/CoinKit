//
//  ExchangeRateService.swift
//  AFNetworking
//
//  Created by Dmitry on 28.02.2018.
//

import Foundation

public enum FiatType:String {
    case USD = "USD"
    case EUR = "EUR"
    case RUB = "RUB"
}

public typealias ReloadExchangeRatesCompletition = () -> Void
public typealias GetExchangeRatesCompletition = (FiatType, [String:Double]) -> Void

public protocol ExchangeRateService {
    
    func reloadExchangeRates(_ completition:ReloadExchangeRatesCompletition?)
    func getExchangeRatesForCoinSymbols(_ coinSymbols:[String], targetCurrency:FiatType, completition:@escaping GetExchangeRatesCompletition)
    
}
