//
//  Container.swift
//  Arcane
//
//  Created by Dmitry on 04.02.2018.
//

import Foundation

public protocol Container {
    
    var mnemonic:Mnemonic? {get}
    var masterSeed:MasterSeed {get}
    var keychain:Keychain{get}
    
    init(withMnemonic mnemonic:Mnemonic)
    init(withMasterSeed masterSeed:MasterSeed)
}
