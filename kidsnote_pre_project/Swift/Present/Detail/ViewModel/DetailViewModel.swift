//
//  DetailViewModel.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import Foundation
import Combine

// DetailViewModelType 프로토콜 정의
protocol DetailViewModelType: AnyObject {
    var detailPublisher: AnyPublisher<DetailPresentData, Never> { get } // DetailPresentData의 퍼블리셔
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get } // 로딩 상태를 나타내는 퍼블리셔
    func getData(key: String) // 데이터를 가져오는 함수
}

// DetailViewModel 클래스 정의, DetailViewModelType 프로토콜을 준수
class DetailViewModel: DetailViewModelType {
    private let fecher: DetailDataFecherType // 데이터 페처
    
    @Published private var data: DetailPresentData // DetailPresentData의 퍼블리셔
    @Published private var isLoading: Bool = false // 로딩 상태의 퍼블리셔
    
    // detailPublisher 퍼블리셔 정의
    var detailPublisher: AnyPublisher<DetailPresentData, Never> {
        $data.eraseToAnyPublisher()
    }
    
    // isLoadingPublisher 퍼블리셔 정의
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>() // Combine을 위한 취소 가능한 객체 집합
    
    // 초기화 메서드, 기본 DetailPresentData와 데이터 페처를 받아 초기화
    init(data: DetailPresentData = DetailPresentData(thumbnailURL: nil, title: "", authors: "", desc: ""), fecher: DetailDataFecherType) {
        self.data = data
        self.fecher = fecher
    }
    
    // 데이터를 가져오는 함수
    func getData(key: String) {
        isLoading = true // 로딩 시작
        fecher.getDetail(key: key)
            .receive(on: DispatchQueue.main) // 메인 스레드에서 받기
            .map { $0.toPresenData() } // DetailModel을 DetailPresentData로 변환
            .sink { [weak self] completion in
                // 완료 시 로딩 종료
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error: \(error)")
                }
            } receiveValue: { [weak self] data in
                // 데이터 수신 시 업데이트
                self?.data = data
            }
            .store(in: &cancellables)
    }
}
