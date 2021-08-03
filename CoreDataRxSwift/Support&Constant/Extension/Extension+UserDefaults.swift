//
//  Extension+UserDefaults.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 17/05/21.
//

import Foundation

extension UserDefaults {
    var user: User? {
        get {
            guard let user = UserDefaults.standard.object(forKey: UserDefaultKeys.user) as? [String:Any] else { return nil }
            return User(user)
        }
        set {
            UserDefaults.standard.set(newValue?.toDictionary, forKey: UserDefaultKeys.user)
        }
    }
    
    func removeUserData() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.user)
        UserDefaults.standard.synchronize()
    }
}
