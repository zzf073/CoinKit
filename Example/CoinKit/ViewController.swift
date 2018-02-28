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
        
        let transport = AFNetworkingTransport()
        
        FixerExchangeRateService.init(transport: transport, marketService: CoinCapService.init(transport: transport)).getExchangeRatesForCoinSymbols(["BTC", "ETH", "NEO", "LTC"], targetCurrency: .RUB) { (fiatType, rates) in
            
        }
    }
    
    private func setupServiceLocator() -> BlockchainServiceLocator {
        
        let etherscanAPIKey = "7DDK8IYJA2BV9UYRB6HRYNH2UUSG59EWIR"
        
        let serviceLocator = BaseCoinKitServiceLocator()
        
        let transport = AFNetworkingTransport()
        
        serviceLocator.setWalletService(BlockchainInfoService.init(transport: transport), .BTC)
        serviceLocator.setWalletService(EtherscanService.init(apiKey: etherscanAPIKey, transport: transport), .ETH)
        
        return serviceLocator
    }
}
