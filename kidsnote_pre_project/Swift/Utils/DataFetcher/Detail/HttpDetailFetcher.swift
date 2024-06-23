//
//  UrlSessionDetailFetcher.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import Foundation
import Combine

class UrlSessionDetailFetcher: DetailDataFecherType {
    func getDetail(key: String) -> AnyPublisher<BookDetailModel, FecherError> {
        let urlString = "https://www.googleapis.com/books/v1/volumes/\(key)"

        return URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
            .map(\.data)
            .decode(type: BookDetailModel.self, decoder: JSONDecoder())
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
