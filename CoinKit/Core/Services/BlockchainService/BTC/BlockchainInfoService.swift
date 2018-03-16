//
//  BlockchainInfoService.swift
//  AFNetworking
//
//  Created by Dmitry on 25.02.2018.
//

import Foundation
import CoreBitcoin
import Foundation
import AFNetworking

fileprivate class BlockchainInfoAmount: CryptoAmount {
    
    convenience init?(withDictionary dictionary:[String:Any]) {
        
        guard let finalBalance = dictionary["final_balance"] as? Int64 else {
            return nil
        }
        
        self.init(satoshiValue: Decimal.init(finalBalance))
    }
    
    convenience init(satoshiValue:Decimal) {
        
        let numberOfSatoshisInBTC = Decimal.init(100_000_000)
        
        let value = NSDecimalNumber.init(decimal:(satoshiValue / numberOfSatoshisInBTC)).doubleValue
        
        self.init(value: value)
    }
    
    public init(value: Double) {
        
        super.init(value: value, symbol: "BTC")
    }
}

open class BlockchainInfoService: BlockchainService {
    
    private var transport:HTTPTransport
    
    public required init(transport:HTTPTransport) {
        self.transport = transport
    }
    
    private func constructURLWithPath(_ path:String) -> String {
        
        let baseURLString = "https://blockchain.info"
        
        return baseURLString + path
    }
    
    public func getWalletsBalance(_ walletAddresses: [String], withCompletition completition: @escaping GetWalletBalanceCompletition) {
        
        self.transport.executeRequest(withURL: self.constructURLWithPath("/multiaddr"),
                                      params: ["active" : walletAddresses.joined(separator: "|")],
                                      method: .GET)
        { (result, error) in
            
            guard error == nil else {
                
                completition(nil, error)
                return
            }
            
            var operationResult = [String:Amount]()
            
            if let dictionary = result as? [String:Any], let addresses = dictionary["addresses"] as? [[String:Any]] {
                
                addresses.forEach({ (addressDictionary) in
                    
                    if let address = addressDictionary["address"] as? String, let balanceInSatoshi = addressDictionary["final_balance"] as? Int64 {
                        
                        let amount = BlockchainInfoAmount.init(satoshiValue: Decimal.init(balanceInSatoshi))
                        
                        operationResult[address] = amount
                    }
                })
            }
            
            completition(operationResult, nil)
        }
    }
}

