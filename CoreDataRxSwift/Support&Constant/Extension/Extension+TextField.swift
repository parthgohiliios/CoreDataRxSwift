//
//  Extension+TextField.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 11/05/21.
//

import UIKit

extension UITextField {

    func setupLeftImage(_ image:UIImage){
        let size : CGFloat = 20

        let imageView = UIImageView(frame: CGRect(x: 15, y: (self.frame.height-size)/2, width: size, height: size))
        imageView.image = image
        imageView.tintColor = .black
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height))
        imageContainerView.addSubview(imageView)
        leftView = imageContainerView
        leftViewMode = .always
    }

    func setupRightView(_ button: UIButton) {
        let size : CGFloat = 20
        button.frame = CGRect(x: 10, y: (self.frame.height-size)/2, width: size, height: size)
        let imageContainerView: UIView = UIView(frame: CGRect(x: self.frame.size.width - self.frame.height, y: 0, width: self.frame.height, height: self.frame.height))
        imageContainerView.addSubview(button)
        rightView = imageContainerView
        rightViewMode = .always
    }

    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date) {
        let screenWidth = UIScreen.main.bounds.width
        
        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()
            
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)
            return barButtonItem
        }
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
        datePicker.datePickerMode = datePickerMode
        self.inputView = datePicker
        datePicker.maximumDate = Date()

        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
}
