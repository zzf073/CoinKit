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
    
    public var inputAddresses: [String]
    public var inputAmmounts: [Ammount]
    
    public var outputAddresses: [String]
    public var outputAmmounts: [Ammount]
    
    init(transactionHash:String, time:Date, inputAddressed:[String], inputAmmounts:[Ammount], outputAddresses:[String], outputAmmounts:[Ammount]) {
        
        self.transactionHash = transactionHash
        self.time = time
        
        self.inputAddresses = inputAddressed
        self.inputAmmounts = inputAmmounts
        
        self.outputAddresses = outputAddresses
        self.outputAmmounts = outputAmmounts
    }
    
    public func getAmmountForAddress(_ address: String) -> Ammount? {
        
        var ammount:Ammount?
        
        self.outputAddresses.forEach { (outputAddress) in
            
            if outputAddress == address {
                
                ammount = self.outputAmmounts[self.outputAddresses.index(of: outputAddress)!]
            }
        }
        
        guard ammount == nil else {
            return ammount
        }
        
        self.inputAddresses.forEach { (inputAddress) in
            
            if inputAddress == address {
                
                ammount = self.inputAmmounts[self.inputAddresses.index(of: inputAddress)!]
            }
        }
        
        return ammount
    }
    
    public func isOutgoingForAddress(_ address: String) -> Bool? {
        
        guard self.inputAddresses.contains(address) || self.outputAddresses.contains(address) else {
            return nil
        }
        
        return self.outputAddresses.contains(address)
    }
}
