//
//  Amount.swift
//  CoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public protocol Amount {
    
    var value:Double {get}
    var symbol:String {get}
    var representation:String {get}
}

public class BaseAmount:Amount {
    
    public var value: Double
    public var symbol: String
    public var representation: String {
        return "\(self.value) \(self.symbol)"
    }
    
    public init(value: Double, symbol: String) {
        self.value = value
        self.symbol = symbol
    }
}
