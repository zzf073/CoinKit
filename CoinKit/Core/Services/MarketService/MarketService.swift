//
//  MarketService.swift
//  AFNetworking
//
//  Created by Dmitry on 26.02.2018.
//

import Foundation

public typealias GetCoinsCompletition = ([CoinSummary]?, Error?) -> Void

public protocol MarketService {
    
    func getCoins(offset:UInt, count:UInt, completition:@escaping GetCoinsCompletition)
    
}
