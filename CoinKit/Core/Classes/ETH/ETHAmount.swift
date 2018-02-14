//
//  ETHAmount.swift
//  AFNetworking
//
//  Created by Dmitry on 13.02.2018.
//

import Foundation

class ETHAmount: Amount {
    
    private static let numberOfWeiInEth = Decimal.init(string: "1000000000000000000")!
    
    var originalValue: Decimal
    var formattedValue: Double
    
    var representation: String {
        return "\(self.formattedValue) Ξ"
    }
    
    required init(withOriginalValue value: Decimal) {
        
        self.originalValue = value
        self.formattedValue = NSDecimalNumber.init(decimal: (value / ETHAmount.numberOfWeiInEth)).doubleValue
    }
    
    required init?(withFormattedValue formattedValue: Double) {
        
        self.originalValue = Decimal.init(formattedValue) * ETHAmount.numberOfWeiInEth
        self.formattedValue = formattedValue
    }
    
    required init?(withRepresentation representation: String) {
        return nil
    }
}
