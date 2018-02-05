//
//  Mnemonic.swift
//  BitcoinKit
//
//  Created by Dmitry on 02.02.2018.
//

import Foundation

public protocol Mnemonic:Representable {
    
    var seedData:Data {get}
    
    static func generateNewMnemonic() -> Mnemonic
    static func validateMnemonicRepresentation(_ mnemonicRepresentation:String) -> Bool
}
