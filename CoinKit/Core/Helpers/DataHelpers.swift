//
//  DataHelpers.swift
//  Arcane
//
//  Created by Dmitry on 04.02.2018.
//

import Foundation

extension Data {
    
    static func dataWithHexString(_ hexString:String) -> Data? {
        
        var data = Data(capacity: hexString.characters.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: hexString, range: NSMakeRange(0, hexString.utf16.count)) { match, flags, stop in
            let byteString = (hexString as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    
    var hexString: String {
        var result = ""
        
        var bytes = [UInt8](repeating: 0, count: count)
        copyBytes(to: &bytes, count: count)
        
        for byte in bytes {
            result += String(format: "%02x", UInt(byte))
        }
        
        return result
    }
}
