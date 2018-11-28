//
//  MovieCellViewModel.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation
import UIKit

final class MovieCellViewModel {
    private let movie: Movie
    private let urlBuilder: TheMovieDBUrlBuilderProtocol
    private let cellWidth: CGFloat

    weak var view: MovieCollectionViewCellProtocol? {
        didSet {
            view?.loadImage(url: urlBuilder.posterUrl(path: movie.posterPath,
                                                      width: cellWidth))
        }
    }

    init(movie: Movie, urlBuilder: TheMovieDBUrlBuilderProtocol, cellWidth: CGFloat) {
        self.movie = movie
        self.urlBuilder = urlBuilder
        self.cellWidth = cellWidth
    }
}
