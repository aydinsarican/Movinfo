//
//  APIConstant.swift
//  Movinfo
//
//  Created by Aydn on 2.10.2019.
//  Copyright © 2019 aydinsarican. All rights reserved.
//

import Foundation

struct APIConstant {
    
    //http://www.omdbapi.com/?i=tt3896198&apikey=fd7c14c2
    static let apiKey = "&apikey=fd7c14c2"
    static let baseURL = "http://www.omdbapi.com/"
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
