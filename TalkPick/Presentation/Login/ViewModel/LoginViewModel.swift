//
//  LoginViewModel.swift
//  TalkPick
//
//  Created by jaegu park on 11/8/25.
//

import RxSwift
import RxCocoa

class LoginViewModel {
    private let disposeBag = DisposeBag()
    private let useCase: UserUseCase
    
    init(useCase: UserUseCase = UserUseCase()) {
        self.useCase = useCase
    }
    
    let termAgreed = PublishSubject<Bool>()
    let signUp = PublishSubject<Bool>()
    
    func postTerm(agreeTermIdList: [Int], disagreeTermIdList: [Int]) {
        useCase.postTerm(agreeTermIdList: agreeTermIdList, disagreeTermIdList: disagreeTermIdList)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] success in
                self?.termAgreed.onNext(success)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func kakaoLogin(idToken: String) -> Single<Bool> {
        return useCase.kakaoLogin(idToken: idToken)
            .do(onSuccess: { response in
                KeychainHelper.standard.save(response.accessToken, service: "access-token", account: "user")
                print("토큰 \(response.accessToken)")
            })
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func appleLogin(idToken: String) -> Single<Bool> {
        return useCase.appleLogin(idToken: idToken)
            .do(onSuccess: { response in
                KeychainHelper.standard.save(response.data.accessToken, service: "access-token", account: "user")
            })
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func signUp(nickname: String, mbti: String) {
        useCase.signUp(nickname: nickname, mbti: mbti)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] success in
                self?.signUp.onNext(success)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
