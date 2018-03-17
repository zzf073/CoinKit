//
//  BinanceService.swift
//  AFNetworking
//
//  Created by Дмитрий on 17.03.2018.
//

import Foundation
import Arcane
import CCommonCrypto
import Alamofire

public extension Dictionary where Key: ExpressibleByStringLiteral, Value: ExpressibleByStringLiteral {
    var queryString: String {
        var postDataString = ""
        forEach { tuple in
            if postDataString.count != 0 {
                postDataString += "&"
            }
            postDataString += "\(tuple.key)=\(tuple.value)"
        }
        return postDataString
    }
}

class BinanceService:ExchangeService {
    
    init() { }
    
    var authCredentials: ExchangeServiceAuthCredentials?
    
    func getAccountBalance(_ completition: @escaping ([String : Amount]?, Error?) -> Void) {

        guard let apiKey = self.authCredentials?.apiKey, let secretKey = self.authCredentials?.secretKey else {
            
            return completition(nil, ExchangeServiceError.IncompleteCredentials.errorObject("No API key or secret key provided"))
        }
        
        var params = [String:String]()
        
        params["timestamp"] = String(Int(Date().timeIntervalSince1970 * 1000))
        params["recvWindow"] = String(Int64.max)
        
        guard let signature = HMAC.SHA256(params.queryString, key: secretKey) else {
            
            return completition(nil, ExchangeServiceError.SignError.errorObject("Cannot sign request"))
        }
        
        params["signature"] = signature
        
        Alamofire.request(URL.init(string: "https://api.binance.com/api/v3/account?" + params.queryString)!,
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: ["X-MBX-APIKEY" : apiKey]).responseJSON
        { (response) in
            
            guard response.error == nil else {
                return completition(nil, response.error)
            }
            
            guard let dictionary = response.result.value as? [String:Any], let balances = dictionary["balances"] as? [[String:Any]] else {
                return completition(nil, ExchangeServiceError.ParsingError.errorObject("Unable to parse"))
            }
            
            var result = [String:Amount]()
            
            balances.forEach({ (balance) in
                
                if var symbol = balance["asset"] as? String {
                    
                    if let freeString = balance["free"] as? String, let lockedString = balance["locked"] as? String {
                        
                        if let freeValue = Double(freeString), let lockedValue = Double(lockedString) {
                            
                            let total = freeValue + lockedValue
                            
                            if total > 0 {
                                
                                if symbol == "BCC" { //wtf, binance?
                                    symbol = "BCH"
                                }
                                
                                result[symbol.uppercased()] = BaseAmount.init(value: total, symbol: symbol.uppercased())
                            }
                        }
                    }
                }
            })
            
            completition(result, nil)
        }
    }
}
