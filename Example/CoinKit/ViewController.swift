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
        
        
        
    }
}
