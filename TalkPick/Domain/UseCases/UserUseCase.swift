
import RxSwift

class UserUseCase: BaseUseCase, UserUseCaseProtocol {
    private let userRepository: UserRepositoryProtocol
    
    init(
        userRepository: UserRepositoryProtocol = UserRepository(),
        tokenProvider: TokenProviderProtocol = TokenProvider.shared
    ) {
        self.userRepository = userRepository
        super.init(tokenProvider: tokenProvider)
    }
    
    func postTerm(agreeTermIdList: [Int], disagreeTermIdList: [Int]) -> Single<Bool> {
        let params: [String: Any] = [
            "agreeTermIdList": agreeTermIdList,
            "disagreeTermIdList": disagreeTermIdList
        ]
        
        return executeWithToken { token in
            self.userRepository.postTerm(token: token, parameters: params)
                .map { _ in true }
        }
        .catchAndReturn(false)
    }
    
    func kakaoLogin(idToken: String) -> Single<Token> {
        return performLogin(idToken: idToken, loginMethod: userRepository.postKakaoLogin)
    }
    
    func appleLogin(idToken: String) -> Single<Token> {
        return performLogin(idToken: idToken, loginMethod: userRepository.postAppleLogin)
    }
    
    func googleLogin(idToken: String) -> Single<Token> {
        return performLogin(idToken: idToken, loginMethod: userRepository.postGoogleLogin)
    }
    
    private func performLogin(idToken: String, loginMethod: (String, [String: Any]?) -> Single<APIResponse<Token>>) -> Single<Token> {
        return loginMethod(idToken, ["idToken": idToken]).map { $0.data }
    }
    
    func signUp(nickname: String, mbti: String) -> Single<Bool> {
        let params: [String: Any] = [
            "nickname": nickname,
            "mbti": mbti
        ]
        
        return executeWithTokenOrDefault(
            { token in
                self.userRepository.signUp(token: token, parameters: params)
                    .map { _ in true }
            },
            defaultValue: false
        )
        .catchAndReturn(false)
    }
    
    func getMyProfile() -> Single<Profile> {
        return executeWithToken { token in
            self.userRepository.getMyProfile(token: token)
                .map { $0.data }
        }
    }
    
    func editMyProfile(mbti: String) -> Single<Bool> {
        let params: [String: Any] = ["mbti": mbti]
        
        return executeWithTokenOrDefault(
            { token in
                self.userRepository.editMyProfile(token: token, parameters: params)
                    .map { _ in true }
            },
            defaultValue: false
        )
        .catchAndReturn(false)
    }
    
    func getLikedTopics(cursor: String?, size: String) -> Single<APIResponse<LikedTopic>> {
        var params: [String: Any] = ["size": size]
        
        if let cursor = cursor {
            params["cursor"] = cursor
        }
        
        return executeWithToken { token in
            self.userRepository.getLikedTopics(token: token, parameters: params)
        }
    }
    
    func deleteAccount() -> Single<Bool> {
        return executeWithTokenOrDefault(
            { token in
                self.userRepository.deleteAccount(token: token)
                    .map { _ in true }
            },
            defaultValue: false
        )
        .catchAndReturn(false)
    }
    
    func logOut() -> Single<Bool> {
        return executeWithToken { token in
            self.userRepository.logOut(token: token)
                .do(onSuccess: { _ in
                    self.tokenProvider.clearAccessToken()
                })
                .map { _ in true }
        }
        .catchAndReturn(false)
    }
}
