//
//  SerchResultCell.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import UIKit

// SearchResultCell 클래스 정의, UITableViewCell을 상속
class SearchResultCell: UITableViewCell {
    
    // 썸네일 이미지 뷰
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    // 제목 라벨
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    // 저자 라벨
    private let authorsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    // 초기화 메서드
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .lightGray
        
        addSubview(thumbnailImageView) // 썸네일 이미지 뷰 추가
        addSubview(titleLabel) // 제목 라벨 추가
        addSubview(authorsLabel) // 저자 라벨 추가
        
        // 오토레이아웃 설정
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        authorsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 제약 조건 활성화
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            thumbnailImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 50),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            authorsLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            authorsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            authorsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            authorsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    // 필수 초기화자, 코드 사용을 금지
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 셀 구성 메서드
    func configure(with data: SearchListPresentData) {
        if let url = data.thumbnailURL {
            print("url \(url)")
            self.thumbnailImageView.setImage(with: url)
        } else {
            thumbnailImageView.image = nil
        }
        titleLabel.text = data.title
        authorsLabel.text = data.authors
    }
}
