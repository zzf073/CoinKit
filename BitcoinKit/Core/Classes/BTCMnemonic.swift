//
//  MnemonicGenerator.swift
//  BitcoinKit
//
//  Created by Dmitry on 02.02.2018.
//

import Foundation
import CoreBitcoin

public class BTCMnemonic:Mnemonic {
    
    public var representation: String
    
    public required init?(withRepresentation representation: String) {
        
        guard BTCMnemonic.validateMnemonicRepresentation(representation) else {
            return nil
        }
        
        self.representation = representation
    }
    
    public static func createNewMnemonic() -> Mnemonic {
        
        let entropyData = BTCRandomDataWithLength(16) as Data!
        
        if let mnemonic = CoreBitcoin.BTCMnemonic.init(entropy: entropyData, password: nil, wordListType: .english), let words = mnemonic.words as? [String], let object = BTCMnemonic.init(withRepresentation: words.joined(separator: " ")) {
            
            return object
        }
        else {
            fatalError("Unable to generate new mnemonic")
        }
    }
    
    public static func validateMnemonicRepresentation(_ mnemonicRepresentation: String) -> Bool {
        return CoreBitcoin.BTCMnemonic.init(words: mnemonicRepresentation.components(separatedBy: " "),
                                            password: nil,
                                            wordListType: .english) != nil
    }
}
