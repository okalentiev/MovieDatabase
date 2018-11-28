//
//  TheMovieDBUrlBuilder.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation

protocol TheMovieDBUrlBuilderProtocol {
    var nowPlayingURL: URL { get }
}

final class TheMovieDBUrlBuilder: TheMovieDBUrlBuilderProtocol {
    var nowPlayingURL: URL {
        guard let url = URL(string: Constants.API.baseUrlString)?
            .appendingPathComponent(Constants.API.version)
            .appendingPathComponent(Constants.API.Endpoints.Movie.nowPlaying) else {
            fatalError("Could not construct nowPlayingURL")
        }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let query = URLQueryItem(name: Constants.API.DefaultParameters.apiKey,
                                 value: Constants.API.apiKey)
        urlComponents?.queryItems = [query]

        guard let nowPlayingURL = urlComponents?.url else {
            fatalError("Could not construct nowPlayingURL")
        }

        return nowPlayingURL
    }
}
