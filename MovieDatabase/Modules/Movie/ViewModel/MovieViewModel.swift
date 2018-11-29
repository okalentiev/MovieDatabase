//
//  MovieViewModel.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/29/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation

protocol MovieViewHandlerProtocol {
    func loadData()
}

final class MovieViewModel: MovieViewHandlerProtocol {
    private let movie: Movie
    private let urlBuilder: TheMovieDBUrlBuilderProtocol

    weak var view: MovieViewProtocol?

    init(movie: Movie, urlBuilder: TheMovieDBUrlBuilderProtocol) {
        self.movie = movie
        self.urlBuilder = urlBuilder
    }

    func loadData() {
        view?.loadBackdropImage(url: urlBuilder.backdropUrl(path: movie.backdropPath))
        view?.loadTitle(title: movie.title)
        view?.loadOverview(overview: movie.overview)
    }
}
