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
    func rowSelected(at indexPath: IndexPath)
}

protocol ListViewProtocol: class {
    var cellIdentifier: String { get }

    func startLoading()
    func stopLoading()

    func showEmptyView()
    func reloadList()
}

protocol CollectionListViewHandlerProtocol: ListViewHandlerProtocol, UICollectionViewDataSource { }
