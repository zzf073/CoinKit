//
//  ViewController.swift
//  CoinKit
//
//  Created by Dmitry on 02/02/2018.
//  Copyright (c) 2018 Dmitry. All rights reserved.
//

import UIKit
import CoinKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        
        let mnemonic = "smile record torch gentle zoo betray proof expand receive merit melody virus"
        
        let keychain = Keychain.init(withMnemonic: mnemonic)!
        
        let btcWallet = keychain.deriveWallet(.BTC)
        
        if btcWallet != nil {
            
            NSLog("Derivered BTC wallet: %@", btcWallet!.address)
        }
        
        let ethWallet = keychain.deriveWallet(.ETH)
        
        if ethWallet != nil {
            
            NSLog("Derivered ETH wallet: %@", ethWallet!.address)
        }
        
        //using service locator
        
        let serviceLocator = BaseBlockchainServiceLocator()
        
        let transport = AFNetworkingTransport()
        
        serviceLocator[.BTC] = BlockchainInfoService.init(transport: transport)
        serviceLocator[.ETH] = EtherscanService.init(apiKey: "7DDK8IYJA2BV9UYRB6HRYNH2UUSG59EWIR", transport: transport)
        
        
        //some time later
        
        let btcService = serviceLocator[.BTC]!
        
        
        btcService.getWalletsBalance(["12D6bH1GbdX411CLD4R1tJ3quEEeATyxdL", "1A8JiWcwvpY7tAopUkSnGuEYHmzGYfZPiq"]) { (result, error) in
            
        }
        
//        btcService.getWalletBalance(btcWallet!) { (balance, error) in
//            NSLog("BTC wallet balance: %@", balance!.representation)
//        }
        
        let ethService = serviceLocator[.ETH]!
        
        let anotherWallet = ETHWallet.init(withAddress: "0xde0b295669a9fd93d5f28d9ec85e40f4cb697bae")
        
        ethService.getWalletsBalance([anotherWallet.address]) { (balances, error) in
//            NSLog("ETH wallet balance: %@", balance!.representation)
        }
        
        ethService.getWalletTransactions(anotherWallet.address, offset: 0, count: 10) { (transactions, error) in
            
        }
        
    }
}
