//
//  BlockchainServiceLocator.swift
//  AFNetworking
//
//  Created by Dmitry on 26.02.2018.
//

import Foundation

public protocol BlockchainServiceLocator {
    
    func setWalletService(_ service:BlockchainService?, _ type:WalletType)
    func walletService(_ type:WalletType) -> BlockchainService?
    
    subscript(type:WalletType) -> BlockchainService? {get set}
}

open class BaseCoinKitServiceLocator:BlockchainServiceLocator {
    
    public init() {
        
    }
    
    public subscript(type: WalletType) -> BlockchainService? {
        get {
            return self.walletService(type)
        }
        set {
            self.setWalletService(newValue, type)
        }
    }
    
    private var walletServices = [WalletType:BlockchainService]()
    
    public func setWalletService(_ service: BlockchainService?, _ type: WalletType) {
        
        self.walletServices[type] = service
    }
    
    public func walletService(_ type: WalletType) -> BlockchainService? {
        
        return self.walletServices[type]
    }
}
