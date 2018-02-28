//
//  HTTPTransport.swift
//  AFNetworking
//
//  Created by Dmitry on 25.02.2018.
//

import Foundation

public typealias HTTPTransportCompletition = (Any?, Error?) -> Void

public enum HTTPMethod {
    case GET
}

public protocol HTTPTransport {
    
    func executeRequest(withURL url:String, params:[String:Any]?, method:HTTPMethod, completition:HTTPTransportCompletition?)
}
