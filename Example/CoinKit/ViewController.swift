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
        
        //Create and validate mnemonic
        
        let mnemonic = MnemonicGenerator.generate()
        NSLog("Generated new mnemonic: %@", mnemonic)
        
        if !MnemonicGenerator.validate("some incorrect mnemonic") {
            //NSLog("Incorrect mnemonic!")
        }
        
        //Creating new wallets
        
        let newBTCWallet = getWalletType(.BTC).createNewWallet()
        NSLog("Created new BTC wallet: %@", newBTCWallet.address)
        
        let newETHWallet = getWalletType(.ETH).createNewWallet()
        NSLog("Created new ETH wallet: %@", newETHWallet.address)
        
        
        //Restoring existed wallets
        
        let restoredWallet = getWalletType(.BTC).init(withMnemonic: "believe boost rare popular giggle cave pupil unveil absurd stock scissors erosion")
        
        NSLog("Restored wallet address: %@", restoredWallet!.address)
        NSLog("Restored wallet private key hex: %@", restoredWallet!.privateKey!.representation)
        
        //Restoring existed wallets with private key
        
        let anotherRestoredWallet = getWalletType(.BTC).init(withPrivateKey: restoredWallet!.privateKey!)
        
        NSLog("Another restored wallet address: %@", restoredWallet!.address)
        
        //working with blockchain
        
        let blockchainService = getBlockchainServiceType(.BTC).init()
        
        blockchainService.getWalletBalance(anotherRestoredWallet!) { (balance, error) in
            NSLog("Wallet balance: %@", balance!.representation)
        }
        
        blockchainService.broadcastTransaction(from: anotherRestoredWallet!,
                                               to: newBTCWallet,
                                               amount: BitcoinAmount.init(withFormattedValue: 0.1)!, //BTC
                                               fee: BitcoinAmount.init(withValue: 10000)) //satoshis
        { (error) in
            
                                                if error != nil {
                NSLog("Error broadcasting transaction: %@", error!.localizedDescription)
            }
        }
    }
}
