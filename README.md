# CoinKit

Features:
* Written in Swift, wrapping well-tested and production ready libs such as `CoreBitcoin`, `ethers`, etc.
* Working with different coins and blockchain services using unified protocols
* Generating and validating `BIP39` mnemonic
* Creating new wallets, or restoring existed ones with `mnemonic` or `private key`
* Receiving wallet info from its blockchain (`balance`, `transactions`, `fees`)
* Signing and broadcasting `transactions`

## Example


```swift
//Create and validate mnemonic

let mnemonic = MnemonicGenerator.generate()
NSLog("Generated new mnemonic: %@", mnemonic)

if !MnemonicGenerator.validate("some incorrect mnemonic") {
    //NSLog("Incorrect mnemonic!")
}

//Creating new wallets

let newBTCWallet = getWalletType(.BTC).createNewWallet()
NSLog("Created new BTC wallet: %@", newBTCWallet.address)

let newETHWallet = getWalletType(.ETH).createNewWallet()
NSLog("Created new ETH wallet: %@", newETHWallet.address)


//Restoring existed wallets

let restoredWallet = getWalletType(.BTC).init(withMnemonic: "believe boost rare popular giggle cave pupil unveil absurd stock scissors erosion")

NSLog("Restored wallet address: %@", restoredWallet!.address)
NSLog("Restored wallet private key hex: %@", restoredWallet!.privateKey!.representation)

//Restoring existed wallets with private key

let anotherRestoredWallet = getWalletType(.BTC).init(withPrivateKey: restoredWallet!.privateKey!)

NSLog("Another restored wallet address: %@", restoredWallet!.address)

//working with blockchain

let blockchainService = getBlockchainServiceType(.BTC).init()

blockchainService.getWalletBalance(anotherRestoredWallet!) { (balance, error) in
    NSLog("Wallet balance: %@", balance!.representation)
}

blockchainService.broadcastTransaction(from: anotherRestoredWallet!,
                                       to: newBTCWallet,
                                       amount: getAmountType(.BTC).init(withFormattedValue: 0.1)!, //BTC
                                       fee: getAmountType(.BTC).init(withOriginalValue: 10000)) //satoshis
{ (error) in
    
if error != nil {
        NSLog("Error broadcasting transaction: %@", error!.localizedDescription)
    }
}
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CoinKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CoinKit'
```

## Author

Dmitry, d.overchuk@titanium.im

## License

CoinKit is available under the MIT license. See the LICENSE file for more info.
