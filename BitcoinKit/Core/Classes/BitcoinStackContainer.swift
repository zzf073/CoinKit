//
//  BitcoinStackContainer.swift
//  BitcoinKit
//
//  Created by Dmitry on 05.02.2018.
//

import Foundation

public class BitcoinStackContainer: StackContainer {
    
    public var mnemonic: Mnemonic?
    public var seed: Seed
    public var keychain: Keychain
    
    required public convenience init(withMnemonic mnemonic: Mnemonic) {
        
        self.init(withSeed: BitcoinSeed.init(withMnemonic: mnemonic))
        
        self.mnemonic = mnemonic
    }
    
    required public init(withSeed seed: Seed) {
        self.seed = seed
        self.keychain = BitcoinKeychain.init(withSeed: seed)
    }
    
    public func deriverDefaultWallet() -> Wallet? {
        return self.deriverWallet()
    }
    
    public func deriverWallet(atIndex index: Int = 0, forAccount account: Int = 0) -> Wallet? {
        
        if let keyPair = (self.keychain as! BitcoinKeychain).getDerivedKeyPair(purpose: 44, coin: 0, account: account, change: 0, index: index) {
            
            return BitcoinWallet.init(withKeyPair: keyPair)
        }
        
        return nil
    }
}
