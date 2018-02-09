//
//  Amount.swift
//  BitcoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public protocol Amount:Representable {
    
    var value:Int64 {get}
    var formattedValue:Double {get}
    
    init(withValue value:Int64)
    init?(withFormattedValue formattedValue:Double)
}
