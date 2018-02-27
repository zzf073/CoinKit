//
//  CoinSummary.swift
//  AFNetworking
//
//  Created by Dmitry on 26.02.2018.
//

import Foundation

public protocol CoinSummary {
    
    var coin:CoinDescription {get}
    var marketCapUSD:Amount {get}
    var priceUSD:Amount {get}
    var dailyVolume:Double {get}
    var dailyPriceChange:Double {get}
}
