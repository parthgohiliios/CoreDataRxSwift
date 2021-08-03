//
//  LoginModel.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 17/05/21.
//

import Foundation

public struct LoginModel {
    let email: String
    let password: String
    
    var toDictionary: [String:Any] {
        return ["email":email, "password":password]
    }
}
