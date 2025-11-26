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
    
    func kakaoLogin(idToken: String) -> Single<Bool> {
        return useCase.kakaoLogin(idToken: idToken)
            .do(onSuccess: { data in
                KeychainHelper.standard.save(data.accessToken, service: "access-token", account: "user")
                print("토큰 \(data.accessToken)")
            })
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func appleLogin(idToken: String) -> Single<APIResponse<User>> {
        return useCase.appleLogin(idToken: idToken)
            .do(onSuccess: { response in
                KeychainHelper.standard.save(response.data.accessToken, service: "access-token", account: "user")
            })
    }
}
