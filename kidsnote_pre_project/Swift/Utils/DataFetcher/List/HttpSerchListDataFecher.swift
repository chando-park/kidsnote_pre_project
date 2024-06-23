//
//  UrlSessionFecher.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import Combine
import Foundation

class HttpSerchListDataFecher: SerchListDataFecherType, HttpDataFetcherType{
    func getList(key: String) -> AnyPublisher<SerchModel, FecherError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return fatcher(address: "https://www.googleapis.com/books/v1/volumes?q=\(key)+intitle&maxResults=40&projection=lite", decoder: decoder)
    }
}
