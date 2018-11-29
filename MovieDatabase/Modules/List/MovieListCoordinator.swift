//
//  MovieListCoordinator.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation

protocol MovieListCoordinatorDelelegate: class {
    func movieSelected(movie: Movie)
}

final class MovieListCoordinator: Coordinator {

    private lazy var listViewController: MovieListViewController = {
        let movieProvider = NetworkDataProvider(urlSession: URLSession.shared,
                                                jsonDecoder: JSONDecoder())
        let urlBuilder = TheMovieDBUrlBuilder()

        let viewModel = MovieListViewModel(movieProvider: movieProvider,
                                           urlBuilder: urlBuilder)
        let viewController = MovieListViewController(viewHandler: viewModel)
        viewModel.view = viewController
        viewModel.delegate = self

        return viewController
    }()

    override init(router: RouterType) {
        super.init(router: router)
        router.setRootModule(listViewController, hideBar: false)
    }
}

extension MovieListCoordinator: MovieListCoordinatorDelelegate {
    func movieSelected(movie: Movie) {
        let coordinator = MovieCoordinator(router: router, movie: movie)

        addChild(coordinator)
        coordinator.start()

        router.push(coordinator, animated: true) { [weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }
    }
}
