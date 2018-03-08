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
        self.value = value
        self.symbol = symbol
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
            return "\(self.fiatType.symbol())\(self.formattedValue())"
        }
        else {
            return "\(self.formattedValue())\(self.fiatType.symbol())"
        }
    }
    
    public init(value: Double, fiatType:FiatType) {
        
        self.fiatType = fiatType
        
        super.init(value: value, symbol: fiatType.rawValue)
    }
    
    private func formattedValue() -> String {
        
        var maximumFractionDigits = 5
        
        if self.value > 100 {
            maximumFractionDigits = 0
        }
        else if self.value > 10 {
            maximumFractionDigits = 1
        }
        
        FiatAmount.numberFormatter.maximumFractionDigits = maximumFractionDigits
        
        return FiatAmount.numberFormatter.string(from: NSNumber.init(value: self.value))!
    }
    
    private func isSymbolBeforeValue() -> Bool {
        return self.fiatType == .USD || self.fiatType == .EUR
    }
}
