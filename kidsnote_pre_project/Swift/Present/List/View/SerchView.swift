import UIKit

class CustomSearchView: UIView, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private let topStatusBar: UIView = {
        let statusBar = UIView()
        statusBar.backgroundColor = UIColor.white
        return statusBar
    }()
    
    private let searchBarView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Search..."
        label.textColor = .gray
        return label
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.isHidden = true
        textField.placeholder = "Search..."
        return textField
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .gray
        button.isHidden = true
        button.addTarget(self, action: #selector(clearSearch), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.tintColor = .gray
        button.isHidden = true
        button.addTarget(self, action: #selector(backToInitial), for: .touchUpInside)
        return button
    }()
    
    private let roundButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(.clear, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private var blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "SearchResultCell")
        return tableView
    }()
    
    var data = [SearchListPresentData]()
    
    // 파란색 뷰의 제약 조건
    private var blueViewTopConstraint: NSLayoutConstraint!
    private var blueViewLeadingConstraint: NSLayoutConstraint!
    private var blueViewTrailingConstraint: NSLayoutConstraint!
    private var blueViewHeightConstraint: NSLayoutConstraint!
    
    // 검색 및 항목 선택 액션 클로저
    var searchAction: ((String) -> Void)?
    var itemSelectedAction: ((String) -> Void)?
    
    // 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        // 서브뷰 추가
        addSubview(topStatusBar)
        addSubview(searchBarView)
        searchBarView.addSubview(searchIcon)
        searchBarView.addSubview(backButton)
        searchBarView.addSubview(placeholderLabel)
        searchBarView.addSubview(searchTextField)
        searchBarView.addSubview(clearButton)
        searchBarView.addSubview(roundButton)
        insertSubview(blueView, belowSubview: searchBarView)
        blueView.addSubview(tableView)
        
        // 제약 조건 설정
        setupConstraints()
        
        // 초기 상태 설정
        blueView.isHidden = true
        
        // 델리게이트 설정
        searchTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // 필수 초기화자, 코드 사용을 금지
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 제약 조건 설정 메서드
    private func setupConstraints() {
        
        topStatusBar.translatesAutoresizingMaskIntoConstraints = false
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        blueView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // 상단 상태 표시줄 제약 조건
        NSLayoutConstraint.activate([
            topStatusBar.topAnchor.constraint(equalTo: self.topAnchor),
            topStatusBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topStatusBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topStatusBar.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // 검색 바 뷰 제약 조건
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: topStatusBar.bottomAnchor, constant: 10),
            searchBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            searchBarView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            searchBarView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // 검색 아이콘 제약 조건
        NSLayoutConstraint.activate([
            searchIcon.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 10),
            searchIcon.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 20),
            searchIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // 뒤로 가기 버튼 제약 조건
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 10),
            backButton.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // 플레이스홀더 라벨 제약 조건
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 10),
            placeholderLabel.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor)
        ])
        
        // 검색 텍스트 필드 제약 조건
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -10),
            searchTextField.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor)
        ])
        
        // 검색어 삭제 버튼 제약 조건
        NSLayoutConstraint.activate([
            clearButton.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -10),
            clearButton.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 20),
            clearButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // 원형 버튼 제약 조건 (검색 바 위에 위치)
        NSLayoutConstraint.activate([
            roundButton.topAnchor.constraint(equalTo: searchBarView.topAnchor),
            roundButton.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor),
            roundButton.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor),
            roundButton.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor)
        ])
        
        // 파란색 뷰 초기 제약 조건
        blueViewTopConstraint = blueView.topAnchor.constraint(equalTo: topStatusBar.bottomAnchor, constant: 10)
        blueViewLeadingConstraint = blueView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        blueViewTrailingConstraint = blueView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        blueViewHeightConstraint = blueView.heightAnchor.constraint(equalToConstant: 40)
        
        NSLayoutConstraint.activate([
            blueViewTopConstraint,
            blueViewLeadingConstraint,
            blueViewTrailingConstraint,
            blueViewHeightConstraint
        ])
        
        // 테이블 뷰 제약 조건
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    // 원형 버튼 클릭 시 호출되는 메서드
    @objc private func buttonTapped() {
        blueView.isHidden = false
        roundButton.isHidden = true // 파란색 뷰가 보일 때 원형 버튼 숨기기
        
        NSLayoutConstraint.deactivate([blueViewTopConstraint, blueViewLeadingConstraint, blueViewTrailingConstraint, blueViewHeightConstraint])
        
        blueViewTopConstraint = blueView.topAnchor.constraint(equalTo: self.topAnchor)
        blueViewLeadingConstraint = blueView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        blueViewTrailingConstraint = blueView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        blueViewHeightConstraint = blueView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([blueViewTopConstraint, blueViewLeadingConstraint, blueViewTrailingConstraint, blueViewHeightConstraint])
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
            self.blueView.backgroundColor = .lightGray
        }, completion: { _ in
            // 애니메이션 완료 후 검색 텍스트 필드를 표시하고 플레이스홀더 라벨 숨기기
            self.placeholderLabel.isHidden = true
            self.searchTextField.isHidden = false
            self.searchIcon.isHidden = true
            self.backButton.isHidden = false
            self.clearButton.isHidden = false
            self.searchTextField.becomeFirstResponder()
            self.tableView.isHidden = false
        })
    }
    
    // 검색어 삭제 버튼 클릭 시 호출되는 메서드
    @objc private func clearSearch() {
        searchTextField.text = ""
        data.removeAll()
        tableView.reloadData()
    }
    
    // 뒤로 가기 버튼 클릭 시 호출되는 메서드
    @objc private func backToInitial() {
        resetToInitialState()
    }
    
    // UITextFieldDelegate - 리턴 키 눌렀을 때 호출
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let searchText = textField.text, !searchText.isEmpty {
            searchAction?(searchText)
        }
        return true
    }
    
    // UITableViewDataSource - 섹션의 행 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // UITableViewDataSource - 각 행에 대한 셀 생성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else {
            return UITableViewCell()
        }
        cell.configure(with: data[indexPath.row])
        return cell
    }
    
    // UITableViewDelegate - 셀 선택 시 호출
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = data[indexPath.row]
        itemSelectedAction?(selectedItem.id)
    }
    
    // 초기 상태로 리셋하는 메서드
    private func resetToInitialState() {
        roundButton.isHidden = false // 초기 상태로 돌아갈 때 원형 버튼 표시
        placeholderLabel.isHidden = false
        searchTextField.isHidden = true
        searchTextField.text = ""
        searchTextField.resignFirstResponder() // 키보드 숨기기
        searchIcon.isHidden = false
        backButton.isHidden = true
        clearButton.isHidden = true
        data.removeAll()
        tableView.reloadData()
        
        NSLayoutConstraint.deactivate([blueViewTopConstraint, blueViewLeadingConstraint, blueViewTrailingConstraint, blueViewHeightConstraint])
        
        blueViewTopConstraint = blueView.topAnchor.constraint(equalTo: topStatusBar.bottomAnchor, constant: 10)
        blueViewLeadingConstraint = blueView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        blueViewTrailingConstraint = blueView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        blueViewHeightConstraint = blueView.heightAnchor.constraint(equalToConstant: 40)
        
        NSLayoutConstraint.activate([blueViewTopConstraint, blueViewLeadingConstraint, blueViewTrailingConstraint, blueViewHeightConstraint])
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
            self.blueView.backgroundColor = .white
        }, completion: { _ in
            self.blueView.isHidden = true
        })
    }
}
