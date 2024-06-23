//
//  DetailModel.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import Foundation

struct BookDetailModel: Decodable {
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Decodable {
    let title: String
    let authors: [String]
    let description: String?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Decodable {
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbnail = "medium"
    }
    
    init(thumbnail: String?) {
        self.thumbnail = thumbnail
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.thumbnail = (try container.decodeIfPresent(String.self, forKey: .thumbnail)?.replacingOccurrences(of: "http", with: "https") ?? "") + ".png"
    }
}
