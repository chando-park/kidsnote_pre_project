//
//  SerchViewModel.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import Foundation
import Combine


protocol DetailViewModelType: AnyObject{
    var listPublisher: AnyPublisher<DetailPresentData, Never> { get }
    func getData(key: String)
}

class DetailViewModel: DetailViewModelType {
    private let fecher: DetailDataFecherType
    
    @Published var data: DetailPresentData
    
    var listPublisher: AnyPublisher<DetailPresentData, Never> {
        $list.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(data: DetailPresentData = DetailPresentData(thumbnailURL: nil, title: "", authors: "", desc: ""), fecher: DetailDataFecherType) {
        self.data = data
        self.fecher = fecher
    }
    
    func getData(key: String) {
        fecher.getDetail(key: key)
            .receive(on: DispatchQueue.main)
            .map { models in
                models.map { $0.toPresentData()}
            }
            .sink { f in
                switch f {
                case .finished:
                    break
                case .failure(let failure):
                    print(failure)
                    break
                }
            } receiveValue: { list in
                self.list = list
            }
        .store(in: &cancellables)    }
}

