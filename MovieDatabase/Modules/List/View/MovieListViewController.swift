//
//  MovieListViewController.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, ListViewProtocol {
    private static let cellSizeDimensionMultiplier: CGFloat = 1.5

    var cellIdentifier: String = MovieCollectionViewCell.reuseIdentifier
    var cellWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return screenWidth / CGFloat(numberOfColumns)
    }

    private var numberOfColumns: Int {
        return UIDevice.current.orientation == .portrait ? 2 : 4
    }

    fileprivate var viewHandler: CollectionListViewHandlerProtocol?

    fileprivate lazy var movieListCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: cellWidth,
                                     height: cellWidth * MovieListViewController.cellSizeDimensionMultiplier)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero,
                                                   collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    fileprivate let emptyView: EmptyContentView = {
        let view = EmptyContentView(frame: .zero)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    convenience init(viewHandler: CollectionListViewHandlerProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.viewHandler = viewHandler
    }

    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)

        // Collection view
        view.addSubview(movieListCollectionView)
        NSLayoutConstraint.activate([
            movieListCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            movieListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            movieListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])

        // Error view
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])

        // Activity indicator
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never

        title = NSLocalizedString(Constants.Localisation.Movies.title, comment: "Movies")

        movieListCollectionView.register(MovieCollectionViewCell.self,
                                         forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier)
        movieListCollectionView.dataSource = viewHandler

        viewHandler?.loadData()
    }
}

extension MovieListViewController {
    func startLoading() {
        movieListCollectionView.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        movieListCollectionView.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }

    func reloadList() {
        movieListCollectionView.reloadData()
    }

    func showEmptyView() {
        emptyView.alpha = 0
        emptyView.isHidden = false

        UIView.animate(withDuration: styleManager.defaultAnimationDuration) {
            self.emptyView.alpha = 1
        }
    }
}
