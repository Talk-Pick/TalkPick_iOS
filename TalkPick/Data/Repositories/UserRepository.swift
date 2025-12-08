//
//  UserRepository.swift
//  TalkPick
//
//  Created by jaegu park on 11/8/25.
//

import RxSwift

class UserRepository {
    static let shared = UserRepository()
    
    func postTerm(token: String, parameters: [String: Any]?) -> Single<Term> {
        let url = APIConstants.term.path
        return APIService.shared.postWithToken(of: Term.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func postKakaoLogin(idToken: String, parameters: [String: Any]?) -> Single<APIResponse<User>> {
        let url = APIConstants.kakaoLogin.path
        return APIService.shared.post(of: APIResponse<User>.self, url: url, parameters: parameters)
    }
    
    func postAppleLogin(idToken: String, parameters: [String: Any]?) -> Single<APIResponse<User>> {
        let url = APIConstants.appleLogin.path
        return APIService.shared.patch(of: APIResponse<User>.self, url: url, parameters: parameters)
    }
    
    func signUp(token: String, parameters: [String: Any]?) -> Single<SignUp> {
        let url = APIConstants.signUp.path
        return APIService.shared.patchWithToken(of: SignUp.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func getMyProfile(token: String) -> Single<APIResponse<Profile>> {
        let url = APIConstants.myProfile.path
        return APIService.shared.getWithToken(of: APIResponse<Profile>.self, url: url, accessToken: token)
    }
    
    func editMyProfile(token: String, parameters: [String: Any]?) -> Single<APIResponse<Profile>> {
        let url = APIConstants.myProfile.path
        return APIService.shared.patchWithToken(of: APIResponse<Profile>.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func getLikedTopics(token: String, parameters: [String: Any]?) -> Single<APIResponse<LikedTopic>> {
        let url = APIConstants.likedTopics.path
        return APIService.shared.getWithTokenAndParams(of: APIResponse<LikedTopic>.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func logOut(token: String) -> Single<Response> {
        let url = APIConstants.logOut.path
        return APIService.shared.deleteWithToken(of: Response.self, url: url, parameters: nil, accessToken: token)
    }
}
