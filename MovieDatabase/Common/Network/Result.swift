//
//  Result.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation

struct Result<ResultType: Codable>: Codable {
    let results: [ResultType]
    let page: Int
    let totalResults: Int
    let totalPages: Int

    private enum CodingKeys: String, CodingKey {
        case results
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}
