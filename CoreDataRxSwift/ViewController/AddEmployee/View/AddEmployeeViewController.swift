//
//  AddEmployeeViewController.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 11/05/21.
//

import UIKit
import RxSwift
import RxCocoa

class AddEmployeeViewController: UIViewController {

    //MARK:- IBOutlets -
    @IBOutlet private weak var fullnameTextField: UITextField!
    @IBOutlet private weak var fullnameErrorLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailErrorLabel: UILabel!
    @IBOutlet private weak var mobileTextField: UITextField!
    @IBOutlet private weak var mobileErrorLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    @IBOutlet private weak var joiningDateTextField: UITextField!
    @IBOutlet private weak var joiningDateErrorLabel: UILabel!
    @IBOutlet private weak var addEmployeeButton: UIButton!
    
    //MARK:- Variables -
    static func instance() -> AddEmployeeViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEmployeeViewController") as? AddEmployeeViewController
    }

    private let disposeBag = DisposeBag()
    private var viewModel: AddEmployeeViewModel!
    private var joiningDate: Date?
    
    lazy var passwordShowButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        button.setImage(#imageLiteral(resourceName: "ic_show_password.png"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "ic_hide_password"), for: .selected)
        return button
    }()

    // MARK:- LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK:- Date Picker Botton Action
    @objc private func cancelAction() {
        self.joiningDateTextField.resignFirstResponder()
        resignTextField()
    }

    @objc private func doneAction() {
        if let datePickerView = self.joiningDateTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.joiningDateTextField.text = dateString
            joiningDate = datePickerView.date
            self.joiningDateTextField.resignFirstResponder()
        }
        resignTextField()
    }

    // MARK:- de-init
    deinit { }
}

// MARK:- General Methods -
extension AddEmployeeViewController {
    fileprivate func initialization() {
        setupUI()
        viewModel = AddEmployeeViewModel()
        bindTextFields()
        bindButtons()
        bindViewModel()
        bindErrorMessageWithLabel()
        resignTextField()
    }

    private func setupUI() {
        self.view.layoutIfNeeded()
        self.title = Title.addEmployee

        addEmployeeButton.backgroundColor = UIColor.themeColor
        addEmployeeButton.applyCircle()

        fullnameTextField.setupLeftImage(.user)
        emailTextField.setupLeftImage(.email)
        mobileTextField.setupLeftImage(.mobile)
        passwordTextField.setupLeftImage(.password )
        joiningDateTextField.setupLeftImage(.joiningDate)
        passwordTextField.setupRightView(passwordShowButton)

        fullnameTextField.applyCircle()
        emailTextField.applyCircle()
        mobileTextField.applyCircle()
        passwordTextField.applyCircle()
        joiningDateTextField.applyCircle()
    }

    private func bindErrorMessageWithLabel() {
        fullnameErrorLabel.text = ErrorMessage.fullname
        emailErrorLabel.text = ErrorMessage.email
        mobileErrorLabel.text = ErrorMessage.mobile
        passwordErrorLabel.text = ErrorMessage.password
        joiningDateErrorLabel.text = ErrorMessage.joiningDate
    }

    private func bindTextFields() {

        fullnameTextField.rx.text
            .asObservable()
            .subscribe(onNext: { [weak self] (text) in
                self?.viewModel.onFullnameChanged(text)
                self?.activeBorderFor(self?.fullnameTextField)
            })
            .disposed(by: disposeBag)

        emailTextField.rx.text
            .asObservable()
            .subscribe(onNext: { [weak self] (text) in
                self?.viewModel.onEmailChanged(text)
                self?.activeBorderFor(self?.emailTextField)
            })
            .disposed(by: disposeBag)
        
        mobileTextField.rx.text
            .asObservable()
            .subscribe(onNext: { [weak self] (text) in
                self?.viewModel.onMobileChanged(text)
                self?.activeBorderFor(self?.mobileTextField)
            })
            .disposed(by: disposeBag)

        passwordTextField.rx.text
            .asObservable()
            .subscribe(onNext: { [weak self] (text) in
                self?.viewModel.onPasswordChanged(text)
                self?.activeBorderFor(self?.passwordTextField)
            })
            .disposed(by: disposeBag)

        joiningDateTextField.rx.text
            .asObservable()
            .subscribe(onNext: { [weak self] (text) in
                self?.viewModel.onJoiningDateChanged(text)
                self?.activeBorderFor(self?.joiningDateTextField)
            })
            .disposed(by: disposeBag)

        joiningDateTextField.datePicker(target: self,
                                        doneAction: #selector(doneAction),
                                        cancelAction: #selector(cancelAction),
                                        datePickerMode: .date)
    }

    func bindButtons() {
        addEmployeeButton.rx.tap
            .map { [unowned  self] _ -> Employee in
                return Employee(fullname: self.fullnameTextField.text!.condensed,
                                email: self.emailTextField.text!,
                                mobile: self.mobileTextField.text!,
                                password:self.passwordTextField.text!,
                                joiningDate: joiningDate ?? Date(),
                                createdDate: Date())
            }.subscribe(onNext: { [weak self] (emp) in
                guard let `self` = self else { return }
                _ = try? CoreDataModel.shared.managedObjectContext.rx.update(emp)
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        passwordShowButton.rx.tap
            .subscribe(onNext: { _ in
                self.passwordTextField.isSecureTextEntry = self.passwordShowButton.isSelected
                self.passwordShowButton.isSelected.toggle()
            })
            .disposed(by: self.disposeBag)
    }

    private func bindViewModel() {

        viewModel.showFulnameErrorObservable
            .takeUntil(rx.deallocating)
            .bind(to: fullnameErrorLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.showEmailErrorObservable
            .takeUntil(rx.deallocating)
            .bind(to: emailErrorLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.showMobileErrorObservable
            .takeUntil(rx.deallocating)
            .bind(to: mobileErrorLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.showPasswordErrorObservable
            .takeUntil(rx.deallocating)
            .bind(to: passwordErrorLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.showJoiningDateErrorObservable
            .takeUntil(rx.deallocating)
            .bind(to: joiningDateErrorLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.enableAddEmployeeButtonObservable
            .takeUntil(rx.deallocating)
            .subscribe(onNext: { [weak self] (enable) in
                self?.addEmployeeButton.isEnabled = enable
                self?.addEmployeeButton.alpha = enable ? 1: 0.4
            })
            .disposed(by: disposeBag)
    }

    // Set Active border
    func activeBorderFor(_ textField: UITextField? = nil) {
        self.fullnameTextField.applyBorder(color: .clear, width: 0)
        self.emailTextField.applyBorder(color: .clear, width: 0)
        self.mobileTextField.applyBorder(color: .clear, width: 0)
        self.passwordTextField.applyBorder(color: .clear, width: 0)
        self.joiningDateTextField.applyBorder(color: .clear, width: 0)
        if let textField = textField {
            textField.applyBorder(color: UIColor.themeColor,
                             width: 1)
        }
    }

    // Resign TextFields
    private func resignTextField() {
        fullnameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        mobileTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        joiningDateTextField.resignFirstResponder()
        self.activeBorderFor()
    }
}
