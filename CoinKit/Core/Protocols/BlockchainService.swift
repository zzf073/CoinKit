//
//  BlockchainService.swift
//  CoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public typealias GetWalletBalanceCompletition = (Amount?, Error?) -> Void
public typealias GetWalletTransactionsCompletition = ([Transaction]?, Error?) -> Void
public typealias GetTransactionFeeCompletition = (Amount?, Error?) -> Void
public typealias BroadcastTransactionCompletition = (Error?) -> Void

public protocol BlockchainService {
    
    init()
    
    func getWalletBalance(_ wallet:Wallet, withCompletition completition:@escaping GetWalletBalanceCompletition)
    func getWalletTransactions(_ wallet:Wallet, offset:UInt, count:UInt, withCompletition completition:@escaping GetWalletTransactionsCompletition)
    func getTransactionFee(_ completition:GetTransactionFeeCompletition)
    func broadcastTransaction(from senderWallet:Wallet, to receiverWallet:Wallet, amount:Amount, fee:Amount, completition:@escaping BroadcastTransactionCompletition)
}
