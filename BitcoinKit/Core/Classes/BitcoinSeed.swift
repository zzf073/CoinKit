//
//  BitcoinSeed.swift
//  BitcoinKit
//
//  Created by Dmitry on 02.02.2018.
//

import Foundation

public class BitcoinSeed: Seed {
    
    public var data: Data
    public var representation: String {
        return data.hexString
    }
    
    public required convenience init?(withRepresentation representation: String) {
        
        guard let data = Data.dataWithHexString(representation) else {
            return nil
        }
        
        self.init(withData: data)
    }
    
    public required convenience init(withMnemonic mnemonic: Mnemonic) {
        
        self.init(withData: mnemonic.seedData)
    }
    
    public required init(withData data: Data) {
        
        self.data = data
    }
}
