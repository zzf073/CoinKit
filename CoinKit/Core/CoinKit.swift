//
//  Types.swift
//  AFNetworking
//
//  Created by Dmitry on 12.02.2018.
//

import Foundation
import CoreBitcoin
import ethers

public enum WalletType:Int {
    case BTC = 0
    case ETH = 60
    
    public static var availableTypes:[WalletType] = {
        
        var result = [WalletType]()
        
        for i in 0..<100 {
            if let type = WalletType.init(rawValue: i) {
                result.append(type)
            }
        }
        
        return result
    }()
    
    public func validateAddress(_ addressString:String) -> Bool {
        
        switch self {
        case .BTC: return BTCAddress.init(string: addressString) != nil
        case .ETH: return Address.init(string: addressString) != nil
        }
    }
    
    public func coinName() -> String {
        
        switch self {
        case .BTC: return "Bitcoin"
        case .ETH: return "Etherium"
        }
    }
    
    public func coinSymbol() -> String {
        
        switch self {
        case .BTC: return "BTC"
        case .ETH: return "ETH"
        }
    }
}
