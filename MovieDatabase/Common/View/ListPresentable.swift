//
//  ListPresentable.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation
import UIKit

protocol ListViewHandlerProtocol {
    func loadData()
    func searchEntered(_ searchString: String)
    func cellWillDisplay(indexPath: IndexPath)
    func rowSelected(at indexPath: IndexPath)
}

protocol ListViewProtocol: class {
    var cellIdentifier: String { get }
    var cellWidth: CGFloat { get }

    func startLoading()
    func stopLoading()

    func showEmptyView()
    func reloadList()
    func appendIndexes(_ indexes: [IndexPath])
}

protocol CollectionListViewHandlerProtocol: ListViewHandlerProtocol, UICollectionViewDataSource { }
