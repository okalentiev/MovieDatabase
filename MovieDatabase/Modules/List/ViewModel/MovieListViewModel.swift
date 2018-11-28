//
//  MovieListViewModel.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation
import UIKit

final class MovieListViewModel: NSObject, CollectionListViewHandlerProtocol {
    weak var view: ListViewProtocol?

    private let movieProvider: NetworkDataProvider
    private let urlBuilder: TheMovieDBUrlBuilderProtocol

    fileprivate var moviesResult: Result<Movie>?

    init(movieProvider: NetworkDataProvider, urlBuilder: TheMovieDBUrlBuilderProtocol) {
        self.movieProvider = movieProvider
        self.urlBuilder = urlBuilder
    }

    func loadData() {
        movieProvider.get(url: urlBuilder.nowPlayingURL) { [weak self] (moviesResponse: Result<Movie>?, _) in
            if let movies = moviesResponse, !movies.results.isEmpty {
                self?.moviesResult = movies

                DispatchUtils.renderUI {
                    self?.view?.reloadList()
                }
            } else {
                DispatchUtils.renderUI {
                    self?.view?.showEmptyView()
                }
            }
            DispatchUtils.renderUI {
                self?.view?.stopLoading()
            }
        }
    }

    func rowSelected(at indexPath: IndexPath) {

    }
}

extension MovieListViewModel {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesResult?.results.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellIdentifier = view?.cellIdentifier,
            let movie = moviesResult?.results[indexPath.section] else {
            fatalError("Cannon load movie cell identifier")
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath)

        cell.backgroundColor = (indexPath.row % 2) == 0 ? UIColor.red : UIColor.green

        return cell
    }
}
