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
        super.viewDidLoad()
        
        let mnemonic = MnemonicGenerator.generate()
        NSLog("Generated new mnemonic: %@", mnemonic)
        
        let btcWallet = getWalletType(.BTC).init(withMnemonic: mnemonic)!
        NSLog("Created new BTC wallet: %@", btcWallet.address)
        
        let ethWallet = getWalletType(.ETH).init(withMnemonic: mnemonic)!
        NSLog("Created new BTC wallet: %@", ethWallet.address)
        
        let btcService = getBlockchainServiceType(.BTC).init()
        
        btcService.getWalletBalance(btcWallet) { (balance, error) in
            
            NSLog("%@", balance!.representation)
        }
        
        let newRandomWallet = getWalletType(.BTC).createNewWallet()
        
        btcService.broadcastTransaction(from: btcWallet,
                                        to: newRandomWallet,
                                        amount: BitcoinAmount.init(withFormattedValue: 0.1)!, //BTC
                                        fee: BitcoinAmount.init(withValue: 10000)) //Satoshis
        { (error) in
            
            if error != nil {
                NSLog("Error broadcasting transaction: %@", error!.localizedDescription)
            }
        }
    }
}
