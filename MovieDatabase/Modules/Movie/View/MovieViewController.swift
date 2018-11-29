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
    func removeBackdropImage()
    func loadTitle(title: String)
    func loadOverview(overview: String)
}

final class MovieViewController: UIViewController {
    private var viewHandler: MovieViewHandlerProtocol?

    private static let backDropPhotoRatio: CGFloat = 0.5625
    private static let stackViewSpacing: CGFloat = 8

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 8

        return stackView
    }()

    private let labelsStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = MovieViewController.stackViewSpacing

        return stackView
    }()

    private let backdropImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
        (imageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .white
        return imageView
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = styleManager.titleFont
        titleLabel.textColor = styleManager.textColor
        titleLabel.numberOfLines = 2

        return titleLabel
    }()

    private let overviewLabel: UILabel = {
        let overviewLabel = UILabel(frame: .zero)
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
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

        // ScrollView
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])

        // Content views
        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(backdropImageView)
        stackView.addArrangedSubview(labelsStackView)

        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(overviewLabel)
        labelsStackView.layoutMargins = UIEdgeInsets(top: 0, left: labelsStackView.spacing,
                                                     bottom: 0, right: labelsStackView.spacing)
        labelsStackView.isLayoutMarginsRelativeArrangement = true

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            backdropImageView.heightAnchor.constraint(equalTo: backdropImageView.widthAnchor,
                                                      multiplier: MovieViewController.backDropPhotoRatio)
            ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        viewHandler?.loadData()
    }
}

extension MovieViewController: MovieViewProtocol {
    func loadBackdropImage(url: URL) {
        backdropImageView.kf.setImage(with: url, options: [.transition(.fade(styleManager.defaultAnimationDuration))])
    }

    func removeBackdropImage() {
        stackView.removeArrangedSubview(backdropImageView)
    }

    func loadTitle(title: String) {
        titleLabel.text = title
    }

    func loadOverview(overview: String) {
        overviewLabel.text = overview
    }
}
