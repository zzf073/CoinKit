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
    
    public func validateAddress(_ addressString:String) -> Bool {
        
        switch self {
        case .BTC: return BTCAddress.init(string: addressString) != nil
        case .ETH: return Address.init(string: addressString) != nil
        }
    }
}
