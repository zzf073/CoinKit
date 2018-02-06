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
    
    var inputAddresses:[String] {get}
    var inputAmmounts:[Ammount] {get}
    
    var outputAddresses:[String] {get}
    var outputAmmounts:[Ammount] {get}
    
    func isOutgoingForAddress(_ address:String) -> Bool?
    func getAmmountForAddress(_ address:String) -> Ammount?
}
