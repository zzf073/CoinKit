//
//  Representable.swift
//  CoinKit
//
//  Created by Dmitry on 02.02.2018.
//

import Foundation

public protocol Representable {
    var representation:String {get}
    
    init?(withRepresentation representation:String)
}

public protocol DataRepresentable:Representable{
    
    var data:Data {get}
    
    init(withData data:Data)
}
