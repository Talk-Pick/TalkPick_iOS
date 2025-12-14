
import RxSwift
import RxCocoa

class MyPageViewModel {
    
    private let disposeBag = DisposeBag()
    private let useCase: UserUseCase
    
    init(useCase: UserUseCase = UserUseCase()) {
        self.useCase = useCase
    }
    
    let profile = PublishSubject<Profile>()
    let logout = PublishSubject<Bool>()
    let likeTopicList = BehaviorRelay<[LikedDetail]>(value: [])
    
    func getMyProfile() {
        useCase.getMyProfile()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] profile in
                self?.profile.onNext(profile)
            }, onFailure: { error in
                AlertController(message: "프로필 불러오기에 실패했습니다.\n다시 시도해주세요.").show()
            })
            .disposed(by: disposeBag)
    }

    func editMyProfile(mbti: String) {
        useCase.editMyProfile(mbti: mbti)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] success in
                self?.getMyProfile()
            }, onFailure: { error in
                AlertController(message: "프로필 수정에 실패했습니다.\n다시 시도해주세요.").show()
            })
            .disposed(by: disposeBag)
    }
    
    func logOut() {
        useCase.logOut()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] success in
                self?.logout.onNext(success)
            }, onFailure: { error in
                AlertController(message: "로그아웃에 실패했습니다.\n다시 시도해주세요.").show()
            })
            .disposed(by: disposeBag)
    }
    
    func getLikedTopics(cursor: String?, size: String) {
        useCase.getLikedTopics(cursor: cursor, size: size)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] topics in
                print("getLikedTopics message:", topics.message)
                self?.likeTopicList.accept(topics.data.items)
            }, onFailure: { error in
                AlertController(message: "좋아요한 토픽 불러오기에 실패했습니다.\n다시 시도해주세요.").show()
            })
            .disposed(by: disposeBag)
    }
}
