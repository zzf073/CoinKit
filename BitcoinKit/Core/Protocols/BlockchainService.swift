//
//  BlockchainService.swift
//  BitcoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public typealias GetWalletBallanceCompletition = (Ammount?, Error?) -> Void
public typealias GetWalletTransactionsCompletition = ([Transaction]?, Error?) -> Void

public protocol BlockchainService {
    
    func getWalletBallance(_ wallet:Wallet, withCompletition completition:@escaping GetWalletBallanceCompletition)
    func getWalletTransactions(_ wallet:Wallet, offset:UInt, count:UInt, withCompletition completition:@escaping GetWalletTransactionsCompletition)
}
