//
//  MovieListCoordinator.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation

final class MovieListCoordinator: Coordinator {

    private lazy var listViewController: MovieListViewController = {
        let movieProvider = NetworkDataProvider(urlSession: URLSession.shared,
                                                jsonDecoder: JSONDecoder())
        let urlBuilder = TheMovieDBUrlBuilder()

        let viewModel = MovieListViewModel(movieProvider: movieProvider,
                                           urlBuilder: urlBuilder)
        let viewController = MovieListViewController(viewHandler: viewModel)
        viewModel.view = viewController

        return viewController
    }()

    override init(router: RouterType) {
        super.init(router: router)
        router.setRootModule(listViewController, hideBar: false)
    }
}
