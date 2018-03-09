//
//  ExchangeService.swift
//  AFNetworking
//
//  Created by Dmitry on 09.03.2018.
//

import Foundation

public protocol ExchangeServiceAuthCredentials {
    
    var apiKey:String? {get set}
    var secretKey:String? {get set}
}

public struct CoinKitExchangeServiceAuthCredentials:ExchangeServiceAuthCredentials {
    
    public var apiKey: String?
    public var secretKey: String?
    
    public init() {
        
    }
}

public protocol ExchangeService {
    
    var authCredentials:ExchangeServiceAuthCredentials? {get set}
    
    func getAccountBalance(_ completition:([String:Double]?, Error?) -> Void)
}
