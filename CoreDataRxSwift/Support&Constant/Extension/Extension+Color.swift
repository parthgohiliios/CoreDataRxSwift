//
//  Extension+Color.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 12/05/21.
//

import UIKit

extension UIColor {

    static let themeColor = UIColor.rgb(red: 99, green: 12, blue: 230)
    static let blue = UIColor.rgb(red: 85, green: 75, blue: 160)
    static let darkpink = UIColor.rgb(red: 200, green: 65, blue: 175)
    static let skyblue = UIColor.rgb(red: 0, green: 135, blue: 210)
    static let lightOrange = UIColor.rgb(red: 255, green: 100, blue: 100)
    static let darkOrange = UIColor.rgb(red: 255, green: 130, blue: 70)
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0)
    }

    static var randomColor: UIColor {
        let colors = [UIColor.blue,
                      UIColor.darkpink,
                      UIColor.skyblue,
                      UIColor.lightOrange,
                      UIColor.darkOrange,
                      UIColor.purple,
                      UIColor.systemPink,
                      UIColor.systemBlue,
                      UIColor.systemGreen]
        if let color = colors.randomElement() {
            return color
        }
        return UIColor.themeColor
    }
}
