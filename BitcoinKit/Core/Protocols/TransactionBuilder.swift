//
//  TransactionBuilder.swift
//  AFNetworking
//
//  Created by Dmitry on 08.02.2018.
//

import Foundation

public typealias TransactionBuilderCompletition = (BroadcastableTransaction?, Error?) -> Void

public protocol TransactionBuilder {
    
    func buildTransaction(for amount:Amount,
                          to receiverWallet:Wallet,
                          from senderWallet:Wallet,
                          fee:Amount,
                          completition:@escaping TransactionBuilderCompletition)
    
}
