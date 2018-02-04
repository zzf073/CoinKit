//
//  MasterSeedGenerator.swift
//  BitcoinKit
//
//  Created by Dmitry on 02.02.2018.
//

import Foundation

public protocol MasterSeed:Representable {
    
    var data:Data{get}
    
    init(withData data:Data)
    init(withMnemonic mnemonic:Mnemonic)
}
