//
//  MockFecher.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import Combine
import Foundation

class MockSerchListDataFecher: SerchListDataFecherType {
    func getList(key: String = "") -> AnyPublisher<SerchModel, FecherError> {
        var models: [ListModel] = []
        for i in 1...20 {
            let id = "ID\(i)"
            let title = "Book Title \(i)"
            let authors = "authors\(i)"
            let thumbnailURL = "https://flexible.img.hani.co.kr/flexible/normal/970/726/imgdb/original/2024/0623/7117191234667225.jpg"
            let averageRating = Double.random(in: 1.0...5.0)

            let book = ListModel(id: id, thumbnailURL: URL(string: thumbnailURL), title: title, authors: authors, averageRating: averageRating)
            models.append(book)
        }

        return Just(SerchModel(totalItems: 20, items: models))
            .setFailureType(to: FecherError.self)
            .eraseToAnyPublisher()
    }
}
