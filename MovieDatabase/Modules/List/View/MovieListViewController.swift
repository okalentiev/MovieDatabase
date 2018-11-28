//
//  MovieListViewController.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, ListViewProtocol {
    var cellIdentifier: String = UICollectionViewCell.reuseIdentifier

    fileprivate var movieListCollectionView: UICollectionView!
    fileprivate var emptyView: EmptyContentView!

    fileprivate var viewHandler: CollectionListViewHandlerProtocol?

    convenience init(viewHandler: CollectionListViewHandlerProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.viewHandler = viewHandler
    }

    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)

        // Collection view
        let screenWidth = view.bounds.width
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        movieListCollectionView = UICollectionView(frame: view.bounds,
                                                   collectionViewLayout: flowLayout)
        movieListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        movieListCollectionView.dataSource = viewHandler
        view.addSubview(movieListCollectionView)

        NSLayoutConstraint.activate([
            movieListCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            movieListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            movieListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never

        title = NSLocalizedString(Constants.Localisation.Movies.title, comment: "Movies")

        movieListCollectionView.register(UICollectionViewCell.self,
                                         forCellWithReuseIdentifier: UICollectionViewCell.reuseIdentifier)

        viewHandler?.loadData()
    }
}

extension MovieListViewController {
    func startLoading() {
        movieListCollectionView.isUserInteractionEnabled = false
    }

    func stopLoading() {
        movieListCollectionView.isUserInteractionEnabled = true
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
