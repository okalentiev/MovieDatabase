//
//  MovieViewController.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/29/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Kingfisher
import UIKit

protocol MovieViewProtocol: class {
    func loadBackdropImage(url: URL)
    func loadTitle(title: String)
    func loadOverview(overview: String)
}

final class MovieViewController: UIViewController {
    private var viewHandler: MovieViewHandlerProtocol?

    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 8

        return stackView
    }()

    private let backdropImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = styleManager.titleFont
        titleLabel.textColor = styleManager.textColor
        titleLabel.numberOfLines = 2

        return titleLabel
    }()

    private let overviewLabel: UILabel = {
        let overviewLabel = UILabel(frame: .zero)
        overviewLabel.font = styleManager.subtitleFont
        overviewLabel.textColor = styleManager.textColor
        overviewLabel.numberOfLines = 0

        return overviewLabel
    }()

    convenience init(viewHandler: MovieViewHandlerProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.viewHandler = viewHandler
    }

    override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = styleManager.backgroundColor

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])

        stackView.addArrangedSubview(backdropImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(overviewLabel)
        stackView.addArrangedSubview(UIView())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewHandler?.loadData()
    }
}

extension MovieViewController: MovieViewProtocol {
    func loadBackdropImage(url: URL) {
        backdropImageView.kf.setImage(with: url, options: [.transition(.fade(styleManager.defaultAnimationDuration))])
    }

    func loadTitle(title: String) {
        titleLabel.text = title
    }

    func loadOverview(overview: String) {
        overviewLabel.text = overview
    }
}
