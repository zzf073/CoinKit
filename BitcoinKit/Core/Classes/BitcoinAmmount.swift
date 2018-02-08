//
//  BitcoinAmmount.swift
//  BitcoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public class BitcoinAmmount: Ammount {
    
    private let numberOfSatoshiInBTC:Int64 = 100_000_000
    
    public var value: Int64
    public var formattedValue: Double
    
    public var representation: String {
        return "\(self.formattedValue == 0.0 ? 0 : self.formattedValue) BTC"
    }
    
    required public init(withValue value: Int64) {
        
        self.value = value
        self.formattedValue = Double(value) / Double(self.numberOfSatoshiInBTC)
    }
    
    public required init(withFormattedValue formattedValue: Double) {
        
        self.value = Int64(formattedValue) * self.numberOfSatoshiInBTC
        self.formattedValue = formattedValue
    }
    
    required public init?(withRepresentation representation: String) {
        return nil
    }
}
