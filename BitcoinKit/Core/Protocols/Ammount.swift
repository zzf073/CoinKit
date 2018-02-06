//
//  Ammount.swift
//  BitcoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public protocol Ammount:Representable {
    
    var value:Double {get}
    var formattedValue:Double {get}
    
    init(withValue value:Double)
    init(withFormattedValue formattedValue:Double)
}
