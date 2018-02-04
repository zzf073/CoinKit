//
//  MnemonicGenerator.swift
//  BitcoinKit
//
//  Created by Dmitry on 02.02.2018.
//

import Foundation

public protocol Mnemonic:Representable {
    
    static func createNewMnemonic() -> Mnemonic
    static func validateMnemonicRepresentation(_ mnemonicRepresentation:String) -> Bool
    
}
