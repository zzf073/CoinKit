//
//  StackContainer.swift
//  BitcoinKit
//
//  Created by Dmitry on 05.02.2018.
//

import Foundation

public protocol StackContainer {
    
    var mnemonic:Mnemonic? {get}
    var seed:Seed {get}
    var keychain:Keychain {get}
    
    init(withMnemonic mnemonic:Mnemonic)
    init(withSeed seed:Seed)
    
    func deriverWallet(atIndex index:Int, forAccount accoun:Int) -> Wallet?
    func deriverDefaultWallet() -> Wallet?
}
