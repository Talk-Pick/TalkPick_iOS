//
//  RandomUseCase.swift
//  TalkPick
//
//  Created by jaegu park on 12/9/25.
//

import RxSwift
import Foundation

class RandomUseCase {
    private let randomRepository: RandomRepository
    
    init(randomRepository: RandomRepository = RandomRepository.shared) {
        self.randomRepository = randomRepository
    }
    
    func postRandomRate(id: Int, rating: Int) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return randomRepository.postRandomRate(token: token, id: id, rating: rating)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func postRandomComment(id: Int, oneLine: String) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return randomRepository.postRandomComment(token: token, id: id, oneLine: oneLine)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func postRandomStart() -> Single<APIResponse<RandomId>> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return randomRepository.postRandomStart(token: token)
    }
    
    func getRandomTopics(id: Int, order: Int, categoryGroup: String, category: String) -> Single<APIResponse<[RandomTopic]>> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        let params: [String: Any] = [
            "id": id,
            "order": order,
            "categoryGroup": categoryGroup,
            "category": category
        ]
        
        return randomRepository.getRandomTopics(token: token, id: id, parameters: params)
    }
}
