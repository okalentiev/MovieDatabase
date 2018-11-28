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

        struct Endpoints {
            struct Movie {
                static let root = "/movie"
                static let nowPlaying = Constants.API.Endpoints.Movie.root + "/now_playing"
            }
        }

        struct DefaultParameters {
            static let apiKey = "api_key"
        }
    }
}
