import Foundation
import Combine

// SerchViewModelType 프로토콜 정의
protocol SerchViewModelType: AnyObject {
    var listPublisher: AnyPublisher<[SearchListPresentData], Never> { get } // 검색 결과 리스트의 퍼블리셔
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get } // 로딩 상태를 나타내는 퍼블리셔
    func getData(key: String) // 데이터를 가져오는 함수
}

// SerchViewModel 클래스 정의, SerchViewModelType 프로토콜을 준수
class SerchViewModel: SerchViewModelType {
    private let fecher: SerchListDataFecherType // 데이터 페처
    
    @Published var list: [SearchListPresentData] // 검색 결과 리스트의 퍼블리셔
    @Published private var isLoading: Bool = false // 로딩 상태의 퍼블리셔
    
    // listPublisher 퍼블리셔 정의
    var listPublisher: AnyPublisher<[SearchListPresentData], Never> {
        $list.eraseToAnyPublisher()
    }
    
    // isLoadingPublisher 퍼블리셔 정의
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>() // Combine을 위한 취소 가능한 객체 집합
    
    // 초기화 메서드, 기본 검색 결과 리스트와 데이터 페처를 받아 초기화
    init(list: [SearchListPresentData] = [], fecher: SerchListDataFecherType) {
        self.list = list
        self.fecher = fecher
    }
    
    // 데이터를 가져오는 함수
    func getData(key: String) {
        isLoading = true // 로딩 시작
        fecher.getList(key: key)
            .receive(on: DispatchQueue.main) // 메인 스레드에서 받기
            .map { model in
                // 모델을 SearchListPresentData로 변환
                model.items.map { $0.toPresentData() }
            }
            .sink { [weak self] completion in
                // 완료 처리
                self?.isLoading = false // 로딩 종료
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    print(failure)
                    break
                }
            } receiveValue: { [weak self] list in
                // 데이터 수신 시 리스트 업데이트
                self?.list = list
            }
            .store(in: &cancellables)
    }
}
