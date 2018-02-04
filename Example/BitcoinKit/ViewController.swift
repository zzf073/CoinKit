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
        
        //"guitar manage mercy mechanic begin lend like sad puzzle brown fly cash"
        
        let mnemonic = BTCMnemonic.createNewMnemonic()
        
        NSLog("Generated mnemonic: %@", mnemonic.representation)
        
        let masterSeed = BTCMasterSeed.init(withMnemonic: mnemonic)
        
        NSLog("Generated master seed: %@", masterSeed.representation)
        
//        if let anotherSeed = BTCMasterSeed.init(withRepresentation: masterSeed.representation) {
//
//            NSLog("Generated another master seed: %@", anotherSeed.representation)
//        }
        
        let keychain = BTCKeychain.init(withMasterSeed: masterSeed)

        let wallet = keychain.getWallet(atIndex: 0)
    }
}
