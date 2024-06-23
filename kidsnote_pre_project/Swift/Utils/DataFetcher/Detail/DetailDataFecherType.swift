//
//  ListDataFecherType.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import Combine
import Foundation

protocol DetailDataFecherType{
    func getDetail(key: String) -> AnyPublisher<BookDetailModel, FecherError>
}
