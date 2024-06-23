//
//  ViewControllerFactory.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import Foundation

class ViewControllerFactory {
    
    // 싱글톤 인스턴스
    static let shared = ViewControllerFactory()
    
    private init() {} // 외부에서 인스턴스화 방지
    
    // SerchListViewController 생성 메서드
    func makeSerchListViewController() -> SerchListViewController {
        let dataFetcher = HttpSerchListDataFecher() // 실제 데이터 페처
        let viewModel = SerchViewModel(fecher: dataFetcher)
        let viewController = SerchListViewController(viewModel: viewModel)
        return viewController
    }
    
    // DetailViewController 생성 메서드
    func makeDetailViewController(itemId: String) -> DetailViewController {
        let dataFetcher = HttpDetailFetcher() // 실제 데이터 페처
        let viewModel = DetailViewModel(fecher: dataFetcher)
        let viewController = DetailViewController(itemId: itemId, viewModel: viewModel)
        return viewController
    }
}
