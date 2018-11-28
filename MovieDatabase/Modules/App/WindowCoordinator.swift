//
//  WindowCoordinator.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation
import UIKit

public protocol WindowCoordinatorType: BaseCoordinatorType {
    var router: WindowRouterType { get }
}

final class WindowCoordinator: NSObject, WindowCoordinatorType {
    public var childCoordinators: [PresentableCoordinator] = []

    var router: WindowRouterType

    public init(router: WindowRouterType) {
        self.router = router
        super.init()
    }

    func start() {
        let navigationController = UINavigationController()
        let tabCoordinator = MovieListCoordinator(router: Router(navigationController: navigationController))

        addChild(tabCoordinator)
        tabCoordinator.start()

        styleManager.configureAppearance()

        router.setRootModule(tabCoordinator)
    }

    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
}
