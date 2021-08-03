//
//  Employee.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 11/05/21.
//

import Foundation
import CoreData
import RxDataSources
import RxCoreData

struct Employee {
    var fullname: String
    var email: String
    var mobile: String
    var password: String
    var joiningDate: Date
    var createdDate :Date

    var joiningDateStirng: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: joiningDate)
        return dateString
    }
}

extension Employee : Equatable {
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        return lhs.email == rhs.email
    }
}

extension Employee : IdentifiableType {
    typealias Identity = String
    var identity: Identity { return email }
}

extension Employee : Persistable {

    typealias T = NSManagedObject

    static var entityName: String { return "Employee" }
    static var primaryAttributeName: String { return "email" }
    static var shortingAttributeName: String { return "createdDate" }

    init(entity: T) {
        fullname = entity.value(forKey: "fullname") as! String
        email = entity.value(forKey: "email") as! String
        mobile = entity.value(forKey: "mobile") as! String
        password = entity.value(forKey: "password") as! String
        joiningDate = entity.value(forKey: "joiningDate") as! Date
        createdDate = entity.value(forKey: "createdDate") as! Date
    }

    func update(_ entity: T) {
        entity.setValue(fullname, forKey: "fullname")
        entity.setValue(email, forKey: "email")
        entity.setValue(mobile, forKey: "mobile")
        entity.setValue(password, forKey: "password")
        entity.setValue(createdDate, forKey: "createdDate")
        entity.setValue(joiningDate, forKey: "joiningDate")
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
}

