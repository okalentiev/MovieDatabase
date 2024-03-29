//
//  Constants.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

//swiftlint:disable nesting

import Foundation

struct Constants {
    struct API {
        static let baseUrlString = "https://api.themoviedb.org"
        static let version = "/3"
        static let apiKey = "da0c0e40fa23a956aec2d5aa48032b32"

        static let imageBaseUrlString = "https://image.tmdb.org/t/p/"

        struct Endpoints {
            struct Movie {
                static let root = "/movie"
                static let nowPlaying = Constants.API.Endpoints.Movie.root + "/now_playing"
            }

            struct Search {
                static let root = "/search"
                static let movie = Constants.API.Endpoints.Search.root + "/movie"
            }
        }

        struct DefaultParameters {
            static let apiKey = "api_key"
            static let page = "page"
            static let query = "query"
        }
    }
}
