//
//  BitcoinMnemonic.swift
//  BitcoinKit
//
//  Created by Dmitry on 02.02.2018.
//

import Foundation
import CoreBitcoin

public class BitcoinMnemonic:Mnemonic {
    
    public var representation: String
    public var seedData: Data
    
    public required convenience init?(withRepresentation representation: String) {
        
        guard let mnemonic = BitcoinMnemonic.createBTCMnemonicWithRepresentation(representation) else {
            return nil
        }
        
        self.init(withBTCMnemonic: mnemonic as! BTCMnemonic)
    }
    
    public static func generateNewMnemonic() -> Mnemonic {
        return BitcoinMnemonic.init(withBTCMnemonic: BitcoinMnemonic.createBTCMnemonic() as! BTCMnemonic)
    }
    
    public static func validateMnemonicRepresentation(_ mnemonicRepresentation: String) -> Bool {
        return BitcoinMnemonic.createBTCMnemonicWithRepresentation(mnemonicRepresentation) != nil
    }
    
    //MARK: - Private
    
    fileprivate init(withBTCMnemonic btcMnemonic:Any) {
        
        let mnemonic = btcMnemonic as! BTCMnemonic
        
        self.seedData = mnemonic.seed
        self.representation = (mnemonic.words as! [String]).joined(separator: " ")
    }
    
    fileprivate static func createBTCMnemonicWithRepresentation(_ representation:String) -> Any? {
        
        return BTCMnemonic.init(words: representation.components(separatedBy: " "),
                                password: nil,
                                wordListType: .english)
    }
    
    fileprivate static func createBTCMnemonic() -> Any {
        
        let entropyData = BTCRandomDataWithLength(16) as Data!
        
        return BTCMnemonic.init(entropy: entropyData, password: nil, wordListType: .english)
    }
}
