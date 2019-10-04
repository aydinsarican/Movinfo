//
//  MovieModel.swift
//  Movinfo
//
//  Created by Aydn on 2.10.2019.
//  Copyright © 2019 aydinsarican. All rights reserved.
//

import Foundation

// MARK: - MovieModel
struct MovieModel: Codable {
    let movies: [Movie]?
    let totalResults, response: String?

    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case totalResults
        case response = "Response"
    }
}

// MARK: - Movie
struct Movie: Codable {
    let title, year, imdbID, type: String?
    let poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}


