//
//  StringContants.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 11/05/21.
//

import Foundation

struct AlertConstant {
    static let OK = "OK"
    static let Error = "Error"
    static let Cancel = "Cancel"
    static let Logout = "Logout"
}

struct ErrorMessage {
    static let fullname = "Full name should be 5 to 40 characters."
    static let email = "Email is not valid."
    static let password = "Password require at least 1 uppercase, 1 lowercase, 1 number and should be at least 8 characters."
    static let mobile = "Mobile number should be 7 to 12 digits."
    static let joiningDate = "Joining date should be today or earlier."
    static let existEmail = "This email is already exist."
    static let noEmplpoyee = "You haven't added any employee yet"
    static let logout = "Are you sure you want to log out? Once logged out all locally saved records will be removed."
}

enum ValidationType: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case mobile = "^(?=.*?[0-9]).{7,12}$"
    case password = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,16}$"
    case fullname = "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$"
}

struct Title {
    static let employee = "Employees"
    static let addEmployee = "Add Employee"
    static let login = "Login"
}

struct UserDefaultKeys {
    static let user = "User"
    static let isLogin = "isLogin"
}
