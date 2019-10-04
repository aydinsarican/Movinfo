//
//  APIRouter.swift
//  Movinfo
//
//  Created by Aydn on 2.10.2019.
//  Copyright © 2019 aydinsarican. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    // API's
    case searchMovies(searchKey: String)
    case getMovie(movieId: String)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self
        {
        case .searchMovies, .getMovie:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self
        {
        case .searchMovies, .getMovie:
            return ""
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters?
    {
        switch self
        {
        case .searchMovies(let searchKey):
            return ["s": searchKey, "apikey": APIConstant.apiKey]
            
        case .getMovie(let movieId):
            return ["i": movieId, "apikey": APIConstant.apiKey]
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try APIConstant.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        print("Path: \(path)")
        print("Parameters: \(String(describing: parameters))")
        
        if self.method == Alamofire.HTTPMethod.post
        {
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: self.parameters)
        }
        else if self.method == Alamofire.HTTPMethod.put
        {
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: self.parameters)
        }
        else
        {
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: self.parameters)
        }
    }
}
