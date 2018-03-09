//
//  BlockchainServiceLocator.swift
//  AFNetworking
//
//  Created by Dmitry on 26.02.2018.
//

import Foundation

public protocol BlockchainServiceLocator {
    
    subscript(type:WalletType) -> BlockchainService? {get set}
    subscript(type:ExchangeType) -> ExchangeService? {get set}
}

open class BaseCoinKitServiceLocator:BlockchainServiceLocator {
    
    private var walletServices = [WalletType:BlockchainService]()
    private var exchangeServices = [ExchangeType:ExchangeService]()
    
    public init() {
        
    }
    
    public subscript(type: WalletType) -> BlockchainService? {
        get {
            return self.walletServices[type]
        }
        set {
            self.walletServices[type] = newValue
        }
    }
    
    public subscript(type: ExchangeType) -> ExchangeService? {
        get {
            return self.exchangeServices[type]
        }
        set {
            self.exchangeServices[type] = newValue
        }
    }
}
