//
//  TheMovieDBUrlBuilder.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation
import UIKit

protocol TheMovieDBUrlBuilderProtocol {
    func nowPlaying(page: Int) -> URL
    func poster(path: String, width: CGFloat) -> URL
    func backdrop(path: String) -> URL
    func search(query: String, page: Int) -> URL
}

final class TheMovieDBUrlBuilder: TheMovieDBUrlBuilderProtocol {
    func nowPlaying(page: Int) -> URL {
        guard let url = URL(string: Constants.API.baseUrlString)?
            .appendingPathComponent(Constants.API.version)
            .appendingPathComponent(Constants.API.Endpoints.Movie.nowPlaying) else {
            fatalError("Could not construct nowPlayingURL")
        }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let apiKeyQuery = URLQueryItem(name: Constants.API.DefaultParameters.apiKey,
                                 value: Constants.API.apiKey)
        let pageQuery = URLQueryItem(name: Constants.API.DefaultParameters.page,
                                    value: "\(page)")
        urlComponents?.queryItems = [apiKeyQuery, pageQuery]

        guard let nowPlayingURL = urlComponents?.url else {
            fatalError("Could not construct nowPlayingURL")
        }

        return nowPlayingURL
    }

    func poster(path: String, width: CGFloat) -> URL {
        // Not the cleanest calculation of the loading of the posters
        // Ideally app should load and use information from https://api.themoviedb.org/3/configuration to decide image sizes
        // And take appropriate scaling into account
        let posterSizes: [CGFloat] = [92, 154, 185, 342, 500, 780]
        var sizeParameter = "original"
        if let sizeComponent = posterSizes.first(where: { $0 >= 2 * width }) {
            sizeParameter = "w\(Int(sizeComponent))"
        }

        guard let url = URL(string: Constants.API.imageBaseUrlString)?
            .appendingPathComponent(sizeParameter)
            .appendingPathComponent(path) else {
                fatalError("Could not construct posterUrl")
        }

        return url
    }

    func backdrop(path: String) -> URL {
        guard let url = URL(string: Constants.API.imageBaseUrlString)?
            .appendingPathComponent("original")
            .appendingPathComponent(path) else {
                fatalError("Could not construct backdropUrl")
        }

        return url
    }

    func search(query: String, page: Int) -> URL {
        guard let url = URL(string: Constants.API.baseUrlString)?
            .appendingPathComponent(Constants.API.version)
            .appendingPathComponent(Constants.API.Endpoints.Search.movie) else {
                fatalError("Could not construct search url")
        }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let apiKeyQuery = URLQueryItem(name: Constants.API.DefaultParameters.apiKey,
                                       value: Constants.API.apiKey)
        let query = URLQueryItem(name: Constants.API.DefaultParameters.query,
                                 value: query)
        let pageQuery = URLQueryItem(name: Constants.API.DefaultParameters.page,
                                     value: "\(page)")
        urlComponents?.queryItems = [apiKeyQuery, query, pageQuery]

        guard let searchUrl = urlComponents?.url else {
            fatalError("Could not construct url")
        }

        return searchUrl
    }
}
