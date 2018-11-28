//
//  WindowRouter.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import UIKit

public protocol WindowRouterType: class {
    var window: UIWindow { get }
    init(window: UIWindow)
    func setRootModule(_ module: Presentable)
}

final public class WindowRouter: NSObject, WindowRouterType {

    public unowned let window: UIWindow

    public init(window: UIWindow) {
        self.window = window
        super.init()
    }

    public func setRootModule(_ module: Presentable) {
        let viewController = module.toPresentable()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
