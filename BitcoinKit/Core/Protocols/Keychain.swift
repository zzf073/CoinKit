//
//  Keychain.swift
//  Arcane
//
//  Created by Dmitry on 02.02.2018.
//

import Foundation

public protocol Keychain {
    
    init(withMasterSeed masterSeed:MasterSeed)
    
    func derivedWallet(atIndex index:UInt) -> Wallet?
}
