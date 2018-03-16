//
//  ExchangeService.swift
//  AFNetworking
//
//  Created by Dmitry on 09.03.2018.
//

import Foundation

public enum ExchangeServiceError:Int {
    
    case APIError
    
    public static var domain = "ExhangeServiceError"
    
    func errorObject(_ description:String) -> Error {
        
        return NSError.init(domain: ExchangeServiceError.domain,
                            code: self.rawValue,
                            userInfo: [NSLocalizedDescriptionKey : description])
    }
}

public protocol ExchangeServiceAuthCredentials {
    
    var userID:String? {get set}
    var apiKey:String? {get set}
    var secretKey:String? {get set}
}

public struct CoinKitExchangeServiceAuthCredentials:ExchangeServiceAuthCredentials {
    
    public var userID: String?
    public var apiKey: String?
    public var secretKey: String?
    
    public init() {
        
    }
}

public protocol ExchangeService {
    
    var authCredentials:ExchangeServiceAuthCredentials? {get set}
    
    func getAccountBalance(_ completition:@escaping ([String:Amount]?, Error?) -> Void)
}
