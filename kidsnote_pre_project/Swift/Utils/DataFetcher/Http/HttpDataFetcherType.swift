//
//  DataFetcher.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import Foundation
import Combine

// HttpDataFetcherType 프로토콜 정의
protocol HttpDataFetcherType {
}

// HttpDataFetcherType 프로토콜의 기본 구현 추가
extension HttpDataFetcherType {
    // 제네릭 fatcher 메서드 정의, 주소를 받아 해당 URL에서 데이터를 가져와 디코딩함
    func fatcher<T: Decodable>(address: String, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, FecherError> {
        // URLSession을 통해 데이터 가져오기
        return URLSession.shared.dataTaskPublisher(for: URL(string: address)!)
            .map(\.data) // 데이터 추출
            .decode(type: T.self, decoder: decoder) // JSONDecoder를 사용하여 디코딩
            .mapError { err in
                // 오류 처리
                if let decodingError = err as? DecodingError {
                    // 디코딩 오류 처리
                    let message: String = {
                        switch decodingError {
                        case .typeMismatch(let any, let context):
                            return "JSON에서 \(any) 키를 찾을 수 없습니다: \(context.debugDescription)"
                        case .valueNotFound(let any, let context):
                            return "JSON에서 \(any) 키를 찾을 수 없습니다: \(context.debugDescription)"
                        case .keyNotFound(let codingKey, let context):
                            return "JSON에서 \(codingKey) 키를 찾을 수 없습니다: \(context.debugDescription)"
                        case .dataCorrupted(let context):
                            return "JSON에서 키를 찾을 수 없습니다: \(context.debugDescription)"
                        @unknown default:
                            return err.localizedDescription
                        }
                    }()
                    
                    return FecherError.decodingErr(message: message)
                    
                } else if let error = err as? FecherError {
                    // FecherError 처리
                    return error
                } else {
                    // 기타 오류 처리
                    return FecherError.inServerError(code: (err as NSError).code, message: err.localizedDescription)
                }
            }
            .receive(on: DispatchQueue.main) // 메인 스레드에서 받기
            .eraseToAnyPublisher() // AnyPublisher로 변환
    }
}
