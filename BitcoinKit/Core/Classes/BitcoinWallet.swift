//
//  BitcoinWallet.swift
//  BitcoinKit
//
//  Created by Dmitry on 05.02.2018.
//

import Foundation
import CoreBitcoin

public class BitcoinWallet:Wallet {
    
    public var address: String
    public var keypair: KeyPair
    
    public required init?(withKeyPair keyPair: KeyPair) {
        
        guard let publicKeyData = BTCHash160(keyPair.publicKey.data) as Data?, let publicKeyAddress = BTCPublicKeyAddress.init(data: publicKeyData as Data)  else {
            return nil
        }
        
        self.address = "14axBFKCz9vyLE9K79EWR8B7UsMUB3hF4k"// publicKeyAddress.string
        self.keypair = keyPair
    }
}
