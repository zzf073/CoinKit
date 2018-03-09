//
//  Types.swift
//  AFNetworking
//
//  Created by Dmitry on 12.02.2018.
//

import Foundation
import CoreBitcoin
import ethers

public enum WalletType:Int {
    case BTC = 1
    case ETH
    
    public static var availableTypes:[WalletType] = {
        
        var result = [WalletType]()
        
        for i in 0..<10 {
            if let type = WalletType.init(rawValue: i) {
                result.append(type)
            }
        }
        
        return result
    }()
    
    public func validateAddress(_ addressString:String) -> Bool {
        
        switch self {
        case .BTC:
            
            guard addressString.starts(with: "1") || addressString.starts(with: "3") else {
                return false
            }
            
            return BTCAddress.init(string: addressString) != nil
            
        case .ETH:
            
            guard addressString.starts(with: "0x") else {
                return false
            }
            
            return Address.init(string: addressString) != nil
        }
    }
    
    public func coinName() -> String {
        
        switch self {
        case .BTC: return "Bitcoin"
        case .ETH: return "Etherium"
        }
    }
    
    public func coinSymbol() -> String {
        
        switch self {
        case .BTC: return "BTC"
        case .ETH: return "ETH"
        }
    }
}

public enum FiatType:String {
    case USD = "USD"
    case EUR = "EUR"
    case RUB = "RUB"
    
    public func symbol() -> String {
        
        switch self {
        case .USD: return "$"
        case .RUB: return "₽"
        case .EUR: return "€"
        default: break
        }
        
        return self.rawValue
    }
}

public enum ExchangeType:String {
    case Binance = "Binance"
    
    public static func all() -> [ExchangeType] {
        return [.Binance]
    }
    
    public func exchangeService() -> ExchangeService {
        switch self {
        case .Binance: return BinanceService.init()
        }
    }
}
