
import RxSwift
import Foundation

class TopicUseCase {
    private let topicRepository: TopicRepository
    
    init(topicRepository: TopicRepository = TopicRepository.shared) {
        self.topicRepository = topicRepository
    }
    
    func getTodayTopic() -> Single<[Topic]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return topicRepository.getTodayTopic(token: token)
            .map { $0.data }
    }
    
    func getTopicDetail(topicId: Int) -> Single<TopicDetail> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return topicRepository.getTopicDetail(token: token, topicId: topicId)
            .map { $0.data }
    }
    
    func postTopicLike(topicId: Int) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return topicRepository.postTopickLike(token: token, topicId: topicId)
            .map { _ in true }
            .catchAndReturn(false)
    }
}
