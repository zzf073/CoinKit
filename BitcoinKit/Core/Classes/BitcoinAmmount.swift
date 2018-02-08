//
//  BitcoinAmmount.swift
//  BitcoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public class BitcoinAmmount: Ammount {
    
    private let numberOfSatoshiInBTC = 100_000_000.0
    
    public var value: Double
    public var formattedValue: Double
    
    public var representation: String {
        return "\(self.formattedValue == 0.0 ? 0 : self.formattedValue) BTC"
    }
    
    required public init(withValue value: Double) {
        
        self.value = value
        self.formattedValue = value / self.numberOfSatoshiInBTC
    }
    
    public required init(withFormattedValue formattedValue: Double) {
        
        self.value = formattedValue * self.numberOfSatoshiInBTC
        self.formattedValue = formattedValue
    }
    
    required public init?(withRepresentation representation: String) {
        return nil
    }
}
