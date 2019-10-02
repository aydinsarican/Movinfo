//
//  MovieService.swift
//  Movinfo
//
//  Created by Aydn on 2.10.2019.
//  Copyright © 2019 aydinsarican. All rights reserved.
//

import Foundation
import Alamofire

struct MovieService {
    static func getMoviesBy(searchKey: String, completion: @escaping (AFResult<[MovieModel]>) -> Void)
    {
        APIClient.decodableRequest(route: APIRouter.searchMovies(searchKey: searchKey), completion: completion)
    }
    
    static func getMovieDetailBy(movieId: String, completion: @escaping (AFResult<MovieDetailModel>) -> Void)
    {
        APIClient.decodableRequest(route: APIRouter.getMovie(movieId: movieId), completion: completion)
    }
}
