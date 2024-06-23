import UIKit
import Combine

class DetailViewController: UIViewController {
    
    private var itemId: String
    private var viewModel: DetailViewModelType
    private var cancellables = Set<AnyCancellable>()
    
    private let detailView = DetailView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    init(itemId: String, viewModel: DetailViewModelType) {
        self.itemId = itemId
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(detailView)
        view.addSubview(activityIndicator)
        
        setupConstraints()
        setupBindings()
        viewModel.getData(key: itemId)
    }
    
    private func setupConstraints() {
        detailView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.detailPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detailData in
                self?.detailView.configure(with: detailData)
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
}
