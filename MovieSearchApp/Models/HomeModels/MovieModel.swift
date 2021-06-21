//
//  MovieModel.swift
//  MovieSearchApp
//
//  Created by Phong Le on 15/06/2021.
//

import Foundation

struct Movies: Codable {
    var results: [Movie]
}

struct Movie: Codable {
    let title: String?
    let posterPath: String?
    let releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}
