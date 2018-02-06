//
//  Transaction.swift
//  AFNetworking
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public protocol Transaction {
    
    var senderAddress:String {get}
    var receiverAddress:String {get}
    
//    var ammount:WalletBallance {get}
}
