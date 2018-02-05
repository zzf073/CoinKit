//
//  Keychain.swift
//  Arcane
//
//  Created by Dmitry on 02.02.2018.
//

import Foundation

public protocol Keychain {
    
    var extendedKeyPair:KeyPair {get}
    
    init (withSeed seed:Seed)
    
    func getDerivedKeyPair(purpose:Int, coin:Int, account:Int, change:Int, index:Int) -> KeyPair?
}
