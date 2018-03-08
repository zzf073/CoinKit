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

fileprivate class BlockchainInfoAmount: BaseAmount {
    
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
        
        super.init(value: value, symbol: "₿")
    }
}

fileprivate class BlockChainInfoTransaction:Transaction {
    
    public var transactionHash: String
    public var time: Date
    public var blockHeight: Int
    var from: String
    var to: String
    var amount: Amount
    
    init?(withDictionary dictionary:[String:Any], walletAddress:String) {
        
        guard let hash = dictionary["hash"] as? String else { return nil }
        guard let timeInterval = dictionary["time"] as? Double else { return nil }
        guard let blockHeight = dictionary["block_height"] as? Int else { return nil }
        
        var outputAddresses = [String]()
        var outputAmounts = [BlockchainInfoAmount]()
        
        var inputAddresses = [String]()
        var inputAmounts = [BlockchainInfoAmount]()
        
        (dictionary["inputs"] as? [[String:Any]])?.forEach({ (inputDictionary) in
            
            if let prevOut = inputDictionary["prev_out"] as? [String:Any] {
                
                if let inputAddress = prevOut["addr"] as? String, let value = prevOut["value"] as? Int64 {
                    
                    inputAddresses.append(inputAddress)
                    inputAmounts.append(BlockchainInfoAmount.init(satoshiValue: Decimal.init(value)))
                }
            }
        })
        
        (dictionary["out"] as? [[String:Any]])?.forEach({ (outputDictionary) in
            
            if let outputAddress = outputDictionary["addr"] as? String, let value = outputDictionary["value"] as? Int64 {
                
                outputAddresses.append(outputAddress)
                outputAmounts.append(BlockchainInfoAmount.init(satoshiValue: Decimal.init(value)))
            }
        })
        
        self.transactionHash = hash
        self.time = Date.init(timeIntervalSince1970: timeInterval)
        self.blockHeight = blockHeight
        
        self.from = "from"
        self.to = "to"
        self.amount = BlockchainInfoAmount.init(value: 999999)
        
        guard !inputAmounts.isEmpty && !outputAmounts.isEmpty && !inputAddresses.isEmpty && !outputAddresses.isEmpty else {
            return nil
        }
        
        if outputAddresses.contains(walletAddress) {
            
            self.to = walletAddress
            self.from = inputAddresses.first!
            self.amount = outputAmounts[outputAddresses.index(of: walletAddress)!]
        }
        else if inputAddresses.contains(walletAddress)
        {
            self.from = walletAddress
            self.to = outputAddresses.first!
            self.amount = inputAmounts[inputAddresses.index(of: walletAddress)!]
        }
        else {
            return nil
        }
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
    
    public func getWalletTransactions(_ walletAddress: String,
                                      offset: UInt,
                                      count: UInt,
                                      withCompletition completition: @escaping GetWalletTransactionsCompletition) {
        
        let URLString = self.constructURLWithPath("/rawaddr/\(walletAddress)")
        
        self.transport.executeRequest(withURL: URLString, params: ["offset" : offset, "limit" : count], method: .GET) { (result, error) in
            
            guard error == nil else {
                
                completition(nil, error)
                return
            }
            
            var transactions = [Transaction]()
            
            if let dictionary = result as? [String:Any], let transactionsArray = dictionary["txs"] as? [[String:Any]] {
                
                transactionsArray.forEach({ (dictionary) in
                    
                    if let transaction = BlockChainInfoTransaction.init(withDictionary: dictionary, walletAddress: walletAddress) {
                        
                        transactions.append(transaction)
                    }
                })
            }
            
            completition(transactions, nil)
        }
    }
}
