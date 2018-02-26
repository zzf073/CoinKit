//
//  BlockchainServiceLocator.swift
//  AFNetworking
//
//  Created by Dmitry on 25.02.2018.
//

import Foundation

public protocol BlockchainServiceLocator {
    
    func setBlockchainService(_ service:BlockchainService?, forWalletType type:WalletType)
    func getBlockchainService(forWalletType type:WalletType) -> BlockchainService?
    
    subscript(type:WalletType) -> BlockchainService? {get set}
}

public class BaseBlockchainServiceLocator:BlockchainServiceLocator {
    
    private var registry = [WalletType:BlockchainService]()
    
    public init() {
        
    }
    
    public subscript(type:WalletType) -> BlockchainService? {
        get {
            return self.getBlockchainService(forWalletType: type)
        }
        set(newValue) {
            self.setBlockchainService(newValue, forWalletType: type)
        }
    }
    
    public func setBlockchainService(_ service: BlockchainService?, forWalletType type: WalletType) {
        self.registry[type] = service
    }
    
    public func getBlockchainService(forWalletType type: WalletType) -> BlockchainService? {
        return self.registry[type]
    }
}
