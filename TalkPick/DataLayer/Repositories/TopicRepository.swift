//
//  TopicRepository.swift
//  TalkPick
//
//  Created by jaegu park on 11/10/25.
//

import RxSwift

class TopicRepository {
    static let shared = TopicRepository()
    
    func getTodayTopic(token: String) -> Single<APIResponse<[Topic]>> {
        let url = APIConstants.topicToday.path
        return APIService.shared.getWithToken(of: APIResponse<[Topic]>.self, url: url, accessToken: token)
    }
}
