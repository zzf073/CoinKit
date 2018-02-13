//
//  ETHAmount.swift
//  AFNetworking
//
//  Created by Dmitry on 13.02.2018.
//

import Foundation

class ETHAmount: Amount {
    
    var originalValue: Double
    var formattedValue: Double
    
    required init(withOriginalValue value: Double) {
        self.originalValue = value
        self.formattedValue = value
    }
    
    required init?(withFormattedValue formattedValue: Double) {
        self.originalValue = formattedValue
        self.formattedValue = formattedValue
    }
    
    var representation: String {
        return "\(self.formattedValue) ETH"
    }
    
    required init?(withRepresentation representation: String) {
        return nil
    }
}
