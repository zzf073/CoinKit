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
        
        let mnemonic = BTCMnemonic.createNewMnemonic()

        let container = BTCContainer.init(withMnemonic: mnemonic) as Container
        
        
        NSLog("Generated mnemonic: %@", container.mnemonic!.representation)
        NSLog("Generated master seed: %@", container.masterSeed.representation)
    }
}
