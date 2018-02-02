//
//  BTCKeychain.swift
//  Arcane
//
//  Created by Dmitry on 02.02.2018.
//

import Foundation
import CoreBitcoin

public class BTCKeychain:Keychain {
    
    private var masterChain:Any?
    
    public required init(withMasterSeed masterSeed: MasterSeed) {
        
        let seed = BTCDataWithHexCString(NSString.init(string: masterSeed.representation).utf8String)
        
        if let masterChain = CoreBitcoin.BTCKeychain.init(seed: seed) {
            
            self.masterChain = masterChain
            
            NSLog("BIP32 Root Key: %@", masterChain.extendedPrivateKey)
        }
        else {
            fatalError("Unable to initiate keychain")
        }
    }
    
    public func getWallet(atIndex index: UInt) -> Wallet? {
        
        if let keychain = self.getBIP32Keychain() as? CoreBitcoin.BTCKeychain {
            
            if let key = keychain.key(at: UInt32(index)) {
                
                return BTCWallet.init()
            }
        }
        
        return nil
    }
    
    private func getBIP32Keychain() -> Any? {
        return self.getDerivedKeychain(purpose: 44, coin: 0, account: 0, change: 0)
    }
    
    private func getDerivedKeychain(purpose:UInt32, coin:UInt32, account:UInt32, change:UInt32) -> Any? {
        
        if let masterChain = self.masterChain as? CoreBitcoin.BTCKeychain {
            
            let path = "m/\(purpose)'/\(coin)'/\(account)'/\(change)"
            
            return masterChain.derivedKeychain(withPath: path)
        }
        
        return nil
    }
}
