//
//  SerchViewModelMock.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import Combine
import Foundation

class SerchViewModelMock: SerchViewModelType {
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        Just(false).eraseToAnyPublisher()
    }
    
    @Published var list: [SearchListPresentData]
    
    var listPublisher: AnyPublisher<[SearchListPresentData], Never> {
        $list.eraseToAnyPublisher()
    }
    
    init(list: [SearchListPresentData] = []) {
        self.list = list
    }
    
    func getData(key: String) {
        // Mock data for testing
        let mockData = [
            SearchListPresentData(id: "1", thumbnailURL:  "https://example.com/image1.jpg", title: "Mock Result 1", authors: "Mock Author 1"),
            SearchListPresentData(id: "2", thumbnailURL:  "https://example.com/image2.jpg", title: "Mock Result 2", authors: "Mock Author 2"),
            SearchListPresentData(id: "3", thumbnailURL:  "https://example.com/image3.jpg", title: "Mock Result 3", authors: "Mock Author 3")
        ]
        list = mockData
    }
}
