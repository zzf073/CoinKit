//
//  Wallet.swift
//  CoinKit
//
//  Created by Dmitry on 05.02.2018.
//

import Foundation

public protocol Wallet {
    
    var walletType:WalletType {get}
    
    var address:String {get}
    var privateKey:Data? {get}
    
    init(withAddress address:String)
    init?(withPrivateKey key:Data)
}
