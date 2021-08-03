//
//  Extension+String.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 11/05/21.
//

import Foundation

extension String {

    var isValidEmail: Bool {
        return self.validateString(RegexType.email)
    }

    var isValidMobile: Bool {
        return self.validateString(RegexType.mobile) && self.allSatisfy { $0.isNumber }
    }

    var isValidFullName: Bool {
        if self.isOnlyChar {
            let newText = self.condensed
            guard newText.count > 4, newText.count < 40 else { return false }
            return self.validateString(RegexType.fullname)
        } else {
            return false
        }
    }

    var isValidPassword: Bool {
        if self.contains(" ") { return false }
        return self.validateString(RegexType.password)
    }
    
    var isOnlyChar: Bool {
        return !(self.isEmpty) && self.allSatisfy { $0.isLetter || $0.isWhitespace}
    }
    
    var condensed: String {
        return replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }

    func validateLength(size: (min:Int, max:Int)) -> Bool {
        return (size.min...size.max).contains(self.count)
    }

    var isEmptyField : Bool {
        return self.isEmpty || self.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func validateString(_ pattern: RegexType) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", pattern.rawValue)
        return test.evaluate(with: self)
    }
}
