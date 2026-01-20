
import RxSwift
import Foundation

protocol UserRepositoryProtocol {
    func postTerm(token: String, parameters: [String: Any]?) -> Single<Term>
    func postKakaoLogin(idToken: String, parameters: [String: Any]?) -> Single<APIResponse<Token>>
    func postAppleLogin(idToken: String, parameters: [String: Any]?) -> Single<APIResponse<Token>>
    func postGoogleLogin(idToken: String, parameters: [String: Any]?) -> Single<APIResponse<Token>>
    func signUp(token: String, parameters: [String: Any]?) -> Single<SignUp>
    func getMyProfile(token: String) -> Single<APIResponse<Profile>>
    func editMyProfile(token: String, parameters: [String: Any]?) -> Single<APIResponse<Profile>>
    func getLikedTopics(token: String, parameters: [String: Any]?) -> Single<APIResponse<LikedTopic>>
    func deleteAccount(token: String) -> Single<Response>
    func logOut(token: String) -> Single<Response>
}