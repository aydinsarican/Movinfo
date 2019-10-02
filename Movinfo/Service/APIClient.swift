//
//  APIClient.swift
//  Movinfo
//
//  Created by Aydn on 2.10.2019.
//  Copyright © 2019 aydinsarican. All rights reserved.
//

import Foundation
import Alamofire

class APIClient
{
    //MARK: Generic Request
    @discardableResult
    static func decodableRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (AFResult<T>)->Void) -> DataRequest
    {
        return AF.request(route)
            .responseDecodable (decoder: decoder){ (response: DataResponse<T>) in
                completion(response.result)
        }
    }
    
    @discardableResult
    static func jsonRequest(route:APIRouter, completion:@escaping (DataResponse<Any>)->Void) -> DataRequest
    {
        return AF.request(route)
            .responseJSON(completionHandler: { (response) in
                completion(response)
            })
    }
    
    @discardableResult
    static func stringRequest(route:APIRouter, completion:@escaping (DataResponse<String>)->Void) -> DataRequest
    {
        return AF.request(route)
            .responseString(completionHandler: { (response) in
                completion(response)
            })
    }
}
