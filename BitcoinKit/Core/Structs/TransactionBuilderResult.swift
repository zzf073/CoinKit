//
//  TransactionBuilderResult.swift
//  AFNetworking
//
//  Created by Dmitry on 08.02.2018.
//

import Foundation

public struct TransactionBuilderResult {
    
    public var transactionData:Data
    
    init(transactionData:Data) {
        self.transactionData = transactionData
    }
}
