//
//  Coordinator.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import UIKit

public protocol BaseCoordinatorType: class {
    func start()
}

public protocol PresentableCoordinatorType: BaseCoordinatorType, Presentable {}

open class PresentableCoordinator: NSObject, PresentableCoordinatorType {

    public override init() {
        super.init()
    }

    open func start() { }

    open func toPresentable() -> UIViewController {
        fatalError("Must override toPresentable()")
    }
}

public protocol CoordinatorType: PresentableCoordinatorType {
    var router: RouterType { get }
}

open class Coordinator: PresentableCoordinator, CoordinatorType {

    public var childCoordinators: [Coordinator] = []

    open var router: RouterType

    public init(router: RouterType) {
        self.router = router
    }

    public func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    public func removeChild(_ coordinator: Coordinator?) {

        if let coordinator = coordinator, let index = childCoordinators.index(of: coordinator) {
            childCoordinators.remove(at: index)
        }
    }

    open override func toPresentable() -> UIViewController {
        return router.toPresentable()
    }
}
