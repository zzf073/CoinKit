//
//  BitcoinAmount.swift
//  CoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public class BTCAmount: Amount {
    
    private static let numberOfSatoshiInBTC:Double = 100_000_000
    
    public var originalValue: Double
    public var formattedValue: Double
    public var representation: String {
        return "\(self.formattedValue == 0.0 ? 0 : self.formattedValue) ₿"
    }
    
    public required init(withOriginalValue value: Double) {
        
        self.originalValue = value
        self.formattedValue = originalValue / BTCAmount.numberOfSatoshiInBTC
    }
    
    public required init?(withFormattedValue formattedValue: Double) {
        
        self.formattedValue = formattedValue
        self.originalValue = formattedValue * BTCAmount.numberOfSatoshiInBTC
    }
    
    public required init?(withRepresentation representation: String) {
        return nil
    }
}
