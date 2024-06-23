//
//  DetailViewController.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    private var itemId: String
    private var detailData: DetailPresentData?
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorsLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    init(itemId: String) {
        self.itemId = itemId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        loadData()
    }
    
    private func setupUI() {
        // Configure UI elements
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        authorsLabel.font = UIFont.systemFont(ofSize: 18)
        authorsLabel.textColor = .gray
        authorsLabel.numberOfLines = 0
        authorsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(authorsLabel)
        view.addSubview(descriptionLabel)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 400), // Height is now doubled
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            authorsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            authorsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authorsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorsLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func loadData() {
        // Load data based on itemId
        // This is a mock implementation. Replace it with a real data fetching logic.
        detailData = DetailPresentData(
            thumbnailURL: "https://books.google.com/books/content?id=Z0tWcgAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api.png",
            title: "Sample Title",
            authors: "Sample Authors",
            desc: "This is a sample description of the item."
        )
        
        updateUI()
    }
    
    private func updateUI() {
        guard let detailData = detailData else { return }
        
        if let urlString = detailData.thumbnailURL {
            // Load image asynchronously
            imageView.setImage(with: urlString)
        } else {
            imageView.image = nil
        }
        
        titleLabel.text = detailData.title
        authorsLabel.text = detailData.authors
        descriptionLabel.text = detailData.desc
    }
}
