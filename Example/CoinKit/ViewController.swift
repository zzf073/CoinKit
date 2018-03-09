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
        
        let usd = FiatAmount.init(value: 102, fiatType: .USD)
        let rub = FiatAmount.init(value: 12221, fiatType: .RUB)
        let eur = FiatAmount.init(value: 3300000.5, fiatType: .EUR)
        
        NSLog(usd.representation)
        NSLog(rub.representation)
        NSLog(eur.representation)
    }
    
    private func setupServiceLocator() -> BlockchainServiceLocator {
        
        let etherscanAPIKey = "7DDK8IYJA2BV9UYRB6HRYNH2UUSG59EWIR"
        
        let serviceLocator = BaseCoinKitServiceLocator()
        
        let transport = AFNetworkingTransport()
        
        serviceLocator[.BTC] = BlockchainInfoService.init(transport: transport)
        serviceLocator[.ETH] = EtherscanService.init(apiKey: etherscanAPIKey, transport: transport)
        
        return serviceLocator
    }
}
