//
//  BTCMasterSeed.swift
//  BitcoinKit
//
//  Created by Dmitry on 02.02.2018.
//

import Foundation
import Arcane
import CCommonCrypto

public class BTCMasterSeed: MasterSeed {
    public var data: Data
    
    public var representation: String {
        return data.hexString
    }
    
    public required convenience init(withMnemonic mnemonic: Mnemonic) {
        
        let mnemonicData = mnemonic.representation.data(using: String.Encoding.utf8)
        let salt = "mnemonic".data(using: String.Encoding.utf8)
        
        let rounds:UInt = 2048
        let derivedKeyLen:Int = 64
        
        let key = [CUnsignedChar](repeating: 0, count: derivedKeyLen)
        
        let unsafeMutablePointerOfPassData: UnsafePointer<Int8> = (mnemonicData! as NSData).bytes.bindMemory(to: Int8.self, capacity: mnemonicData!.count)
        let unsafeMutablePointerOfSaltData: UnsafePointer<UInt8> = (salt! as NSData).bytes.bindMemory(to: UInt8.self, capacity: salt!.count)
        let unsafeMutablePointerOfKey: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(mutating: key)
        CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),unsafeMutablePointerOfPassData,mnemonicData!.count,unsafeMutablePointerOfSaltData,salt!.count,CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA512),CUnsignedInt(rounds),unsafeMutablePointerOfKey,derivedKeyLen)
        
        let len = MemoryLayout<CUnsignedChar>.size * Int(derivedKeyLen)
        
        let masterSeedData = Data(bytes: UnsafePointer<UInt8>(unsafeMutablePointerOfKey), count: len)
        
        self.init(withData: masterSeedData)
    }
    
    public required init(withData data: Data) {
        
        self.data = data
    }
}
