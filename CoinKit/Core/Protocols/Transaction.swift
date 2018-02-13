//
//  Transaction.swift
//  AFNetworking
//
//  Created by Dmitry on 06.02.2018.
//

import Foundation

public protocol Transaction {
    
    var transactionHash:String {get}
    var time:Date {get}
    var size:Int {get} //transaction size in bytes
    var blockHeight:Int {get}
    var weight:Int {get} //transaction weight
    
    var inputAddresses:[String] {get}
    var inputAmounts:[Amount] {get}
    
    var outputAddresses:[String] {get}
    var outputAmounts:[Amount] {get}
    
    func isOutgoingForAddress(_ address:String) -> Bool?
    func getAmountForAddress(_ address:String) -> Amount?
}
