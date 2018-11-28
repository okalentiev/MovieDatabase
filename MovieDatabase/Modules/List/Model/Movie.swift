//
//  Movie.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let movieId: Int
    let title: String
    let posterPath: URL
    let backdropPath: URL
    let overview: String

    private enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case title
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview
    }
}
