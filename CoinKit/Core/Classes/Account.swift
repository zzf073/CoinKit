//
//  Account.swift
//  AFNetworking
//
//  Created by Dmitry on 14.02.2018.
//

import Foundation

public class Account {
    
    public var mnemonic:String
    public var btcWallet:Wallet {
        return self.walletForCoin(.BTC)
    }
    public var ethWallet:Wallet {
        return self.walletForCoin(.ETH)
    }
    
    public init?(withMnemonic mnemonic:String) {
        
        guard MnemonicGenerator.validate(mnemonic) else {
            return nil
        }
        
        self.mnemonic = mnemonic
    }
    
    public func walletForCoin(_ coinType:CoinType) -> Wallet {
        return getWalletType(coinType).init(withMnemonic: self.mnemonic)!
    }
}
