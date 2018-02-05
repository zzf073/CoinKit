//
//  File.swift
//  BitcoinKit
//
//  Created by Dmitry on 05.02.2018.
//

import Foundation

public struct Key:DataRepresentable {
    
    public var data: Data
    public var representation: String {
        return data.hexString
    }
    
    public init?(withRepresentation representation: String) {
        
        guard let data = Data.dataWithHexString(representation) else {
            return nil
        }
        
        self.init(withData: data)
    }
    
    public init(withData data: Data) {
        
        self.data = data
    }
}
