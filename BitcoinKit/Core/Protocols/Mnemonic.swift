//
//  MnemonicGenerator.swift
//  BitcoinKit
//
//  Created by Dmitry on 02.02.2018.
//

import Foundation

public protocol Mnemonic:Representable {
    
    init()
    init(withRepresentation representation:String)
}
