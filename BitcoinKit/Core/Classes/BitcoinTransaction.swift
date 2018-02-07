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
    public var inputAmmounts: [Ammount]
    
    public var outputAddresses: [String]
    public var outputAmmounts: [Ammount]
    
    init(transactionHash:String,
         time:Date, size:Int,
         blockHeight:Int,
         weight:Int,
         inputAddressed:[String],
         inputAmmounts:[Ammount],
         outputAddresses:[String],
         outputAmmounts:[Ammount]) {
        
        self.transactionHash = transactionHash
        self.time = time
        self.size = size
        self.blockHeight = blockHeight
        self.weight = weight
        
        self.inputAddresses = inputAddressed
        self.inputAmmounts = inputAmmounts
        
        self.outputAddresses = outputAddresses
        self.outputAmmounts = outputAmmounts
    }
    
    public func getAmmountForAddress(_ address: String) -> Ammount? {
        
        var value:Double = 0
        
        self.outputAddresses.forEach { (outputAddress) in
            
            if outputAddress == address {
                
                value += self.outputAmmounts[self.outputAddresses.index(of: outputAddress)!].value
            }
        }
        
        self.inputAddresses.forEach { (inputAddress) in
            
            if inputAddress == address {
                
                value += self.inputAmmounts[self.inputAddresses.index(of: inputAddress)!].value
            }
        }
        
        return BitcoinAmmount.init(withValue: value)
    }
    
    public func isOutgoingForAddress(_ address: String) -> Bool? {
        
        guard self.inputAddresses.contains(address) || self.outputAddresses.contains(address) else {
            return nil
        }
        
        return self.inputAddresses.contains(address)
    }
}
