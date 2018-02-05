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
        
        let mnemonic = BitcoinMnemonic.init(withRepresentation: "office engine uphold sphere ski deliver light bonus defense abuse oven crack")!// BitcoinMnemonic.generateNewMnemonic()

        NSLog("Mnemonic generated: %@", mnemonic.representation)

        let seed = BitcoinSeed.init(withMnemonic: mnemonic)

        NSLog("Seed generated: %@", seed.representation)
        
        let masterChain = BitcoinKeychain.init(withSeed: seed)
        
        NSLog("Root private key:", masterChain.extendedKeyPair.privateKey.representation)
        
        if let keyPair = masterChain.getDerivedKeyPair(index: 1) {
            
            if let wallet = BitcoinWallet.init(withKeyPair: keyPair) {
                
                NSLog("Wallet address: %@", wallet.address)
            }
        }
    }
}
