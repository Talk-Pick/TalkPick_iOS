
import RxSwift

class UserRepository: UserRepositoryProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func postTerm(token: String, parameters: [String: Any]?) -> Single<Term> {
        let url = APIConstants.term.path
        return apiService.postWithToken(of: Term.self, url: url, parameters: parameters, accessToken: token)
            .mapToAppError()
    }
    
    func postKakaoLogin(idToken: String, parameters: [String: Any]?) -> Single<APIResponse<Token>> {
        let url = APIConstants.kakaoLogin.path
        return apiService.post(of: APIResponse<Token>.self, url: url, parameters: parameters)
            .mapToAppError()
    }
    
    func postAppleLogin(idToken: String, parameters: [String: Any]?) -> Single<APIResponse<Token>> {
        let url = APIConstants.appleLogin.path
        return apiService.post(of: APIResponse<Token>.self, url: url, parameters: parameters)
            .mapToAppError()
    }
    
    func postGoogleLogin(idToken: String, parameters: [String: Any]?) -> Single<APIResponse<Token>> {
        let url = APIConstants.googleLogin.path
        return apiService.post(of: APIResponse<Token>.self, url: url, parameters: parameters)
            .mapToAppError()
    }
    
    func signUp(token: String, parameters: [String: Any]?) -> Single<SignUp> {
        let url = APIConstants.signUp.path
        return apiService.patchWithToken(of: SignUp.self, url: url, parameters: parameters, accessToken: token)
            .mapToAppError()
    }
    
    func getMyProfile(token: String) -> Single<APIResponse<Profile>> {
        let url = APIConstants.myProfile.path
        return apiService.getWithToken(of: APIResponse<Profile>.self, url: url, accessToken: token)
            .mapToAppError()
    }
    
    func editMyProfile(token: String, parameters: [String: Any]?) -> Single<APIResponse<Profile>> {
        let url = APIConstants.myProfile.path
        return apiService.patchWithToken(of: APIResponse<Profile>.self, url: url, parameters: parameters, accessToken: token)
            .mapToAppError()
    }
    
    func getLikedTopics(token: String, parameters: [String: Any]?) -> Single<APIResponse<LikedTopic>> {
        let url = APIConstants.likedTopics.path
        return apiService.getWithTokenAndParams(of: APIResponse<LikedTopic>.self, url: url, parameters: parameters, accessToken: token)
            .mapToAppError()
    }
    
    func deleteAccount(token: String) -> Single<Response> {
        let url = APIConstants.delete.path
        return apiService.patchWithToken(of: Response.self, url: url, parameters: nil, accessToken: token)
            .mapToAppError()
    }
    
    func logOut(token: String) -> Single<Response> {
        let url = APIConstants.logOut.path
        return apiService.deleteWithToken(of: Response.self, url: url, parameters: nil, accessToken: token)
            .mapToAppError()
    }
}
