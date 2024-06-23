//
//  SerchView.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import Foundation

import UIKit
import Combine

class SerchView: UIView, UISearchBarDelegate {

    let searchBar = UISearchBar()
    let tableView = UITableView()
    var viewModel: ListPresentData? {
        didSet {
            bindViewModel()
        }
    }
    private var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        // Search Bar 설정
        searchBar.placeholder = "Play 북에서 검색"
        searchBar.delegate = self
        addSubview(searchBar)

        // Table View 설정
        tableView.isHidden = true
        addSubview(tableView)

        // 레이아웃 설정
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func bindViewModel() {
        viewModel?.$ListPresentData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        expandView()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        collapseView()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel?.performSearch(query: query)
        searchBar.resignFirstResponder()
    }

    private func expandView() {
        UIView.animate(withDuration: 0.3) {
            self.frame = UIScreen.main.bounds
            self.tableView.isHidden = false
        }
    }

    private func collapseView() {
        UIView.animate(withDuration: 0.3) {
            self.frame = CGRect(x: 0, y: 0, width: self.superview?.frame.width ?? self.frame.width, height: (self.superview?.frame.height ?? self.frame.height) / 3)
            self.tableView.isHidden = true
        }
    }
}
