//
//  ETHWallet.swift
//  AFNetworking
//
//  Created by Dmitry on 12.02.2018.
//

import Foundation
import ethers

class ETHWallet: Wallet {
    
    var address: String
    var keypair: KeyPair?
    var mnemonic: String?
    
    static func createNewWallet() -> Wallet {
        
        guard let wallet = ETHWallet.init(withMnemonic: MnemonicGenerator.generate()) else {
            fatalError("Unable to create new wallet")
        }
        
        return wallet
    }
    
    required init(withAddress address: String) {
        
        self.address = address
    }
    
    required convenience init?(withMnemonic mnemonic: String) {
        
        guard let account = Account.init(mnemonicPhrase: mnemonic) else {
            return nil
        }
        
        let privateKey = Key.init(withData: account.privateKey)
        let publiKey = Key.init(withData: Data.init())
        
        self.init(withKeyPair: KeyPair.init(withPublicKey: publiKey, andPrivateKey: privateKey))
        
        self.mnemonic = mnemonic
    }
    
    required init?(withKeyPair keyPair: KeyPair) {
        
        guard let account = Account.init(privateKey: keyPair.privateKey.data) else {
            return nil
        }
        
        self.address = account.address.checksumAddress
        self.keypair = keyPair
    }
}

