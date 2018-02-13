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
    public var privateKey: Key?
    public var mnemonic: String?
    
    public var coinType: CoinType {
        return CoinType.BTC
    }
    
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
        
        self.init(withPrivateKey: Key.init(withData: key.privateKey as Data))
        
        self.mnemonic = mnemonic
    }
    
    public required init?(withPrivateKey key: Key) {
        guard let btcKey = BTCKey.init(privateKey: key.data) else {
            return nil
        }
        
        self.address = btcKey.compressedPublicKeyAddress.string
        self.privateKey = key
    }
}
