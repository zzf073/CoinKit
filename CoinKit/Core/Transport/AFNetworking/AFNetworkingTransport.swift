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
    
    public func executeRequest(withURL url: String, params: [String : Any]?, method: HTTPTransportMethod, completition: HTTPTransportCompletition?) {
        
        switch method {
        case .GET:
            self.manager.get(url, parameters: params,
                             progress: nil,
                             success:
                { (task, result) in
                completition?(result, nil)
                },
                             failure:
                { (task, error) in
                completition?(nil, error)
                })
        case .POST:
            
            self.manager.post(url,
                              parameters: params,
                              progress: nil,
                              success: { (task, result) in completition?(result, nil) },
                              failure: { (task, error) in  completition?(nil, error) })
        }
    }
}
