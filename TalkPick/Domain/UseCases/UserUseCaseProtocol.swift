
import RxSwift
import Foundation

protocol UserUseCaseProtocol {
    func postTerm(agreeTermIdList: [Int], disagreeTermIdList: [Int]) -> Single<Bool>
    func kakaoLogin(idToken: String) -> Single<Token>
    func appleLogin(idToken: String) -> Single<Token>
    func googleLogin(idToken: String) -> Single<Token>
    func signUp(nickname: String, mbti: String) -> Single<Bool>
    func getMyProfile() -> Single<Profile>
    func editMyProfile(mbti: String) -> Single<Bool>
    func getLikedTopics(cursor: String?, size: String) -> Single<APIResponse<LikedTopic>>
    func deleteAccount() -> Single<Bool>
    func logOut() -> Single<Bool>
}