
import RxSwift
import RxCocoa

class MyPageViewModel {
    
    private let disposeBag = DisposeBag()
    private let useCase: UserUseCase
    
    init(useCase: UserUseCase = UserUseCase()) {
        self.useCase = useCase
    }
    
    let profile = PublishSubject<Profile>()
    let delete = PublishSubject<Bool>()
    let logout = PublishSubject<Bool>()
    let likeTopicList = BehaviorRelay<[LikedDetail]>(value: [])
    
    func getMyProfile() {
        useCase.getMyProfile()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] profile in
                self?.profile.onNext(profile)
            }, onFailure: { error in
                AlertController(message: ErrorMessage.profileLoadFailed).show()
            })
            .disposed(by: disposeBag)
    }

    func editMyProfile(mbti: String) {
        useCase.editMyProfile(mbti: mbti)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] success in
                self?.getMyProfile()
            }, onFailure: { error in
                AlertController(message: ErrorMessage.profileEditFailed).show()
            })
            .disposed(by: disposeBag)
    }
    
    func deleteAccount() {
        useCase.deleteAccount()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] success in
                self?.delete.onNext(success)
            }, onFailure: { error in
                AlertController(message: ErrorMessage.accountDeleteFailed).show()
            })
            .disposed(by: disposeBag)
    }
    
    func logOut() {
        useCase.logOut()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] success in
                self?.logout.onNext(success)
            }, onFailure: { error in
                AlertController(message: ErrorMessage.logoutFailed).show()
            })
            .disposed(by: disposeBag)
    }
    
    func getLikedTopics(cursor: String?, size: String) {
        useCase.getLikedTopics(cursor: cursor, size: size)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] topics in
                self?.likeTopicList.accept(topics.data.items)
            }, onFailure: { error in
                AlertController(message: ErrorMessage.likedTopicLoadFailed).show()
            })
            .disposed(by: disposeBag)
    }
}
