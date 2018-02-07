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
    public var keypair: KeyPair?
    
    public required convenience init?(withKeyPair keyPair: KeyPair) {
        
        guard let publicKeyData = BTCHash160(keyPair.publicKey.data) as Data?, let publicKeyAddress = BTCPublicKeyAddress.init(data: publicKeyData as Data)  else {
            return nil
        }
        
        self.init(withAddress: publicKeyAddress.string)
        
        self.keypair = keyPair
    }
    
    public required init(withAddress address:String) {
        self.address = address
    }
}
