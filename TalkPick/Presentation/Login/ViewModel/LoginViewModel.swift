
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
                AlertController(message: "약관 동의에 실패했습니다.\n다시 시도해주세요.").show()
            })
            .disposed(by: disposeBag)
    }
    
    func kakaoLogin(idToken: String) -> Single<Bool> {
        return performLogin(useCase.kakaoLogin(idToken: idToken))
    }
    
    func appleLogin(idToken: String) -> Single<Bool> {
        return performLogin(useCase.appleLogin(idToken: idToken))
    }
    
    func googleLogin(idToken: String) -> Single<Bool> {
        return performLogin(useCase.googleLogin(idToken: idToken))
    }
    
    private func performLogin(_ loginSingle: Single<Token>) -> Single<Bool> {
        return loginSingle
            .do(onSuccess: { response in
                AccessTokenManager.shared.saveToken(response.accessToken)
            })
            .map { _ in true }
            .catch { _ in
                .just(false)
            }
    }
    
    func signUp(nickname: String, mbti: String) {
        useCase.signUp(nickname: nickname, mbti: mbti)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] success in
                self?.signUp.onNext(success)
            }, onFailure: { error in
                AlertController(message: "회원가입에 실패했습니다.\n다시 시도해주세요.").show()
            })
            .disposed(by: disposeBag)
    }
}
