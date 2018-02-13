//
//  Amount.swift
//  CoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public protocol Amount:Representable {
    
    var originalValue:Double {get}
    var formattedValue:Double {get}
    
    init(withOriginalValue value:Double)
    init?(withFormattedValue formattedValue:Double)
}
