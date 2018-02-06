//
//  BitcoinTransaction.swift
//  AFNetworking
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

open class BitcoinTransaction: Transaction {
    
    public var senderAddress: String
    public var receiverAddress: String
    
    public init(senderAddress:String, receiverAddress:String) {
        self.senderAddress = senderAddress
        self.receiverAddress = receiverAddress
    }
}
