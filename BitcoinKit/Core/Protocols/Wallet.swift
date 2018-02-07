//
//  Wallet.swift
//  BitcoinKit
//
//  Created by Dmitry on 05.02.2018.
//

import Foundation

public protocol Wallet {
    
    var address:String {get}
    var keypair:KeyPair? {get}
    
    init(withAddress address:String)
    init?(withKeyPair keyPair:KeyPair)
}
