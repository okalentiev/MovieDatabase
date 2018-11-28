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
    var elementsColor: UIColor { get }
    var textColor: UIColor { get }
    var successColor: UIColor { get }
    var failureColor: UIColor { get }
    var defaultAnimationDuration: TimeInterval { get }

    func configureAppearance()
}

final class DefaultStyleManager: StyleManagerProtocol {
    var subtitleFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .subheadline)
    }

    var titleFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .title2)
    }

    var largeTitleFont: UIFont {
        return UIFont.preferredFont(forTextStyle: .largeTitle)
    }

    var foregroundColor: UIColor {
        return UIColor(rgb: 0x00adb5)
    }

    var backgroundColor: UIColor {
        return UIColor(rgb: 0x303841)
    }

    var elementsColor: UIColor {
        return UIColor(rgb: 0xff5722)
    }

    var textColor: UIColor {
        return UIColor(rgb: 0xeeeeee)
    }

    var successColor: UIColor {
        return UIColor(rgb: 0x287D3C)
    }

    var failureColor: UIColor {
        return UIColor(rgb: 0xcc0000)
    }

    var defaultAnimationDuration: TimeInterval {
        return 0.2
    }

    func configureAppearance() {
        UINavigationBar.appearance().barTintColor = elementsColor
        UINavigationBar.appearance().tintColor = textColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]

        UITabBar.appearance().barTintColor = elementsColor
        UITabBar.appearance().unselectedItemTintColor = backgroundColor
        UITabBar.appearance().tintColor = textColor
    }
}
