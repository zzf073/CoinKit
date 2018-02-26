//
//  CoinSummary.swift
//  AFNetworking
//
//  Created by Dmitry on 26.02.2018.
//

import Foundation

public protocol CoinSummary {
    
    var coin:CoinDescription {get}
    var USDPrice:Amount {get}
    
    var hourChange:Double? {get}
    var dayChange:Double? {get}
    var weekChange:Double? {get}
}
