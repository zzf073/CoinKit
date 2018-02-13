//
//  ETHBlockchainService.swift
//  AFNetworking
//
//  Created by Dmitry on 12.02.2018.
//

import Foundation
import ethers

public class ETHBlockchainService: BlockchainService {
    
    private let provider = EtherscanProvider.init(chainId: ChainId.ChainIdRinkeby, apiKey: "5Z553MKCV35Y73ANP1C9NCEFMCD39GXZM1")!
    
    public required init() {
        
    }
    
    public func getWalletBallance(_ wallet: Wallet, withCompletition completition: @escaping GetWalletBallanceCompletition) {
        
        guard let promise = self.provider.getBalance(Address.init(string: wallet.address)) else {
            return
        }
        
        promise.onCompletion {
            [weak self] promise in
            
            if promise?.result == nil || promise?.error != nil {
                return
            }
            
            
            guard let value = promise?.value else { return }
            let formatted = Payment.formatEther(value, options: EtherFormatOption.commify.rawValue | EtherFormatOption.approximate.rawValue)
            var converted: String = ""
//            if let price = self?.price,
//                let dollars = value.mul(BigNumber(integer: Int(price))),
//                let formatted = Payment.formatEther(dollars, options: EtherFormatOption.commify.rawValue | EtherFormatOption.approximate.rawValue) {
//                converted = "  $\(formatted)"
//            }
            
            formatted
            
//            callback(GeneralWalletValue(userRepresentation: "Ξ \(formatted ?? "0")" + converted,
//                                        value: Decimal(promise?.value.integerValue ?? 0)))
        }
    }
    
    public func getWalletTransactions(_ wallet: Wallet, offset: UInt, count: UInt, withCompletition completition: @escaping GetWalletTransactionsCompletition) {
        
    }
    
    public func getTransactionFee(_ completition: (Amount?, Error?) -> Void) {
        
    }
    
    public func broadcastTransaction(from senderWallet: Wallet, to receiverWallet: Wallet, amount: Amount, fee: Amount, completition: @escaping BroadcastTransactionCompletition) {
        
    }
}
