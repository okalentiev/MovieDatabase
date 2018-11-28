//
//  MovieCollectionViewCell.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Kingfisher
import UIKit

typealias MovieCollectionViewCellType = UICollectionViewCell & MovieCollectionViewCellProtocol

protocol MovieCollectionViewCellProtocol: class {
    func loadImage(url: URL)
}

final class MovieCollectionViewCell: MovieCollectionViewCellType {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)])
    }

    func loadImage(url: URL) {
        imageView.kf.setImage(with: url, options: [.transition(.fade(styleManager.defaultAnimationDuration))])
    }
}
