//
//  TransactionBuilder.swift
//  AFNetworking
//
//  Created by Dmitry on 08.02.2018.
//

import Foundation

public typealias TransactionBuilderCompletition = (TransactionBuilderResult?, Error?) -> Void

public protocol TransactionBuilder {
    
    func buildTransaction(for amount:Ammount,
                          to receiverWallet:Wallet,
                          from senderWallet:Wallet,
                          fee:Ammount,
                          completition:TransactionBuilderCompletition)
    
}
