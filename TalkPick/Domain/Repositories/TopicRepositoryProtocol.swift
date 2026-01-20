
import RxSwift
import Foundation

protocol TopicRepositoryProtocol {
    func postTopickLike(token: String, topicId: Int) -> Single<Response>
    func getTopicDetail(token: String, topicId: Int) -> Single<APIResponse<TopicDetail>>
    func getTodayTopic(token: String) -> Single<APIResponse<[Topic]>>
    func getCategories(token: String) -> Single<APIResponse<[Category]>>
}