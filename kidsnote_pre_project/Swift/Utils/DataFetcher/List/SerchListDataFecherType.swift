//
//  ListDataFecherType.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import Combine
import Foundation

protocol SerchListDataFecherType{
    func getList(key: String) -> AnyPublisher<[ListModel], FecherError>
}
