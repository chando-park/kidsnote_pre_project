//
//  ListPresentData.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import Foundation

struct SearchListPresentData {
    let id: String
    let thumbnailURL: String?
    let title: String
    let authors: String
}


extension ListModel{
    func toPresentData() -> SearchListPresentData{
        SearchListPresentData(id: id, thumbnailURL: thumbnailURL?.absoluteString, title: title, authors: authors)
    }
}
