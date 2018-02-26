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
    
    private var serviceLocator:CoinKitServiceLocator!
    
    override func viewDidLoad() {
        
        self.serviceLocator = self.setupServiceLocator()
        
        let mnemonic = MnemonicGenerator.generate()
        
        NSLog("Mnemonic generated: %@", mnemonic)
        
        let keychain = Keychain.init(withMnemonic: mnemonic)!
        
        let btcWallet = keychain.deriveWallet(.BTC)!
        
        self.serviceLocator.walletService(.BTC)?.getWalletsBalance([btcWallet.address], withCompletition: { (result, error) in
            
        })
        
        self.serviceLocator.marketService?.getCoins(offset: 0, count: 10, completition: { (result, error) in
            
            result?.forEach({ (summary) in
                NSLog("%@ = %@ (%f%)", summary.coin.name, summary.USDPrice.representation, summary.dayChange!)
            })
        })
    }
    
    private func setupServiceLocator() -> CoinKitServiceLocator {
        
        let etherscanAPIKey = "7DDK8IYJA2BV9UYRB6HRYNH2UUSG59EWIR"
        
        let serviceLocator = BaseCoinKitServiceLocator()
        
        let transport = AFNetworkingTransport()
        
        serviceLocator.setWalletService(BlockchainInfoService.init(transport: transport), .BTC)
        serviceLocator.setWalletService(EtherscanService.init(apiKey: etherscanAPIKey, transport: transport), .ETH)
        
        serviceLocator.marketService = CoinMarketCapService.init(transport: transport)
        
        return serviceLocator
    }
}
