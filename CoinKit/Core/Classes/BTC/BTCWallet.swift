//
//  BTCWallet.swift
//  AFNetworking
//
//  Created by Dmitry on 12.02.2018.
//

import Foundation
import CoreBitcoin

public class BTCWallet: Wallet {
    
    public var address: String
    public var keypair: KeyPair?
    public var mnemonic: String?    
    
    public static func createNewWallet() -> Wallet {
        
        guard let wallet = BTCWallet.init(withMnemonic: MnemonicGenerator.generate()) else {
            fatalError("Unable to create new wallet with mnemonic")
        }
        
        return wallet
    }
    
    required public init(withAddress address: String) {
        self.address = address
    }
    
    required convenience public init?(withMnemonic mnemonic: String) {
        
        guard let mnemonicObject = BTCMnemonic.init(words: mnemonic.components(separatedBy: " "), password: nil, wordListType: .english) else {
            return nil
        }
        
        guard let key = mnemonicObject.keychain.derivedKeychain(withPath: "m/44'/0'/0'/0/0").key else {
            return nil
        }
        
        let publicKey = Key.init(withData: key.publicKey as Data)
        let privateKey = Key.init(withData: key.privateKey as Data)
        
        let keypair = KeyPair.init(withPublicKey: publicKey, andPrivateKey: privateKey)
        
        self.init(withKeyPair: keypair)
        
        self.mnemonic = mnemonic
    }
    
    required public init?(withKeyPair keyPair: KeyPair) {
        
        guard let key = BTCKey.init(privateKey: keyPair.privateKey.data) else {
            return nil
        }
        
        self.address = key.compressedPublicKeyAddress.string
        self.keypair = keyPair
    }
}
