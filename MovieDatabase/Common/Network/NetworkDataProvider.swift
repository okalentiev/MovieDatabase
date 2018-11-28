//
//  NetworkDataProvider.swift
//  MovieDatabase
//
//  Created by Oleksii Kalentiev on 11/28/18.
//  Copyright © 2018 Oleksii Kalentiev. All rights reserved.
//

import Foundation

enum NetworkDataProviderError: Error {
    case unknownError
    case responseError(description: String)
    case serializationError(description: String)
}

typealias NetworkDataCompletion<ModelType: Codable> = ((ModelType?, Error?) -> Void)

protocol NetworkDataProviderProtocol {
    func get<ModelType: Codable>(url: URL, with completion: @escaping NetworkDataCompletion<ModelType>)
}

final class NetworkDataProvider: NetworkDataProviderProtocol {
    private let urlSession: URLSession
    fileprivate let jsonDecoder: JSONDecoder

    init(urlSession: URLSession, jsonDecoder: JSONDecoder) {
        self.urlSession = urlSession
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        self.jsonDecoder = jsonDecoder
    }

    func get<ModelType: Codable>(url: URL, with completion: @escaping NetworkDataCompletion<ModelType>) {
        let dataTask = urlSession.dataTask(with: url) { (data, _, error) in
            if let responseData = data {
                self.mapResponse(responseData: responseData, url: url, completion: completion)
            } else if let responseError = error {
                completion(nil, NetworkDataProviderError.responseError(description:
                    responseError.localizedDescription))
            } else {
                completion(nil, NetworkDataProviderError.unknownError)
            }
        }

        dataTask.resume()
    }
}

// MARK: - Helpers
private extension NetworkDataProvider {
    func mapResponse<ModelType: Codable>(responseData: Data, url: URL,
                                         completion: @escaping NetworkDataCompletion<ModelType>) {
        do {
            let decoded = try jsonDecoder.decode(ModelType.self, from: responseData)
            completion(decoded, nil)
        } catch let error {
            completion(nil, error)
        }
    }
}
