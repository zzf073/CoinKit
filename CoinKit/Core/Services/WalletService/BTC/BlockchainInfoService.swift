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
    public var size: Int
    public var blockHeight: Int
    public var weight: Int
    
    public var inputAddresses: [String]
    public var inputAmounts: [Amount]
    
    public var outputAddresses: [String]
    public var outputAmounts: [Amount]
    
    init?(withDictionary dictionary:[String:Any]) {
        
        guard let hash = dictionary["hash"] as? String else { return nil }
        guard let timeInterval = dictionary["time"] as? Double else { return nil }
        guard let size = dictionary["size"] as? Int else { return nil }
        guard let blockHeight = dictionary["block_height"] as? Int else { return nil }
        guard let txWeight = dictionary["weight"] as? Int else { return nil }
        
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
        self.size = size
        self.blockHeight = blockHeight
        self.weight = txWeight
        self.inputAddresses = inputAddresses
        self.inputAmounts = inputAmounts
        self.outputAddresses = outputAddresses
        self.outputAmounts = outputAmounts
    }
    
    public func getAmountForAddress(_ address: String) -> Amount? {
        
        var value:Double = 0.0
        
        self.outputAddresses.forEach { (outputAddress) in
            
            if outputAddress == address {
                
                value += self.outputAmounts[self.outputAddresses.index(of: outputAddress)!].value
            }
        }
        
        self.inputAddresses.forEach { (inputAddress) in
            
            if inputAddress == address {
                
                value += self.inputAmounts[self.inputAddresses.index(of: inputAddress)!].value
            }
        }
        
        return BlockchainInfoAmount.init(value: value)
    }
    
    public func isOutgoingForAddress(_ address: String) -> Bool? {
        
        guard self.inputAddresses.contains(address) || self.outputAddresses.contains(address) else {
            return nil
        }
        
        return self.inputAddresses.contains(address)
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
                    
                    if let transaction = BlockChainInfoTransaction.init(withDictionary: dictionary) {
                        
                        transactions.append(transaction)
                    }
                })
            }
            
            completition(transactions, nil)
        }
    }
}

