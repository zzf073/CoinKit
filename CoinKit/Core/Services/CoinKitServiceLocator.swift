//
//  CoinKitServiceLocator.swift
//  AFNetworking
//
//  Created by Dmitry on 26.02.2018.
//

import Foundation

public protocol CoinKitServiceLocator {
    
    var marketService:MarketService? {get set}
    
    func setWalletService(_ service:WalletService?, _ type:WalletType)
    func walletService(_ type:WalletType) -> WalletService?
    
}

public class BaseCoinKitServiceLocator:CoinKitServiceLocator {
    
    public var marketService: MarketService?
    
    public init() {
        
    }
    
    private var walletServices = [WalletType:WalletService]()
    
    public func setWalletService(_ service: WalletService?, _ type: WalletType) {
        
        self.walletServices[type] = service
    }
    
    public func walletService(_ type: WalletType) -> WalletService? {
        
        return self.walletServices[type]
    }
}
