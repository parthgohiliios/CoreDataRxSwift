//
//  EmployeeTableCell.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 11/05/21.
//

import UIKit

class EmployeeTableCell: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet private weak var placeHolderLabel: UILabel!
    @IBOutlet private weak var fullnameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var mobileLabel: UILabel!
    @IBOutlet private weak var joiningDateLabel: UILabel!

    //MARK:- Varibales
    var employee : Employee? {
        didSet{
            if let emp = employee {
                placeHolderLabel.backgroundColor = UIColor.randomColor
                placeHolderLabel.text = getplaceHolderName(emp.fullname)
                fullnameLabel.text = emp.fullname
                emailLabel.text = "Email: " + emp.email
                mobileLabel.text = "Mob: " + emp.mobile
                joiningDateLabel.text = "Joining date:  \(emp.joiningDateStirng) "
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        placeHolderLabel.applyCircle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // Geting first latter of first two words
    private func getplaceHolderName(_ name: String) -> String {
        var placeHolder = ""
        let names =  name.components(separatedBy: " ")
        if names.count > 0 {
            placeHolder = String(names[0].prefix(1))
            if names.count > 1 {
                placeHolder = placeHolder + "\(String(names[1].prefix(1)))"
            }
        }
        return placeHolder.uppercased()
    }
}
