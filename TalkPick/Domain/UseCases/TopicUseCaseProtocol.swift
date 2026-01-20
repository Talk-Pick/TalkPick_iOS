
import RxSwift
import Foundation

protocol TopicUseCaseProtocol {
    func postTopicLike(topicId: Int) -> Single<Bool>
    func getTopicDetail(topicId: Int) -> Single<TopicDetail>
    func getTodayTopic() -> Single<[Topic]>
    func getCategories() -> Single<[Category]>
}