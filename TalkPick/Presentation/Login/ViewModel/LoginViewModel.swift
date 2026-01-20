
import RxSwift

class LoginViewModel: BaseViewModel {
    private let useCase: UserUseCaseProtocol
    private let tokenProvider: TokenProviderProtocol
    
    init(
        useCase: UserUseCaseProtocol = UserUseCase(),
        tokenProvider: TokenProviderProtocol = TokenProvider.shared
    ) {
        self.useCase = useCase
        self.tokenProvider = tokenProvider
    }
    
    let termAgreed = PublishSubject<Bool>()
    let signUp = PublishSubject<Bool>()
    
    func postTerm(agreeTermIdList: [Int], disagreeTermIdList: [Int]) {
        executeWithLoading {
            self.useCase.postTerm(agreeTermIdList: agreeTermIdList, disagreeTermIdList: disagreeTermIdList)
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] success in
            self?.termAgreed.onNext(success)
        }, onFailure: { [weak self] error in
            self?.handleError(error)
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
            .do(onSuccess: { [weak self] response in
                self?.tokenProvider.saveAccessToken(response.accessToken)
            })
            .map { _ in true }
            .catch { _ in
                .just(false)
            }
    }
    
    func signUp(nickname: String, mbti: String) {
        executeWithLoading {
            self.useCase.signUp(nickname: nickname, mbti: mbti)
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] success in
            self?.signUp.onNext(success)
        }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
}
