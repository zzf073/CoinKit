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
    var privateKey: Key?
    var mnemonic: String?
    
    public var coinType: CoinType {
        return CoinType.ETH
    }
    
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
        
        self.init(withPrivateKey: Key.init(withData: account.privateKey))
        
        self.mnemonic = mnemonic
    }
    
    required init?(withPrivateKey key: Key) {
        
        guard let account = Account.init(privateKey: key.data) else {
            return nil
        }
        
        self.address = account.address.checksumAddress
        self.privateKey = key
    }
}

