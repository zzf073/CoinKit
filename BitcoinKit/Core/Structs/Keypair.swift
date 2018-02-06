//
//  Keypair.swift
//  BitcoinKit
//
//  Created by Dmitry on 05.02.2018.
//

import Foundation

public struct KeyPair {
    
    public var publicKey:Key
    public var privateKey:Key
    
    public init(withPublicKey publicKey:Key, andPrivateKey privateKey:Key) {
        
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
}
