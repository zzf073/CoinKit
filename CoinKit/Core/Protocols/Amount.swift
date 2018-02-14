//
//  Amount.swift
//  CoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public protocol Amount:Representable {
    
    var originalValue:Decimal {get}
    var formattedValue:Double {get}
    
    init(withOriginalValue value:Decimal)
    init?(withFormattedValue formattedValue:Double)
}
