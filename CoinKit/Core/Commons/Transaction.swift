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
    var blockHeight:Int {get}
    
    var from:String {get}
    var to:String {get}
    var amount:Amount {get}
}
