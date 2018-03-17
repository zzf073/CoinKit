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
    
    private static var nonce = Int(Date().timeIntervalSince1970)
    private static var operationQueue:OperationQueue = {
        
        var queue = OperationQueue.init()
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()
    
    public var authCredentials: ExchangeServiceAuthCredentials?
    
    public func getAccountBalance(_ completition: @escaping ([String : Amount]?, Error?) -> Void) {
        
        let operation = BlockOperation.init {
            
            guard let userID = self.authCredentials?.userID,
                let apiKey = self.authCredentials?.apiKey,
                let secretKey = self.authCredentials?.secretKey else
            {
                DispatchQueue.main.async {
                    completition(nil, ExchangeServiceError.IncompleteCredentials.errorObject("userID, apiKey and secretKey is required"))
                }
                
                return
            }
            
            CexService.nonce += 1
            
            let nonce = CexService.nonce
            
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
                        
                        completition(nil, response.error ?? ExchangeServiceError.UnknownError.errorObject("Something went wrong, please try again later"))
                    }
                    else if let dictionary = response.result.value as? [String:Any] {
                        
                        if let errorString = dictionary["error"] as? String {
                            completition(nil, ExchangeServiceError.APIError.errorObject(errorString))
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
                        completition(nil, ExchangeServiceError.ParsingError.errorObject("Unable to parse balances"))
                    }
                    
                    CexService.operationQueue.isSuspended = false
            }
            
            CexService.operationQueue.isSuspended = true
        }
        
        if let lastOperation = CexService.operationQueue.operations.last {
            operation.addDependency(lastOperation)
        }
        
        CexService.operationQueue.addOperation(operation)
    }
}
