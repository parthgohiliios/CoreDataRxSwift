//
//  APIServiceProvider.swift
//  CoreDataRxSwift
//
//  Created by mind-0023 on 17/05/21.
//

import Foundation
import RxSwift
import Moya
import RxCocoa

private let provider = MoyaProvider<APIServiceRouter>()
final class ServiceProvider {
    private let disposeBag = DisposeBag()
    func login(_ router: APIServiceRouter) -> Observable<LoginResponseModel> {
        return Observable.create { observer in
            let _ = provider.rx.request(router)
                .asObservable()
                .subscribe { result in
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601WithFractionalSeconds
                    let output = try? decoder.decode(LoginResponseModel.self, from: result.data)
                    observer.onNext(output ?? LoginResponseModel())
                    observer.onCompleted()
                } onError: { (error) in
                    observer.onError(error)
                }
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }

    // De-init
    deinit {
        print("\(self) dealloc")
    }
}
