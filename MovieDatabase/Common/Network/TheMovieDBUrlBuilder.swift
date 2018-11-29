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
    var nowPlayingURL: URL { get }
    func posterUrl(path: String, width: CGFloat) -> URL
    func backdropUrl(path: String) -> URL
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

    func posterUrl(path: String, width: CGFloat) -> URL {
        let posterWidth = 100 * Int((width / 100.0).rounded())

        guard let url = URL(string: Constants.API.imageBaseUrlString)?
            .appendingPathComponent("w\(posterWidth)")
            .appendingPathComponent(path) else {
                fatalError("Could not construct posterUrl")
        }

        return url
    }

    func backdropUrl(path: String) -> URL {
        guard let url = URL(string: Constants.API.imageBaseUrlString)?
            .appendingPathComponent("original")
            .appendingPathComponent(path) else {
                fatalError("Could not construct backdropUrl")
        }

        return url
    }

}
