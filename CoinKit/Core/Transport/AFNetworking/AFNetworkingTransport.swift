//
//  AFNetworkingTransport.swift
//  AFNetworking
//
//  Created by Dmitry on 25.02.2018.
//

import Foundation
import AFNetworking

public class AFNetworkingTransport:HTTPTransport {
    
    private var manager = AFHTTPSessionManager.init(sessionConfiguration: URLSessionConfiguration.default)
    
    public init() {
        
    }
    
    public func executeRequest(withURL url: String, params: [String : Any]?, method: HTTPMethod, completition: HTTPTransportCompletition?) {
        
        self.manager.get(url,
                         parameters: params,
                         success:
        { (task, result) in
            completition?(result, nil)
        }) { (task, error) in
            completition?(nil, error)
        }
    }
}
