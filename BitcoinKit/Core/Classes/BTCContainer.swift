//
//  BTCContainer.swift
//  Arcane
//
//  Created by Dmitry on 04.02.2018.
//

import Foundation
import CoreBitcoin

open class BTCContainer: Container {
    
    public var mnemonic: Mnemonic?
    public var masterSeed: MasterSeed
    public var keychain: Keychain
    
    required public convenience init(withMnemonic mnemonic: Mnemonic) {
        
        self.init(withMasterSeed: BTCMasterSeed.init(withMnemonic: mnemonic))
        
        self.mnemonic = mnemonic
    }
    
    required public init(withMasterSeed masterSeed: MasterSeed) {
        
        self.masterSeed = masterSeed
        self.keychain = BTCKeychain.init(withMasterSeed: masterSeed)
    }
}
