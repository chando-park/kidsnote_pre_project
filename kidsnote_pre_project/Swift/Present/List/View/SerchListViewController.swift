import UIKit
import Combine

// SerchListViewController 클래스 정의
class SerchListViewController: UIViewController {
    
    private let customSearchView = CustomSearchView() // 사용자 정의 검색 뷰
    private var viewModel: SerchViewModelType! // ViewModel 타입
    private var cancellables = Set<AnyCancellable>() // Combine을 위한 취소 가능한 객체 집합
    private let activityIndicator = UIActivityIndicatorView(style: .large) // 인디케이터
    
    // 생성자, ViewModel을 받아 초기화
    init(viewModel: SerchViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // 상태 표시줄 스타일 설정
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // 필수 초기화자, 코드 사용을 금지
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 뷰가 로드될 때 호출됨
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(customSearchView) // customSearchView를 뷰에 추가
        view.addSubview(activityIndicator) // 인디케이터를 뷰에 추가
        setupConstraints() // 제약 조건 설정
        setupBindings() // ViewModel과 바인딩 설정
        
        // 검색 액션 설정
        customSearchView.searchAction = { [weak self] searchText in
            self?.viewModel.getData(key: searchText)
        }
        
        // 항목 선택 액션 설정
        customSearchView.itemSelectedAction = { [weak self] itemId in
            self?.showDetailViewController(for: itemId)
        }
    }
    
    // 제약 조건 설정 메서드
    private func setupConstraints() {
        customSearchView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customSearchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customSearchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customSearchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customSearchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // ViewModel과 바인딩 설정 메서드
    private func setupBindings() {
        viewModel.listPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.customSearchView.data = data
                self?.customSearchView.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
    
    // 상세 뷰 컨트롤러를 표시하는 메서드
    private func showDetailViewController(for itemId: String) {
        let detailViewController = ViewControllerFactory.shared.makeDetailViewController(itemId: itemId)
        navigationController?.pushViewController(detailViewController, animated: true)
    }}
