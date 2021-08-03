//
//  RegexType.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 11/05/21.
//

import Foundation

enum RegexType: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case mobile = "^(?=.*?[0-9]).{7,12}$"
    case password = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,16}$"
    case fullname = "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$"
}
