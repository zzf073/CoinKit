//
//  BitcoinAmount.swift
//  BitcoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public class BitcoinAmount: Amount {
    
    private static let numberOfSatoshiInBTC:Int64 = 100_000_000
    
    public var value: Int64
    public var formattedValue: Double
    
    public var representation: String {
        return "\(self.formattedValue == 0.0 ? 0 : self.formattedValue) BTC"
    }
    
    required public init(withValue value: Int64) {
        
        self.value = value
        self.formattedValue = Double(value) / Double(BitcoinAmount.numberOfSatoshiInBTC)
    }
    
    public required init?(withFormattedValue formattedValue: Double) {
        
        let int64Value = Int64(formattedValue)
        
        if int64Value > 0 && (Int64.max / int64Value) < BitcoinAmount.numberOfSatoshiInBTC {
            return nil
        }
        
        self.value = Int64(formattedValue) * BitcoinAmount.numberOfSatoshiInBTC
        self.formattedValue = formattedValue
    }
    
    required public init?(withRepresentation representation: String) {
        return nil
    }
}
