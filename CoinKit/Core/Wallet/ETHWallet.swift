//
//  ETHWallet.swift
//  AFNetworking
//
//  Created by Dmitry on 12.02.2018.
//

import Foundation
import ethers

public class ETHWallet: Wallet {
    
    public var address: String
    public var privateKey: Data?
    
    public var walletType: WalletType {
        return .ETH
    }
    
    required public init(withAddress address: String) {
        
        self.address = address
    }
    
    required public init?(withPrivateKey key: Data) {
        
        guard let account = ethers.Account.init(privateKey: key) else {
            return nil
        }
        
        self.address = account.address.checksumAddress
        self.privateKey = key
    }
}

