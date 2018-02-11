//
//  BlockchainService.swift
//  BitcoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public typealias GetWalletBallanceCompletition = (Amount?, Error?) -> Void
public typealias GetWalletTransactionsCompletition = ([Transaction]?, Error?) -> Void
public typealias BroadcastTransactionCompletition = (Error?) -> Void
public typealias GetTransactionFeeCompletition = (Amount?, Error?) -> Void

public protocol BlockchainService {
    
    var transactionBuilder:TransactionBuilder {get}
    
    func getWalletBallance(_ wallet:Wallet, withCompletition completition:@escaping GetWalletBallanceCompletition)
    func getWalletTransactions(_ wallet:Wallet, offset:UInt, count:UInt, withCompletition completition:@escaping GetWalletTransactionsCompletition)
    func broadcastTransaction(_ transaction:BroadcastableTransaction, completition:@escaping BroadcastTransactionCompletition)
    func getTransactionFee(_ completition:GetTransactionFeeCompletition)
}
