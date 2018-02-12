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
        
        let wallet = BTCWallet.init(withMnemonic: "wing artist beef palm gospel code grocery goddess zoo great reform sick")!
        
        NSLog("Created new wallet with mnemonic: %@", wallet.mnemonic ?? "-")
        NSLog("Created new wallet with address: %@", wallet.address)
        
        let blockchainService = BitcoinBlockchainService.init()
        
        blockchainService.getWalletBallance(wallet) { (ballance, error) in
            
            NSLog("Wallet ballance: %@", ballance?.representation ?? "-")
        }
        
//        blockchainService.broadcastTransaction(from: wallet,
//                                               to: BTCWallet.createNewWallet(),
//                                               amount: BitcoinAmount.init(withFormattedValue: 0.1)!,
//                                               fee: BitcoinAmount.init(withFormattedValue: 0.0001)!) { (error) in
//
//        }
    }
}
