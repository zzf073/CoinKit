//
//  ViewController.swift
//  BitcoinKit
//
//  Created by Dmitry on 02/02/2018.
//  Copyright (c) 2018 Dmitry. All rights reserved.
//

import UIKit
import BitcoinKit

class ViewController: UIViewController {

    let blockchainService:BlockchainService = BitcoinBlockchainService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //wallet 1: "region plunge runway punch grocery else raise few churn chalk flock repeat" / 1CLLwNeU9P5n1b1169epuu7z2EoDdaZLsL
        //wallet 2: "tube improve crater box peanut blanket typical buddy image meadow involve income" / 1Hzh13B8e7FGUkzWxFqZnauJSv51T2Gysd
        
        
        let mnemonic = BitcoinMnemonic.init(withRepresentation: "region plunge runway punch grocery else raise few churn chalk flock repeat")!// BitcoinMnemonic.generateNewMnemonic()
        
        let stack = BitcoinStackContainer.init(withMnemonic: mnemonic)
        
        let wallet = stack.deriverDefaultWallet()!
        
        NSLog("Wallet: %@", wallet.address)
        
        self.blockchainService.transactionBuilder.buildTransaction(for: BitcoinAmount.init(withValue: 10000),
                                                                   to: BitcoinWallet.init(withAddress: "1Hzh13B8e7FGUkzWxFqZnauJSv51T2Gysd"),
                                                                   from: wallet,
                                                                   fee: BitcoinAmount.init(withValue: 10000))
        { [weak self] (result, error) in
            
            if let transaction = result {
                
                NSLog("Transaction builded!")
                
                self?.blockchainService.pushTransaction(transaction, completition: { (error) in
                    
                    NSLog("Transaction pushed!")
                })
            }
        }
        

//        NSLog("Mnemonic generated: %@", mnemonic.representation)
//
//        let seed = BitcoinSeed.init(withMnemonic: mnemonic)
//
//        NSLog("Seed generated: %@", seed.representation)
//
//        let masterChain = BitcoinKeychain.init(withSeed: seed)
//
//        NSLog("Root private key:", masterChain.extendedKeyPair.privateKey.representation)
//
//        if let keyPair = masterChain.getDerivedKeyPair(index: 1) {
//
//            if let wallet = BitcoinWallet.init(withKeyPair: keyPair) {
//
//                NSLog("Wallet address: %@", wallet.address)
//
//                self.btcService.getWalletBallance(wallet) { (ballance, error) in
//                    NSLog("Wallet ballance: %@", ballance!.representation)
//                }
//
//                self.btcService.getWalletTransactions(wallet, offset: 0, count: 10) { (transactions, error) in
//
//                    NSLog("Transactions loaded:")
//
//                    transactions?.forEach({ (transaction) in
//
//                        let isIncoming = transaction.isOutgoingForAddress(wallet.address)!
//                        let amount = transaction.getAmountForAddress(wallet.address)!
//
//                        NSLog("%@ %@ at %@ / %@", isIncoming ? "+" : "-", amount.representation, String.init(describing: transaction.time), transaction.transactionHash)
//                    })
//                }
//            }
//        }
    }
}
