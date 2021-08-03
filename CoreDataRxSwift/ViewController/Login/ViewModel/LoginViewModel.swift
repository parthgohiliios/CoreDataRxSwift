//
//  LoginViewModel.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 17/05/21.
//

import RxCocoa
import RxSwift
import Foundation

final class LoginViewModel {

    // MARK:- Variables -
    private let disposeBag = DisposeBag()
    private let service = ServiceProvider()
    
    var showEmailErrorObservable: Observable<Bool> {
        showEmailError.asObservable()
    }
    var showPasswordErrorObservable: Observable<Bool> {
        showPasswordError.asObservable()
    }
    var enableLoginButtonObservable: Observable<Bool> {
        enableLoginButton.asObservable()
    }
    var showLoginErrorObservable: Observable<String?> {
        showLoginError.asObservable()
    }

    var showEmployeeListScreenObservable: Observable<Bool> {
        showEmployeeListScreen.asObservable()
    }
    var showLoaderObservable: Observable<Bool> {
        showLoader.asObservable()
    }

    // MARK:- events -
    private let email: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let password: BehaviorRelay<String> = BehaviorRelay(value: "")

    // MARK:- state -
    private let showEmailError = BehaviorRelay<Bool>(value: false)
    private let showPasswordError = BehaviorRelay<Bool>(value: false)
    private let enableLoginButton = BehaviorRelay<Bool>(value: false)
    private let showLoader = BehaviorRelay<Bool>(value: false)
    private let showLoginError = BehaviorRelay<String?>(value: nil)
    private let showEmployeeListScreen = BehaviorRelay<Bool>(value: false)

    // MARK:- init -
    init() {
        bindWithObservableAmdState()
    }

    // MARK:- bindState -
    private func bindWithObservableAmdState() {

        Observable.combineLatest(email.asObservable(), password.asObservable())
            .map { (email, password) in
                email.isValidEmail && password.isValidPassword
            }
            .bind(to: enableLoginButton)
            .disposed(by: disposeBag)

        email.asObservable()
            .map {(email) in
                email.isEmpty || email.isValidEmail
            }
            .bind(to: showEmailError)
            .disposed(by: disposeBag)

        password.asObservable()
            .map {(password) in
                password.isEmpty || password.isValidPassword
            }
            .bind(to: showPasswordError)
            .disposed(by: disposeBag)

    }

    func onEmailChanged(_ value: String?) {
        self.email.accept(value ?? "")
    }

    func onPasswordChanged(_ value: String?) {
        self.password.accept(value ?? "")
    }
    
    func loginButttonTapped() {
        executeLoginRequest()
    }
    
    // MARK:- Login Api -
    private func executeLoginRequest() {

        showLoader.accept(true)
        let loginRequestModel = LoginModel(email: email.value, password: password.value)
        service.login(.login(loginRequestModel))
            .asDriver(onErrorJustReturn: LoginResponseModel())
            .drive { [weak self] (response)  in
                guard let self = self else { return }
                response.subscribe { [weak self] (result) in
                    guard let self = self else { return }
                    self.showLoader.accept(false)
                    if result.result == 0 {
                        self.showLoginError.accept(result.errorMessage)
                    } else {
                        self.showEmployeeListScreen.accept(true)
                        UserDefaults.standard.user = result.data.user
                    }
                } onError: { [weak self] (error) in
                    guard let self = self else { return }
                    self.showLoader.accept(false)
                    self.showLoginError.accept(error.localizedDescription)
                }.disposed(by: self.disposeBag)
            }
    }
}
