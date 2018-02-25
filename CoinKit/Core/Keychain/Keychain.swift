//
//  Keychain.swift
//  AFNetworking
//
//  Created by Dmitry on 14.02.2018.
//

import Foundation
import CoreBitcoin

public class Keychain {
    
    public var mnemonic:String
    
    public init?(withMnemonic mnemonic:String) {
        
        guard MnemonicGenerator.validate(mnemonic) else {
            return nil
        }
        
        self.mnemonic = mnemonic
    }
    
    public func deriveWallet(_ type:WalletType, walletIndex:UInt = 0, accountIndex:UInt = 0) -> Wallet? {
        
        guard let mnemonicObject = BTCMnemonic.init(words: mnemonic.components(separatedBy: " "), password: nil, wordListType: .english) else {
            return nil
        }
        
        guard let key = mnemonicObject.keychain.derivedKeychain(withPath: "m/44'/\(type.rawValue)'/\(accountIndex)'/0/\(walletIndex)").key.privateKey as Data? else {
            return nil
        }
        
        switch type {
        case .BTC: return BTCWallet.init(withPrivateKey: key)
        case .ETH: return ETHWallet.init(withPrivateKey: key)
        }
    }
}
