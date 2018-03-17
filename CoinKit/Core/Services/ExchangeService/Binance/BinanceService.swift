//
//  BinanceService.swift
//  AFNetworking
//
//  Created by Дмитрий on 17.03.2018.
//

import Foundation
import Cryptex

class BinanceService:ExchangeService {
    
    init() {
        
    }
    
    var authCredentials: ExchangeServiceAuthCredentials? {
        didSet {
            
            if let apiKey = self.authCredentials?.apiKey, let secretKey = self.authCredentials?.secretKey {
                
                self.service = Binance.Service.init(key: apiKey,
                                                    secret: secretKey,
                                                    session: URLSession.shared,
                                                    userPreference: .USD_BTC,
                                                    currencyOverrides: nil)
            }
        }
    }
    
    private var service:Binance.Service?
    
    func getAccountBalance(_ completition: @escaping ([String : Amount]?, Error?) -> Void) {

        guard self.service != nil else {
            return completition(nil, ExchangeServiceError.IncompleteCredentials.errorObject("No api key or secret key provided"))
        }
        
        self.service?.getAccount(completion: { (type) in
            
            if let code = self.service?.store.accountResponse.response?.statusCode, code == 200 {
                
                if let balances = self.service?.store.accountResponse.account?.balances {
                    
                    var result = [String:Amount]()
                    
                    balances.forEach({ (balance) in
                        
                        let symbol = balance.currency.code
                        
                        result[symbol] = BaseAmount.init(value: balance.locked.adding(balance.quantity).doubleValue, symbol: symbol)
                    })
                    
                    completition(result, nil)
                }
                else {
                    completition(nil, ExchangeServiceError.ParsingError.errorObject("Cannot parse balances"))
                }
            }
            else {
                completition(nil, ExchangeServiceError.APIError.errorObject("Invalid API keys"))
            }
        })
    }
}
