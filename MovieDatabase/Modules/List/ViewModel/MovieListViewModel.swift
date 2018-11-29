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
    weak var delegate: MovieListCoordinatorDelelegate?

    private let movieProvider: NetworkDataProvider
    private let urlBuilder: TheMovieDBUrlBuilderProtocol

    fileprivate var moviesResult: Result<Movie>?

    init(movieProvider: NetworkDataProvider, urlBuilder: TheMovieDBUrlBuilderProtocol) {
        self.movieProvider = movieProvider
        self.urlBuilder = urlBuilder
    }

    func loadData() {
        view?.startLoading()

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
        if let movie = moviesResult?.results[indexPath.row] {
            delegate?.movieSelected(movie: movie)
        }
    }
}

extension MovieListViewModel {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesResult?.results.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let listView = view,
            let movie = moviesResult?.results[indexPath.row],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listView.cellIdentifier,
                                                          for: indexPath) as? MovieCollectionViewCellType else {
            fatalError("Cannot load movie cell")
        }

        let movieViewModel = MovieCellViewModel(movie: movie,
                                                urlBuilder: urlBuilder,
                                                cellWidth: listView.cellWidth)
        movieViewModel.view = cell

        return cell
    }
}
