//
//  CexService.swift
//  AFNetworking
//
//  Created by Дмитрий on 16.03.2018.
//

import Foundation
import Alamofire
import Arcane
import CCommonCrypto

public class CexService:ExchangeService {
    
    private var nonce = Int(Date().timeIntervalSince1970)
    
    public var authCredentials: ExchangeServiceAuthCredentials?
    
    public func getAccountBalance(_ completition: @escaping ([String : Amount]?, Error?) -> Void) {
        
        guard let userID = self.authCredentials?.userID,
              let apiKey = self.authCredentials?.apiKey,
              let secretKey = self.authCredentials?.secretKey else
        {
            
            //GENERATE ERROR
            return
        }
        
        self.nonce += 1
        
        let nonce = self.nonce
        
        let signatureString = HMAC.SHA256("\(nonce)\(userID)\(apiKey)", key: secretKey)!
        
        let parameters = ["key" : apiKey,
                          "nonce" : String(nonce),
                          "signature" : signatureString]
        
        Alamofire.request(URL.init(string: "https://cex.io/api/balance/")!,
                          method: .post,
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: nil).responseJSON
        { (response) in
          
            if response.error != nil || !response.result.isSuccess {
                
                return completition(nil, response.error)
            }
            
            if let dictionary = response.result.value as? [String:Any] {
                
                if let errorString = dictionary["error"] as? String {
                    return completition(nil, ExchangeServiceError.APIError.errorObject(errorString))
                }
                else {
                    
                    var balance = [String:Amount]()
                    
                    dictionary.forEach({ (object) in
                        
                        if let balanceObject = object.value as? [String:Any] {
                            
                            let coinSymbol = object.key.uppercased()
                            
                            if let ordersBalance = balanceObject["orders"] as? String,
                               let availableBalance = balanceObject["available"] as? String
                            {
                                if let ordersValue = Double(ordersBalance), let availableValue = Double(availableBalance) {
                                    
                                    let totalBalance = availableValue + ordersValue
                                    
                                    if totalBalance > 0 {
                                        balance[coinSymbol] = BaseAmount.init(value: totalBalance, symbol: coinSymbol)
                                    }
                                }
                            }
                        }
                    })
                    
                    completition(balance, nil)
                }
            }
            else {
                completition(nil, nil)
            }
        }
    }
}
