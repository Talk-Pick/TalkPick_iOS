
import RxSwift
import RxCocoa

class MyPageViewModel: BaseViewModel {
    
    private let useCase: UserUseCaseProtocol
    
    init(useCase: UserUseCaseProtocol = UserUseCase()) {
        self.useCase = useCase
    }
    
    let profile = PublishSubject<Profile>()
    let delete = PublishSubject<Bool>()
    let logout = PublishSubject<Bool>()
    let likeTopicList = BehaviorRelay<[LikedDetail]>(value: [])
    
    func getMyProfile() {
        executeWithLoading {
            self.useCase.getMyProfile()
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] profile in
            self?.profile.onNext(profile)
        }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }

    func editMyProfile(mbti: String) {
        executeWithLoading {
            self.useCase.editMyProfile(mbti: mbti)
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] _ in
            self?.getMyProfile()
        }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
    
    func deleteAccount() {
        executeWithLoading {
            self.useCase.deleteAccount()
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] success in
            self?.delete.onNext(success)
        }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
    
    func logOut() {
        executeWithLoading {
            self.useCase.logOut()
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] success in
            self?.logout.onNext(success)
        }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
    
    func getLikedTopics(cursor: String?, size: String) {
        executeWithLoading {
            self.useCase.getLikedTopics(cursor: cursor, size: size)
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] topics in
            self?.likeTopicList.accept(topics.data.items)
        }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
}
