//
//  EmptyContentView.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation
import UIKit

final class EmptyContentView: UIView {
    private static let buttonHeight: CGFloat = 50.0

    private var actionButton: UIButton?

    var retryHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupErrorView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupErrorView()
    }

    func setupErrorView() {
        backgroundColor = .clear

        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString(Constants.Localisation.EmptyView.title,
                                       comment: "Empty error message")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = styleManager.titleFont
        label.textColor = styleManager.textColor
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        let button = UIButton(type: .custom)
        button.backgroundColor = styleManager.elementsColor
        button.setTitle(NSLocalizedString(Constants.Localisation.EmptyView.retryButton,
                                          comment: "Retry button title"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(retry), for: .touchUpInside)

        addSubview(button)
        actionButton = button

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: button.topAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.heightAnchor.constraint(equalToConstant: EmptyContentView.buttonHeight)])
    }
}

private extension EmptyContentView {
    @objc
    func retry() {
        retryHandler?()
    }
}
