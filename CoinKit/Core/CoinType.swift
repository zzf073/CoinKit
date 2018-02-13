//
//  CoinType.swift
//  AFNetworking
//
//  Created by Dmitry on 12.02.2018.
//

import Foundation

public enum CoinType {
    case BTC, ETH
}

public func getWalletType(_ coinType:CoinType) -> Wallet.Type {
    switch coinType {
    case .BTC: return BTCWallet.self
    case .ETH: return ETHWallet.self
    }
}


public func getBlockchainServiceType(_ coinType:CoinType) -> BlockchainService.Type {
    
    switch coinType {
    case .BTC: return BTCBlockchainService.self
    case .ETH: return ETHBlockchainService.self
    }
}
