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
        
        let mnemonic = BTCMnemonic.init(withRepresentation: "guitar manage mercy mechanic begin lend like sad puzzle brown fly cash")
        
        NSLog("Generated mnemonic: %@", mnemonic.representation)
        
        let masterSeed = BTCMasterSeed.init(withMnemonic: mnemonic)
        
        NSLog("Generated master seed: %@", masterSeed.representation)
        
        let keychain = BTCKeychain.init(withMasterSeed: masterSeed)
        
        let wallet = keychain.getWallet(atIndex: 0)
        
        
        
        
    }
}
