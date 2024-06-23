//
//  ListPresentData.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import Foundation

struct DetailPresentData {
    let thumbnailURL: String?
    let title: String
    let authors: String
    let desc: String?
}



extension BookDetailModel{
    func toPresenData() -> DetailPresentData{
        DetailPresentData(thumbnailURL: volumeInfo.imageLinks?.thumbnail, title: volumeInfo.title, authors: volumeInfo.authors.joined(separator: ","), desc: volumeInfo.description)
    }
}
