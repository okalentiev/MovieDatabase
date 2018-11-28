//
//  AppDelegate.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var windowCoordinator: WindowCoordinatorType?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainWindow = UIWindow(frame: UIScreen.main.bounds)
        let windowRouter = WindowRouter(window: mainWindow)
        window = mainWindow

        windowCoordinator = WindowCoordinator(router: windowRouter)
        windowCoordinator?.start()

        return true
    }

}
