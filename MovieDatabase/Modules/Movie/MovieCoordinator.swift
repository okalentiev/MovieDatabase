//
//  MovieCoordinator.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/29/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation
import UIKit

final class MovieCoordinator: Coordinator {
    private let movie: Movie

    private lazy var controller: MovieViewController = {
        let urlBuilder = TheMovieDBUrlBuilder()
        let viewModel = MovieViewModel(movie: movie, urlBuilder: urlBuilder)
        let controller = MovieViewController(viewHandler: viewModel)
        viewModel.view = controller

        return controller
    }()

    init(router: RouterType, movie: Movie) {
        self.movie = movie
        super.init(router: router)
    }

    override func toPresentable() -> UIViewController {
        return controller
    }
}
