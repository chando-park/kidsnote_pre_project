//
//  ListModel.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import Foundation

struct SerchModel: Decodable {
    let totalItems: Int
    let items: [ListModel]
    
}

struct ListModel: Decodable {
    let id: String
    let thumbnailURL: URL?
    let title: String
    let authors: String
    let averageRating: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case volumeInfo
    }

    enum VolumeInfoKeys: String, CodingKey {
        case title
        case authors
        case imageLinks
        case averageRating
    }

    enum ImageLinksKeys: String, CodingKey {
        case thumbnail
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)

        let volumeInfoContainer = try container.nestedContainer(keyedBy: VolumeInfoKeys.self, forKey: .volumeInfo)
        self.title = try volumeInfoContainer.decode(String.self, forKey: .title)
        self.authors = (try volumeInfoContainer.decodeIfPresent([String].self, forKey: .authors))?.joined(separator: ",") ?? ""
        self.averageRating = try volumeInfoContainer.decodeIfPresent(Double.self, forKey: .averageRating)

        let imageLinksContainer = try? volumeInfoContainer.nestedContainer(keyedBy: ImageLinksKeys.self, forKey: .imageLinks)
        let urlStr = (try imageLinksContainer?.decode(String.self, forKey: .thumbnail) ?? "").replacingOccurrences(of: "http", with: "https") + ".png"
        self.thumbnailURL = URL(string: urlStr)
    }
    
    init(id: String, thumbnailURL: URL?, title: String, authors: String, averageRating: Double?) {
        self.id = id
        self.thumbnailURL = thumbnailURL
        self.title = title
        self.authors = authors
        self.averageRating = averageRating
    }
}
