//
//  LoginViewController.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 17/05/21.
//

import RxCocoa
import RxSwift
import UIKit

class LoginViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailErrorLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    //MARK:- Variables -
    static func instantiate() -> LoginViewController? {
        return UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
    }
    lazy var passwordShowButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        button.setImage(#imageLiteral(resourceName: "ic_show_password.png"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "ic_hide_password"), for: .selected)
        return button
    }()
    private var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
    }
}

// MARK:- General Methods -
extension LoginViewController {
    fileprivate func initialization() {
        self.viewModel = LoginViewModel()
        setupUI()
        bindErrorMessageWithLabel()
        bindTextFields()
        bindButtons()
        bindViewModel()
        activeBorderFor()
    }

    private func setupUI() {
        self.view.layoutIfNeeded()
        self.title = Title.login

        loginButton.backgroundColor = UIColor.themeColor
        loginButton.applyCircle()

        emailTextField.setupLeftImage(.email)
        passwordTextField.setupLeftImage(.password)
        passwordTextField.setupRightView(passwordShowButton)

        emailTextField.applyCircle()
        passwordTextField.applyCircle()
    }
    
    private func bindErrorMessageWithLabel() {
        emailErrorLabel.text = ErrorMessage.email
        passwordErrorLabel.text = ErrorMessage.password
    }

    func bindButtons() {
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] (emp) in
                self?.resignTextField()
                self?.viewModel.loginButttonTapped()
            })
            .disposed(by: self.disposeBag)

        passwordShowButton.rx.tap
            .subscribe(onNext: { _ in
                self.passwordTextField.isSecureTextEntry = self.passwordShowButton.isSelected
                self.passwordShowButton.isSelected.toggle()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindTextFields() {
        emailTextField.rx.text
            .asObservable()
            .subscribe(onNext: { [weak self] (text) in
                self?.viewModel.onEmailChanged(text)
                self?.activeBorderFor(self?.emailTextField)
            })
            .disposed(by: disposeBag)

        passwordTextField.rx.text
            .asObservable()
            .subscribe(onNext: { [weak self] (text) in
                self?.viewModel.onPasswordChanged(text)
                self?.activeBorderFor(self?.passwordTextField)
            })
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {

        viewModel.showEmailErrorObservable
            .takeUntil(rx.deallocating)
            .bind(to: emailErrorLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.showPasswordErrorObservable
            .takeUntil(rx.deallocating)
            .bind(to: passwordErrorLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.enableLoginButtonObservable
            .takeUntil(rx.deallocating)
            .subscribe(onNext: { [weak self] (enable) in
                self?.loginButton.isEnabled = enable
                self?.loginButton.alpha = enable ? 1: 0.2
            })
            .disposed(by: disposeBag)

        viewModel.showLoaderObservable
            .takeUntil(rx.deallocating)
            .subscribe(onNext: { [weak self] (loading) in
                guard let self = self else { return }
                loading ?
                    self.activityIndicator.startAnimating() :
                    self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = !loading
            })
            .disposed(by: disposeBag)

        viewModel.showEmployeeListScreenObservable
            .takeUntil(rx.deallocating)
            .subscribe(onNext: { [weak self] (isShowEmployeeList) in
                if isShowEmployeeList {
                    self?.view.isUserInteractionEnabled = true
                    self?.redirectToEmployeeList()
                }
            })
            .disposed(by: disposeBag)

        viewModel.showLoginErrorObservable
            .filter { (!($0 ?? "").isEmpty) }
            .takeUntil(rx.deallocating)
            .subscribe(onNext: { [weak self] (error) in
                guard let self = self else { return }
                UIAlertController
                    .present(in: self, title: AlertConstant.Error, message: error)
                    .subscribe(onNext: { buttonIndex in
                    }).disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }

    private func redirectToEmployeeList() {
        UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.isLogin)
    }

    private func resignTextField() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        self.activeBorderFor()
    }

    // Set Active border
    func activeBorderFor(_ textField: UITextField? = nil) {
        self.emailTextField.applyBorder(color: .clear, width: 0)
        self.passwordTextField.applyBorder(color: .clear, width: 0)
        if let textField = textField {
            textField.applyBorder(color: UIColor.themeColor,
                             width: 1)
        }
    }
}
