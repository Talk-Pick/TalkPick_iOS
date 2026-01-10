
import RxSwift

class TopicRepository {
    static let shared = TopicRepository()
    
    func postTopickLike(token: String, topicId: Int) -> Single<Response> {
        let url = APIConstants.topicLike(topicId).path
        let params = ["topicId": topicId]
        return APIService.shared.postWithToken(of: Response.self, url: url, parameters: params, accessToken: token)
    }
    
    func getTopicDetail(token: String, topicId: Int) -> Single<APIResponse<TopicDetail>> {
        let url = APIConstants.topicDetail(topicId).path
        let params = ["topicId": topicId]
        return APIService.shared.getWithTokenAndParams(of: APIResponse<TopicDetail>.self, url: url, parameters: params, accessToken: token)
    }
    
    func getTodayTopic(token: String) -> Single<APIResponse<[Topic]>> {
        let url = APIConstants.topicToday.path
        return APIService.shared.getWithToken(of: APIResponse<[Topic]>.self, url: url, accessToken: token)
    }
    
    func getCategories(token: String) -> Single<APIResponse<[Category]>> {
        let url = APIConstants.topicCategory.path
        return APIService.shared.getWithToken(of: APIResponse<[Category]>.self, url: url, accessToken: token)
    }
}
