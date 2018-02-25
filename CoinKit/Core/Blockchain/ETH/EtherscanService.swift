//
//  EtherscanService.swift
//  AFNetworking
//
//  Created by Dmitry on 12.02.2018.
//

import Foundation
import ethers
import AFNetworking

fileprivate class EtherscanAmount:BaseAmount {
    
    convenience init(weiValue:Decimal) {
        
        let numberOfWeiInEth = Decimal.init(string: "1000000000000000000")!
        
        let value = NSDecimalNumber.init(decimal:(weiValue / numberOfWeiInEth)).doubleValue
        
        self.init(value: value)
    }
    
    public init(value: Double) {
        super.init(value: value, symbol: "Ξ")
    }
}

fileprivate class EtherscanTransaction:Transaction {
    var transactionHash: String
    var time: Date
    var size: Int
    var blockHeight: Int
    var weight: Int
    var inputAddresses: [String]
    var inputAmounts: [Amount]
    var outputAddresses: [String]
    var outputAmounts: [Amount]
    
    init?(transactionDictionary:[String:Any]) {
        
        guard let hash = transactionDictionary["hash"] as? String else {
            return nil
        }
        
        guard let timestampString = transactionDictionary["timeStamp"] as? String, let timeInterval = Double(timestampString) else {
            return nil
        }
        
        guard let blockNumberString = transactionDictionary["blockNumber"] as? String, let blockNumber = Int(blockNumberString) else {
            return nil
        }
        
        guard let senderAddress = transactionDictionary["from"] as? String, let receiverAddress = transactionDictionary["to"] as? String else {
            return nil
        }
        
        let value = NSDecimalNumber.init(string: transactionDictionary["value"] as? String).decimalValue
        
        self.transactionHash = hash
        self.time = Date.init(timeIntervalSince1970: timeInterval)
        self.size = 0
        self.blockHeight = blockNumber
        self.weight = 0
        self.inputAddresses = [senderAddress]
        self.inputAmounts = [EtherscanAmount.init(weiValue: value)]
        self.outputAddresses = [receiverAddress]
        self.outputAmounts = [EtherscanAmount.init(weiValue: value)]
    }
    
    func isOutgoingForAddress(_ address: String) -> Bool? {
        return false
    }
    
    func getAmountForAddress(_ address: String) -> Amount? {
        return nil
    }
}

public class EtherscanService: BlockchainService {
    
    private var apiKey:String
    private var transport:HTTPTransport
    private var apiURLString = "https://api.etherscan.io/api"
    
    public init(apiKey:String, transport:HTTPTransport) {
        
        self.apiKey = apiKey
        self.transport = transport
    }
    
    public func getWalletsBalance(_ walletAddresses: [String], withCompletition completition: @escaping GetWalletBalanceCompletition) {
        
        var params = [String:Any]()
        
        params["module"] = "account"
        params["action"] = "balancemulti"
        params["tag"] = "latest"
        params["apikey"] = self.apiKey
        params["address"] = walletAddresses.joined(separator: ",")
        
        self.transport.executeRequest(withURL: self.apiURLString, params: params, method: .GET) { (result, error) in
            
            guard error == nil else {
                
                completition(nil, error)
                return
            }
            
            var operationResult = [String:Amount]()
            
            if let dictionary = result as? [String:Any] {
                
                if let array = dictionary["result"] as? [[String:Any]] {
                    
                    array.forEach({ (object) in
                        
                        if let address = object["account"] as? String {
                            
                            let amount = EtherscanAmount.init(weiValue: NSDecimalNumber.init(string: object["balance"] as? String).decimalValue)
                            
                            operationResult[address] = amount
                        }
                    })
                }
            }
            
            completition(operationResult, nil)
        }
    }
    
    public func getWalletTransactions(_ walletAddress: String,
                                      offset: UInt,
                                      count: UInt,
                                      withCompletition completition: @escaping GetWalletTransactionsCompletition) {
        
        var params = [String:Any]()
        
        params["module"] = "account"
        params["action"] = "txlist"
        params["address"] = walletAddress
        params["startblock"] = 0
        params["endblock"] = Int64.max
        params["apikey"] = self.apiKey
        params["sort"] = "asc"
        
        let page = offset > 0 ? (count / offset) + 1 : 1
        
        params["page"] = page
        params["offset"] = count
        
        self.transport.executeRequest(withURL: self.apiURLString, params: params, method: .GET) { (result, error) in
            
            guard error == nil else {
                
                completition(nil, error)
                return
            }
            
            var transactions = [EtherscanTransaction]()
            
            if let dictionary = result as? [String:Any], let transactionDictionaries = dictionary["result"] as? [[String:Any]] {

                transactionDictionaries.forEach({ (transactionDictionary) in
                    
                    if let transaction = EtherscanTransaction.init(transactionDictionary: transactionDictionary) {
                        transactions.append(transaction)
                    }
                })
            }
            
            completition(transactions, nil)
        }
    }
}
