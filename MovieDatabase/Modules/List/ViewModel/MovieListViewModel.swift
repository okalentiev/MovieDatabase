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

    fileprivate var moviesData = MoviesData()
    fileprivate var searchData = MoviesData()

    fileprivate var currentData: MoviesData {
        return searchString != nil ? searchData : moviesData
    }

    fileprivate var loading = false
    fileprivate var searchString: String?
    fileprivate var searchDelayTimer: DispatchWorkItem?

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
            let result = currentData.currentResult,
            result.page < result.totalPages else {
            return
        }

        if indexPath.row >= Int(MovieListViewModel.paginationTrigerPercentage * Double(currentData.movies.count)) {
            if let search = searchString {

            } else {
                loadMovies(page: result.page + 1)
            }
        }
    }

    func rowSelected(at indexPath: IndexPath) {
        delegate?.movieSelected(movie: currentData.movies[indexPath.row])
    }

    func searchEntered(_ searchString: String) {
        guard !searchString.isEmpty else {
            return
        }
        self.searchString = searchString
        self.searchDelayTimer?.cancel()

        let searchDelayTimer = DispatchWorkItem { [weak self] in
            if let url = self?.urlBuilder.search(query: searchString) {
                self?.currentData.movies.removeAll()
                self?.view?.reloadList()
                self?.view?.startLoading()
                self?.performReques(url: url)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: searchDelayTimer)

        self.searchDelayTimer = searchDelayTimer
    }

    func clearSearch() {
        searchDelayTimer?.cancel()
        searchString = nil
        view?.reloadList()
    }
}

extension MovieListViewModel {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentData.movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let listView = view,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listView.cellIdentifier,
                                                          for: indexPath) as? MovieCollectionViewCellType else {
            fatalError("Cannot load movie cell")
        }

        let movie = currentData.movies[indexPath.row]
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
                    self?.view?.showEmptyView(allowRetry: self?.searchString == nil)
                }
            }
            DispatchUtils.renderUI {
                self?.view?.stopLoading()
            }
            self?.loading = false
        }
    }

    func handleResponse(_ moviesResponse: Result<Movie>) {
        let oldLastIndex = currentData.movies.count
        currentData.currentResult = moviesResponse
        currentData.movies.append(contentsOf: moviesResponse.results)

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
