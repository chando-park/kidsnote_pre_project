//
//  UrlSessionDetailFetcher.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import Foundation
import Combine

// HttpDetailFetcher 클래스 정의, DetailDataFecherType 및 HttpDataFetcherType 프로토콜을 준수
class HttpDetailFetcher: DetailDataFecherType, HttpDataFetcherType {
    
    // getDetail 메서드, 주어진 키를 사용하여 책의 상세 정보를 가져옴
    func getDetail(key: String) -> AnyPublisher<BookDetailModel, FecherError> {
        // fatcher 메서드를 호출하여 데이터를 가져옴
        fatcher(address: "https://www.googleapis.com/books/v1/volumes/\(key)")
    }
}
