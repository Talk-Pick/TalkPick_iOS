
import RxSwift

class TopicUseCase: BaseUseCase, TopicUseCaseProtocol {
    private let topicRepository: TopicRepositoryProtocol
    
    init(
        topicRepository: TopicRepositoryProtocol = TopicRepository(),
        tokenProvider: TokenProviderProtocol = TokenProvider.shared
    ) {
        self.topicRepository = topicRepository
        super.init(tokenProvider: tokenProvider)
    }
    
    func postTopicLike(topicId: Int) -> Single<Bool> {
        return executeWithToken { token in
            self.topicRepository.postTopickLike(token: token, topicId: topicId)
                .map { _ in true }
        }
        .catchAndReturn(false)
    }
    
    func getTopicDetail(topicId: Int) -> Single<TopicDetail> {
        return executeWithToken { token in
            self.topicRepository.getTopicDetail(token: token, topicId: topicId)
                .map { $0.data }
        }
    }
    
    func getTodayTopic() -> Single<[Topic]> {
        return executeWithToken { token in
            self.topicRepository.getTodayTopic(token: token)
                .map { $0.data }
        }
    }
    
    func getCategories() -> Single<[Category]> {
        return executeWithToken { token in
            self.topicRepository.getCategories(token: token)
                .map { $0.data }
        }
    }
}
