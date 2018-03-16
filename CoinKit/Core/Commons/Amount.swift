//
//  Amount.swift
//  CoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public protocol Amount {
    
    var value:Double {get}
    var symbol:String {get}
    var representation:String {get}
}

public class BaseAmount:Amount {
    
    public var value: Double
    public var symbol: String
    public var representation: String {
        return "\(self.value) \(self.symbol)"
    }
    
    public init(value: Double, symbol: String) {
        
        var specialSymbol = symbol
        
        switch symbol {
        case "BTC": specialSymbol = "₿"
        case "ETH": specialSymbol = "Ξ"
        case "USD": specialSymbol = "$"
        case "RUB": specialSymbol = "₽"
        case "EUR": specialSymbol = "€"
        default:break
        }
        
        self.value = value
        self.symbol = specialSymbol
    }
}

public class FiatAmount:BaseAmount {
    
    private var fiatType:FiatType
    private static var numberFormatter:NumberFormatter = {
        
        let formatter = NumberFormatter.init()
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale.current
        formatter.currencySymbol = ""
        
        return formatter
    }()
    
    public override var representation: String {
        
        if self.isSymbolBeforeValue() {
            return "\(self.symbol)\(self.formattedValue())"
        }
        else {
            return "\(self.formattedValue())\(self.symbol)"
        }
    }
    
    public init(value: Double, fiatType:FiatType) {
        
        self.fiatType = fiatType
        
        super.init(value: value, symbol: fiatType.rawValue)
    }
    
    private func formattedValue() -> String {
        
        var maximumFractionDigits = 0
        
        if self.value < 100 {
            maximumFractionDigits = 2
        }
        else if self.value < 1 {
            maximumFractionDigits = 6
        }
        
        FiatAmount.numberFormatter.maximumFractionDigits = maximumFractionDigits
        
        return FiatAmount.numberFormatter.string(from: NSNumber.init(value: self.value))!
    }
    
    private func isSymbolBeforeValue() -> Bool {
        return self.fiatType == .USD || self.fiatType == .EUR
    }
}
