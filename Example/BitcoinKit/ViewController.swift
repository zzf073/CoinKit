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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coinType = CoinType.ETH
        
        let wallet = getWalletType(coinType).createNewWallet()
        
        NSLog("Created new wallet with mnemonic: %@", wallet.mnemonic ?? "-")
        NSLog("Created new wallet with address: %@", wallet.address)
        
//        let blockchainService = getBlockchainServiceType(coinType).init()
//
//        blockchainService.getWalletBallance(wallet) { (ballance, error) in
//
//            NSLog("Wallet ballance: %@", ballance?.representation ?? "-")
//        }
    }
}
