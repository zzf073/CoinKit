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
    
    private var serviceLocator:BlockchainServiceLocator!
    
    override func viewDidLoad() {
        
        self.serviceLocator = self.setupServiceLocator()
        
        let mnemonic = MnemonicGenerator.generate()
        
        NSLog("Mnemonic generated: %@", mnemonic)
        
        let keychain = WalletProvider.init(withMnemonic: mnemonic)!
        
        let btcWallet = keychain.provideWallet(.BTC)!
        
        self.serviceLocator[.BTC]?.getWalletTransactions("31jauoCV34FjM9VUitwWvVcPydKqjWC5qd", offset: 0, count: 10, withCompletition: { (result, error) in
            
        })
    }
    
    private func setupServiceLocator() -> BlockchainServiceLocator {
        
        let etherscanAPIKey = "7DDK8IYJA2BV9UYRB6HRYNH2UUSG59EWIR"
        
        let serviceLocator = BaseCoinKitServiceLocator()
        
        let transport = AFNetworkingTransport()
        
        serviceLocator.setWalletService(BlockchainInfoService.init(transport: transport), .BTC)
        serviceLocator.setWalletService(EtherscanService.init(apiKey: etherscanAPIKey, transport: transport), .ETH)
        
        serviceLocator.marketService = CoinMarketCapService.init(transport: transport)
        
        return serviceLocator
    }
}
