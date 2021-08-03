//
//  Extension+TableView.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 11/05/21.
//

import UIKit
extension UITableView {

    func dequeueCell<T:UITableViewCell>(_ cell :T.Type) -> T? {
        return self.dequeueReusableCell(withIdentifier: String(describing: cell)) as? T
    }

    func register<T: UITableViewCell>(_: T.Type, reuseIdentifier: String? = nil) {

        let identifier = String(describing: T.self)
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        self.register(nib, forCellReuseIdentifier: identifier)
    }

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }

    func restore() {
        self.backgroundView = nil
    }
}
