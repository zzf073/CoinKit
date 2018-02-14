//
//  DecimalExtensions.swift
//  AFNetworking
//
//  Created by Dmitry on 14.02.2018.
//

import Foundation

extension Decimal {
    
    public var int64Value:Int64 {
        return NSDecimalNumber.init(decimal: self).int64Value
    }
}
