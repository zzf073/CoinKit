//
//  ETHBlockchainService.swift
//  AFNetworking
//
//  Created by Dmitry on 12.02.2018.
//

import Foundation
import ethers

public class ETHBlockchainService: BlockchainService {
    
    public required init() {
        
    }
    
    public func getWalletBalance(_ wallet: Wallet, withCompletition completition: @escaping GetWalletBalanceCompletition) {
        
    }
    
    public func getWalletTransactions(_ wallet: Wallet, offset: UInt, count: UInt, withCompletition completition: @escaping GetWalletTransactionsCompletition) {
        
    }
    
    public func getTransactionFee(_ completition: (Amount?, Error?) -> Void) {
        
    }
    
    public func broadcastTransaction(from senderWallet: Wallet, to receiverWallet: Wallet, amount: Amount, fee: Amount, completition: @escaping BroadcastTransactionCompletition) {
        
    }
}
