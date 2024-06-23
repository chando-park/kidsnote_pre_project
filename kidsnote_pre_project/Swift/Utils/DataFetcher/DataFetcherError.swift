//
//  DataFetcherError.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import Foundation

public enum FecherError: Error{
    case decodingErr(message: String?)
    case noDataErr(message: String?)
    case networkingErr(message: String?)
    case etcErr(message: String?)
    case urlErr(message: String?)
    case inServerError(code: Int, message: String?)
                       
    public var desc: String?{
        switch self {
        case .decodingErr(let message):
            return message
        case .noDataErr(let message):
            return message
        case .networkingErr(let message):
            return message
        case .etcErr(let message):
            return message
        case .urlErr(let message):
            return message
        case .inServerError(_, let message):
            return message
        }
    }
    
    public var code: Int{
        switch self {
        case .decodingErr(_):
            return 1200
        case .noDataErr(_):
            return 1300
        case .networkingErr(_):
            return 5100
        case .etcErr(_):
            return 2000
        case .urlErr(_):
            return 1100
        case .inServerError(let code, _):
            return code
        }
    }
}
