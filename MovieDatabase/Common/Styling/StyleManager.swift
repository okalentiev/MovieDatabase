//
//  StyleManager.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation
import UIKit

/**
 Making this a var so the style manager can be swapped in the runtime.
 Helpful for instance if the colors we are retreiving from the server.
 */
var styleManager: StyleManagerProtocol = DefaultStyleManager()

protocol StyleManagerProtocol {
    var subtitleFont: UIFont { get }
    var titleFont: UIFont { get }
    var largeTitleFont: UIFont { get }
    var foregroundColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
    var defaultAnimationDuration: TimeInterval { get }
    var slowAnimationDuration: TimeInterval { get }

    func configureAppearance()
}

final class DefaultStyleManager: StyleManagerProtocol {
    var subtitleFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .subheadline)
    }

    var titleFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .title3)
    }

    var largeTitleFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .largeTitle)
    }

    var foregroundColor: UIColor {
        return UIColor(red: 20.0 / 255.0, green: 20.0 / 255.0, blue: 20.0 / 255.0, alpha: 1)
    }

    var backgroundColor: UIColor {
        return UIColor.black
    }

    var textColor: UIColor {
        return UIColor.white
    }

    var defaultAnimationDuration: TimeInterval {
        return 0.2
    }

    var slowAnimationDuration: TimeInterval {
        return 0.5
    }

    func configureAppearance() {
        UINavigationBar.appearance().barTintColor = foregroundColor
        UINavigationBar.appearance().tintColor = textColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
    }
}
