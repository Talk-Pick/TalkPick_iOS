//
//  UserUseCase.swift
//  TalkPick
//
//  Created by jaegu park on 11/8/25.
//

import RxSwift
import Foundation

class UserUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository = UserRepository.shared) {
        self.userRepository = userRepository
    }
    
    func postTerm(agreeTermIdList: [Int], disagreeTermIdList: [Int]) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        let params: [String: Any] = [
            "agreeTermIdList": agreeTermIdList,
            "disagreeTermIdList": disagreeTermIdList
        ]
        
        return userRepository.postTerm(token: token, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func kakaoLogin(idToken: String) -> Single<User> {
        let params: [String: Any] = [
            "idToken": idToken
        ]
        
        return userRepository.postKakaoLogin(idToken: idToken, parameters: params)
            .map { $0.data }
    }
    
    func appleLogin(idToken: String) -> Single<APIResponse<User>> {
        let params: [String: Any] = [
            "idToken": idToken
        ]
        
        return userRepository.postAppleLogin(idToken: idToken, parameters: params)
    }
    
    func signUp(nickname: String, mbti: String) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "nickname": nickname,
            "mbti": mbti
        ]
        
        return userRepository.signUp(token: token, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func getMyProfile() -> Single<Profile> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return userRepository.getMyProfile(token: token)
            .map { $0.data }
    }
    
    func editMyProfile(mbti: String) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "mbti": mbti
        ]
        
        return userRepository.editMyProfile(token: token, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func getLikedTopics(parameters: [String : Any]?) -> Single<[LikedTopic]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return userRepository.getLikedTopics(token: token, parameters: parameters)
                    .map { $0.data }
    }
    
    func logOut() -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return userRepository.logOut(token: token)
            .do(onSuccess: { _ in
                self.clearUserCredentials()
            })
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    private func clearUserCredentials() {
        KeychainHelper.standard.delete(service: "access-token", account: "user")
    }
}
