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

    private static let paginationTrigerPercentage = 0.8

    private let movieProvider: NetworkDataProviderProtocol
    private let urlBuilder: TheMovieDBUrlBuilderProtocol

    fileprivate var currentResult: Result<Movie>?
    fileprivate var movies: [Movie] = []

    fileprivate var loading = false

    init(movieProvider: NetworkDataProviderProtocol, urlBuilder: TheMovieDBUrlBuilderProtocol) {
        self.movieProvider = movieProvider
        self.urlBuilder = urlBuilder
    }

    func loadData() {
        view?.startLoading()
        loadMovies(page: 1)
    }

    func cellWillDisplay(indexPath: IndexPath) {
        guard loading == false,
            let result = currentResult,
            result.page < result.totalPages else {
            return
        }

        if indexPath.row >= Int(MovieListViewModel.paginationTrigerPercentage * Double(movies.count)) {
            loadMovies(page: result.page + 1)
        }
    }

    func rowSelected(at indexPath: IndexPath) {
        delegate?.movieSelected(movie: movies[indexPath.row])
    }

    func searchEntered(_ searchString: String) {
        movies.removeAll()
        performReques(url: urlBuilder.search(query: searchString))
    }
}

extension MovieListViewModel {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let listView = view,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listView.cellIdentifier,
                                                          for: indexPath) as? MovieCollectionViewCellType else {
            fatalError("Cannot load movie cell")
        }

        let movie = movies[indexPath.row]
        let movieViewModel = MovieCellViewModel(movie: movie,
                                                urlBuilder: urlBuilder,
                                                cellWidth: listView.cellWidth)
        movieViewModel.view = cell

        return cell
    }
}

// MARK: Helpers
private extension MovieListViewModel {
    func loadMovies(page: Int) {
        performReques(url: urlBuilder.nowPlaying(page: page))
    }

    func performReques(url: URL) {
        loading = true
        movieProvider.get(url: url) { [weak self] (moviesResponse: Result<Movie>?, _) in
            if let movies = moviesResponse, !movies.results.isEmpty {
                self?.handleResponse(movies)
            } else {
                DispatchUtils.renderUI {
                    self?.view?.showEmptyView()
                }
            }
            DispatchUtils.renderUI {
                self?.view?.stopLoading()
            }
            self?.loading = false
        }
    }

    func handleResponse(_ moviesResponse: Result<Movie>) {
        let oldLastIndex = movies.count
        currentResult = moviesResponse
        movies.append(contentsOf: moviesResponse.results)

        if oldLastIndex == 0 {
            DispatchUtils.renderUI {
                self.view?.reloadList()
            }
        } else {
            let newLastIndex = oldLastIndex + moviesResponse.results.count
            let indexes = (oldLastIndex..<newLastIndex).map { IndexPath(row: $0, section: 0) }
            DispatchUtils.renderUI {
                self.view?.appendIndexes(indexes)
            }
        }
    }
}
