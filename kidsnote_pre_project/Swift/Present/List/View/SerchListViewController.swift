import UIKit
import Combine

class ViewController: UIViewController {
    
    private let customSearchView = CustomSearchView()
    private var viewModel: SerchViewModelType!
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SerchViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(customSearchView)
        setupConstraints()
        setupBindings()
        
        customSearchView.searchAction = { [weak self] searchText in
            self?.viewModel.getData(key: searchText)
        }
        
        customSearchView.itemSelectedAction = { [weak self] itemId in
            self?.showDetailViewController(for: itemId)
        }
    }
    
    private func setupConstraints() {
        customSearchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customSearchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customSearchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customSearchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customSearchView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
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
                    self?.customSearchView.activityIndicator.startAnimating()
                } else {
                    self?.customSearchView.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showDetailViewController(for itemId: String) {
        let detailViewController = DetailViewController(itemId: itemId)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
