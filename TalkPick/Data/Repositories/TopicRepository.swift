
import RxSwift

class TopicRepository: TopicRepositoryProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func postTopickLike(token: String, topicId: Int) -> Single<Response> {
        let url = APIConstants.topicLike(topicId).path
        return apiService.postWithToken(of: Response.self, url: url, parameters: nil, accessToken: token)
            .mapToAppError()
    }
    
    func getTopicDetail(token: String, topicId: Int) -> Single<APIResponse<TopicDetail>> {
        let url = APIConstants.topicDetail(topicId).path
        return apiService.getWithToken(of: APIResponse<TopicDetail>.self, url: url, accessToken: token)
            .mapToAppError()
    }
    
    func getTodayTopic(token: String) -> Single<APIResponse<[Topic]>> {
        let url = APIConstants.topicToday.path
        return apiService.getWithToken(of: APIResponse<[Topic]>.self, url: url, accessToken: token)
            .mapToAppError()
    }
    
    func getCategories(token: String) -> Single<APIResponse<[Category]>> {
        let url = APIConstants.topicCategory.path
        return apiService.getWithToken(of: APIResponse<[Category]>.self, url: url, accessToken: token)
            .mapToAppError()
    }
}
