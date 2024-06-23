//
//  kidsnote_pre_projectTests.swift
//  kidsnote_pre_projectTests
//
//  Created by Chando Park on 6/23/24.
//

import XCTest
@testable import kidsnote_pre_project
import Combine

final class kidsnote_pre_projectTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchSerchBookNetworkCall() {
        // NewsApiClient 인스턴스 생성
        let fecher = HttpSerchListDataFecher()
        
        // 네트워크 요청에 대한 기대 설정
        let expectation = self.expectation(description: "testFetchSerchBookNetworkCall")
        
        // fetchTopHeadlines 호출 및 결과 처리
        fecher.getList(key: "꽃")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("네트워크 요청 실패: \(error)")
                }
            }, receiveValue: { articles in
                XCTAssertGreaterThan(articles.count, 0, "책정보는 최소한 하나 이상이어야 합니다.")
                expectation.fulfill()
            })
            .store(in: &self.cancellables)
        
        // 네트워크 요청이 완료될 때까지 대기
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchDetailBookNetworkCall() {
        // NewsApiClient 인스턴스 생성
        let fecher = HttpDetailFetcher()
        
        // 네트워크 요청에 대한 기대 설정
        let expectation = self.expectation(description: "testFetchSerchBookNetworkCall")
        
        // fetchTopHeadlines 호출 및 결과 처리
        fecher.getDetail(key: "JM1CAQAAMAAJ")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("네트워크 요청 실패: \(error)")
                }
            }, receiveValue: { detail in
                XCTAssertEqual("The Flower People", detail.volumeInfo.title)
                expectation.fulfill()
            })
            .store(in: &self.cancellables)
        
        // 네트워크 요청이 완료될 때까지 대기
        waitForExpectations(timeout: 10, handler: nil)
    }
}
