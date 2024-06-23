//
//  ListPresentData.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import Foundation

struct ListPresentData {
    let id: String
    let thumbnailURL: URL?
    let title: String
    let authors: String
}


extension ListModel{
    func toPresentData() -> ListPresentData{
        ListPresentData(id: id, thumbnailURL: thumbnailURL, title: title, authors: authors)
    }
}
