//
//  Keychain.swift
//  Arcane
//
//  Created by Dmitry on 02.02.2018.
//

import Foundation

public protocol Keychain {
    
    init(withMasterSeed masterSeed:MasterSeed)
    
    func getWallet(atIndex index:UInt) -> Wallet?
}
