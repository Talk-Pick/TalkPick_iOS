//
//  MyPageViewModel.swift
//  TalkPick
//
//  Created by jaegu park on 11/14/25.
//

import RxSwift
import RxCocoa

class MyPageViewModel {
    
    private let disposeBag = DisposeBag()
    private let useCase: UserUseCase
    
    let profile = PublishSubject<Profile>()
    let logout = PublishSubject<Bool>()
    
    init(useCase: UserUseCase = UserUseCase()) {
        self.useCase = useCase
    }
    
    func loadMyProfile() {
        useCase.getMyProfile()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] profile in
                self?.profile.onNext(profile)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadLogOut() {
        useCase.logOut()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] success in
                self?.logout.onNext(success)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
