//
//  Extension+UIView.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 12/05/21.
//

import UIKit

extension UIView {
    func applyCircle() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) * 0.5
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }

    func applyBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}
