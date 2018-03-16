//
//  HTTPTransport.swift
//  AFNetworking
//
//  Created by Dmitry on 25.02.2018.
//

import Foundation

public typealias HTTPTransportCompletition = (Any?, Error?) -> Void

public enum HTTPTransportMethod {
    case GET
    case POST
}

public protocol HTTPTransport {
    
    func executeRequest(withURL url:String, params:[String:Any]?, method:HTTPTransportMethod, completition:HTTPTransportCompletition?)
}
