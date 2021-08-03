//
//  AddEmployeeViewModel.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 11/05/21.
//

import Foundation
import RxSwift
import RxCocoa

final class AddEmployeeViewModel {

    // MARK:- Variables -
    private let disposeBag = DisposeBag()

    var showFulnameErrorObservable: Observable<Bool> {
        showFullnameError.asObservable()
    }
    var showEmailErrorObservable: Observable<Bool> {
        showEmailError.asObservable()
    }
    var showMobileErrorObservable: Observable<Bool> {
        showMobileError.asObservable()
    }
    var showPasswordErrorObservable: Observable<Bool> {
        showPasswordError.asObservable()
    }
    var showJoiningDateErrorObservable: Observable<Bool> {
        showJoiningDateError.asObservable()
    }
    var enableAddEmployeeButtonObservable: Observable<Bool> {
        enableAddEmployeeButton.asObservable()
    }

    // MARK:- events -
    private let fullname: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let email: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let mobile: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let password: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let joiningDate: BehaviorRelay<String> = BehaviorRelay(value: "")

    // MARK:- state -
    private let showFullnameError = BehaviorRelay<Bool>(value: false)
    private let showEmailError = BehaviorRelay<Bool>(value: false)
    private let showMobileError = BehaviorRelay<Bool>(value: false)
    private let showPasswordError = BehaviorRelay<Bool>(value: false)
    private let showJoiningDateError = BehaviorRelay<Bool>(value: false)
    private let enableAddEmployeeButton = BehaviorRelay<Bool>(value: false)

    // MARK:- init -
    init() {
        bindState()
    }

    // MARK:- bindState -
    private func bindState() {

        Observable.combineLatest(fullname.asObservable(),
                                 email.asObservable(),
                                 mobile.asObservable(),
                                 password.asObservable(),
                                 joiningDate.asObservable())
            .map { (fullname, email, mobile, password, joiningDate) in
                return fullname.isValidFullName && email.isValidEmail && mobile.isValidMobile && password.isValidPassword && !joiningDate.isEmpty
            }
            .bind(to: enableAddEmployeeButton)
            .disposed(by: disposeBag)
        
        fullname.asObservable()
            .map {(fullname) in
                fullname.isEmpty || fullname.isValidFullName
            }
            .bind(to: showFullnameError)
            .disposed(by: disposeBag)

        email.asObservable()
            .map {(email) in
                email.isEmpty || email.isValidEmail
            }
            .bind(to: showEmailError)
            .disposed(by: disposeBag)
        
        mobile.asObservable()
            .map {(mobile) in
                mobile.isEmpty || mobile.isValidMobile
            }
            .bind(to: showMobileError)
            .disposed(by: disposeBag)

        password.asObservable()
            .map {(password) in
                password.isEmpty || password.isValidPassword
            }
            .bind(to: showPasswordError)
            .disposed(by: disposeBag)

        joiningDate.asObservable()
            .map {(joiningDate) in
                joiningDate.isEmpty || joiningDate.count > 5
            }
            .bind(to: showJoiningDateError)
            .disposed(by: disposeBag)
    }

    func onFullnameChanged(_ value: String?) {
        self.fullname.accept(value ?? "")
    }

    func onEmailChanged(_ value: String?) {
        self.email.accept(value ?? "")
    }

    func onMobileChanged(_ value: String?) {
        self.mobile.accept(value ?? "")
    }

    func onPasswordChanged(_ value: String?) {
        self.password.accept(value ?? "")
    }

    func onJoiningDateChanged(_ value: String?) {
        self.joiningDate.accept(value ?? "")
    }
}
