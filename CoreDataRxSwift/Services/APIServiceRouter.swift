//
//  APIServiceRouter.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 17/05/21.
//

import Foundation
import Moya

enum APIServiceRouter {
    case login(LoginModel)
}

extension APIServiceRouter: TargetType {

    var baseURL: URL {
        return URL(string: "http://imaginato.mocklab.io")!
    }
    
    var path: String {
        switch self {
        case .login: return "/login" }
    }
    
    var method: Moya.Method {
        switch self {
        case .login: return .post }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let param) :
            return .requestParameters(parameters: param.toDictionary,
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type":"application/json"]
    }
    
    var sampleData: Data { return Data() }
}
