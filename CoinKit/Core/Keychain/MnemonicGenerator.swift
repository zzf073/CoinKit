//
//  MnemonicGenerator.swift
//  AFNetworking
//
//  Created by Dmitry on 12.02.2018.
//

import Foundation
import CoreBitcoin

public class MnemonicGenerator {
    
    public static func generate() -> String {
        
        let entropy = BTCRandomDataWithLength(16) as Data
        
        let mnemonic = BTCMnemonic.init(entropy: entropy, password: nil, wordListType: .english)!
        
        return (mnemonic.words as! [String]).joined(separator: " ")
    }
    
    public static func validate(_ mnemonic:String) -> Bool {
        return BTCMnemonic.init(words: mnemonic.components(separatedBy: " "), password: nil, wordListType: .english) != nil
    }
}
