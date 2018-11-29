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
        if UIDevice.current.orientation != .unknown {
            return UIDevice.current.orientation == .portrait ? 2 : 4
        }
        return 2
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
        collectionView.backgroundColor = styleManager.backgroundColor

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
            movieListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieListCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            movieListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])

        // Error view
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
            ])

        // Activity indicator
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
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
        movieListCollectionView.delegate = self

        emptyView.retryHandler = { [weak self] in
            self?.viewHandler?.loadData()
        }

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

    func appendIndexes(_ indexes: [IndexPath]) {
        movieListCollectionView.insertItems(at: indexes)
    }

    func showEmptyView() {
        emptyView.alpha = 0
        emptyView.isHidden = false

        UIView.animate(withDuration: styleManager.defaultAnimationDuration) {
            self.emptyView.alpha = 1
        }
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewHandler?.cellWillDisplay(indexPath: indexPath)

        cell.contentView.alpha = 0.7

        let transformScale = CGAffineTransform(scaleX: 0.6, y: 0.6)
        let transformTranslate = CGAffineTransform(translationX: 0, y: 0)

        cell.contentView.transform = transformScale.concatenating(transformTranslate)

        collectionView.bringSubviewToFront(cell.contentView)
        UIView.animate(withDuration: TimeInterval(styleManager.slowAnimationDuration),
                       delay: 0, options: .allowUserInteraction, animations: {
                        cell.contentView.alpha = 1
                        cell.contentView.transform = .identity
        })
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewHandler?.rowSelected(at: indexPath)
    }
}
