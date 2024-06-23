//
//  MockFecher.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import Combine
import Foundation

class MockSerchListDataFecher: SerchListDataFecherType {
    func getList(key: String = "") -> AnyPublisher<[ListModel], FecherError> {
        var models: [ListModel] = []
        for i in 1...20 {
            let id = "ID\(i)"
            let title = "Book Title \(i)"
            let authors = "authors\(i)"
            let thumbnailURL = "http://example.com/thumbnail\(i).jpg"
            let averageRating = Double.random(in: 1.0...5.0)

            let book = ListModel(id: id, thumbnailURL: thumbnailURL, title: title, authors: authors, averageRating: averageRating)
            models.append(book)
        }

        return Just(models)
            .setFailureType(to: FecherError.self)
            .eraseToAnyPublisher()
    }
}
