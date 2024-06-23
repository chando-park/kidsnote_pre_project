//
//  UrlSessionFecher.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import Combine
import Foundation

class HttpSerchListDataFecher: SerchListDataFecherType{
    struct Response: Decodable {
        let totalItems: Int
        let items: [ListModel]
        
    }
    func getList(key: String) -> AnyPublisher<[ListModel], FecherError> {
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(key)+intitle&maxResults=40&projection=lite")!
        let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Response.self, decoder: decoder)
            .tryMap({ res -> [ListModel]in
                print("🦊 response ::: \(res)")
                return res.items
            })
            .mapError { err in
                if let decodingError = err as? DecodingError {
                    let message: String = {
                        switch decodingError {
                        case .typeMismatch(let any, let context):
                            return "could not find key \(any) in JSON: \(context.debugDescription)"
                        case .valueNotFound(let any, let context):
                            return "could not find key \(any) in JSON: \(context.debugDescription)"
                        case .keyNotFound(let codingKey, let context):
                            return "could not find key \(codingKey) in JSON: \(context.debugDescription)"
                        case .dataCorrupted(let context):
                            return "could not find key in JSON: \(context.debugDescription)"
                        @unknown default:
                            return err.localizedDescription
                        }
                    }()
                    
                    return FecherError.decodingErr(message: message)
                    
                } else if let error = err as? FecherError {
                    return error
                } else {
                    return FecherError.inServerError(code: (err as NSError).code, message: err.localizedDescription)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .eraseToAnyPublisher()
    }
}
