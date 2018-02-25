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
    public var privateKey: Data?
    
    public var walletType: WalletType {
        return .BTC
    }
    
    required public init(withAddress address: String) {
        self.address = address
    }
    
    public required init?(withPrivateKey key: Data) {
        guard let btcKey = BTCKey.init(privateKey: key) else {
            return nil
        }
        
        self.address = btcKey.compressedPublicKeyAddress.string
        self.privateKey = key
    }
}
