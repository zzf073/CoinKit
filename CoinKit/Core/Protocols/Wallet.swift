//
//  Wallet.swift
//  CoinKit
//
//  Created by Dmitry on 05.02.2018.
//

import Foundation

public protocol Wallet {
    
    var coinType:CoinType {get}
    
    var address:String {get}
    var privateKey:Key? {get}
    var mnemonic:String? {get}
    
    static func createNewWallet() -> Wallet
    
    init(withAddress address:String)
    
    init?(withMnemonic mnemonic:String)
    init?(withPrivateKey key:Key)
}
