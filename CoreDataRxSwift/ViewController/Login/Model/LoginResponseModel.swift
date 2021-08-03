//
//  LoginResponseModel.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 17/05/21.
//

import Foundation

struct LoginResponseModel: Codable {
    let result: Int
    var errorMessage: String
    let data: DataModel
    
    enum CodingKeys: String, CodingKey {
        case result
        case errorMessage = "error_message"
        case data
    }

    init() {
        result = 0
        errorMessage = "Your email or password is incorrect."
        data = DataModel(user: nil)
    }
}

// MARK: - DataClass
struct DataModel: Codable {
    let user: User?
}

// MARK: - User
struct User: Codable {
    let userID: Int
    let userName: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case userName
        case createdAt = "created_at"
    }

    var toDictionary: [String:Any] {
        return [CodingKeys.userID.rawValue: userID,
                CodingKeys.userName.rawValue: userName,
                CodingKeys.createdAt.rawValue: createdAt]
    }

    init(_ json: [String:Any]) {
        self.userID = json[CodingKeys.userID.rawValue] as? Int ?? 0
        self.userName = json[CodingKeys.userName.rawValue] as? String ?? ""
        self.createdAt = json[CodingKeys.createdAt.rawValue] as? Date ?? Date()
    }
}
