//
//  MovieListCoordinator.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation

final class MovieListCoordinator: Coordinator {

    private lazy var listViewController: ViewController = {
        return ViewController()
    }()

    override init(router: RouterType) {
        super.init(router: router)
        router.setRootModule(listViewController, hideBar: false)
    }
}
