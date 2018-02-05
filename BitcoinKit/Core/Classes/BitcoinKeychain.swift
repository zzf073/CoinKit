//
//  BitcoinKeychain.swift
//  Arcane
//
//  Created by Dmitry on 02.02.2018.
//

import Foundation
import CoreBitcoin

public class BitcoinKeychain:Keychain {
    
    private var masterChain:Any
    
    public var extendedKeyPair: KeyPair
    
    public required init(withSeed seed: Seed) {

        let seed = BTCDataWithHexCString(NSString.init(string: seed.representation).utf8String)

        if let masterChain = CoreBitcoin.BTCKeychain.init(seed: seed), let publicKey = masterChain.extendedPublicKey, let privateKey = masterChain.extendedPrivateKey {

            self.masterChain = masterChain
            
            self.extendedKeyPair = KeyPair.init(withPublicKey: Key.init(withRepresentation: publicKey)!,
                                                andPrivateKey: Key.init(withRepresentation: privateKey)!)
        }
        else {
            fatalError("Unable to initiate keychain")
        }
    }
    
    public func getDerivedKeyPair(purpose: Int = 44, coin: Int = 0, account: Int = 0, change: Int = 0, index: Int) -> KeyPair? {
        
        if let key:BTCKey = self.getDerivedKey(purpose: purpose, coin: coin, account: account, change: change, index: index) as? BTCKey {
            
            if let publicKeyData = key.publicKey as Data?, let privateKeyData = key.privateKey as Data? {
                
                return KeyPair.init(withPublicKey: Key.init(withData: publicKeyData), andPrivateKey: Key.init(withData: privateKeyData))
            }
        }
        
        return nil
    }
    
    //MARK: - Private
    
    private func getDerivedKeychain(purpose: Int, coin: Int, account: Int, change: Int) -> Any? {
        
        
        if let masterChain = self.masterChain as? BTCKeychain {
            
            let path = "m/\(purpose)'/\(coin)'/\(account)'/\(change)"
            
            return masterChain.derivedKeychain(withPath: path)
        }
        
        return nil
    }
    
    private func getDerivedKey(purpose: Int, coin: Int, account: Int, change: Int, index:Int) -> Any? {
        
        return (self.getDerivedKeychain(purpose: purpose, coin: coin, account: account, change: change) as? BTCKeychain)?.key(at: UInt32(index))
    }
}
