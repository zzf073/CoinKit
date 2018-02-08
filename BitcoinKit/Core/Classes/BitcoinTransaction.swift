//
//  BitcoinTransaction.swift
//  AFNetworking
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

open class BitcoinTransaction: Transaction {
    
    public var transactionHash: String
    public var time: Date
    public var size: Int
    public var blockHeight: Int
    public var weight: Int
    
    public var inputAddresses: [String]
    public var inputAmounts: [Amount]
    
    public var outputAddresses: [String]
    public var outputAmounts: [Amount]
    
    init(transactionHash:String,
         time:Date, size:Int,
         blockHeight:Int,
         weight:Int,
         inputAddressed:[String],
         inputAmounts:[Amount],
         outputAddresses:[String],
         outputAmounts:[Amount]) {
        
        self.transactionHash = transactionHash
        self.time = time
        self.size = size
        self.blockHeight = blockHeight
        self.weight = weight
        
        self.inputAddresses = inputAddressed
        self.inputAmounts = inputAmounts
        
        self.outputAddresses = outputAddresses
        self.outputAmounts = outputAmounts
    }
    
    public func getAmountForAddress(_ address: String) -> Amount? {
        
        var value:Int64 = 0
        
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
        
        return BitcoinAmount.init(withValue: value)
    }
    
    public func isOutgoingForAddress(_ address: String) -> Bool? {
        
        guard self.inputAddresses.contains(address) || self.outputAddresses.contains(address) else {
            return nil
        }
        
        return self.inputAddresses.contains(address)
    }
}
