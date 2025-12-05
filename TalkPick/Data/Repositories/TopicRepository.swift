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
    
    func getTopicDetail(token: String, topicId: Int) -> Single<APIResponse<TopicDetail>> {
        let url = APIConstants.topicDetail(topicId).path
        let params = ["topicId": topicId]
        return APIService.shared.getWithTokenAndParams(of: APIResponse<TopicDetail>.self, url: url, parameters: params, accessToken: token)
    }
}
