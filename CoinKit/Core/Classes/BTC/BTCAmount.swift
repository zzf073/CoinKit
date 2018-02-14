//
//  BitcoinAmount.swift
//  CoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public class BTCAmount: Amount {
    
    private static let numberOfSatoshisInBTC = Decimal.init(100_000_000)
    public var originalValue: Decimal
    public var formattedValue: Double
    
    public var representation: String {
        return "\(self.formattedValue == 0.0 ? 0 : self.formattedValue) ₿"
    }
    
    public required init(withOriginalValue value: Decimal) {
        
        self.originalValue = value
        self.formattedValue = NSDecimalNumber.init(decimal:(value / BTCAmount.numberOfSatoshisInBTC)).doubleValue
    }
    
    public required init?(withFormattedValue formattedValue: Double) {
        
        self.formattedValue = formattedValue
        self.originalValue = Decimal.init(formattedValue) * BTCAmount.numberOfSatoshisInBTC
    }
    
    public required init?(withRepresentation representation: String) {
        return nil
    }
}
