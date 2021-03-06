//
//  BlockchainService.swift
//  CoinKit
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public typealias GetWalletBalanceCompletition = ([String:Amount]?, Error?) -> Void

public protocol BlockchainService {
    
    func getWalletsBalance(_ walletAddresses:[String], withCompletition completition:@escaping GetWalletBalanceCompletition)
}
