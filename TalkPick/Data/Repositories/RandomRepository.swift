
import RxSwift

class RandomRepository: RandomRepositoryProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func postRandomTotalRecord(token: String, id: Int, parameters: [String: Any]?) -> Single<Response> {
        let url = APIConstants.randomTotalRecord(id).path
        return apiService.postWithTokenAndParams(of: Response.self, url: url, parameters: parameters, accessToken: token)
            .mapToAppError()
    }
    
    func postRandomRate(token: String, id: Int, rating: Int) -> Single<Response> {
        let url = APIConstants.randomRate(id).path
        let params = ["rating": rating]
        return apiService.postWithTokenAndParams(of: Response.self, url: url, parameters: params, accessToken: token)
            .mapToAppError()
    }
    
    func postRandomQuit(token: String, id: Int) -> Single<Response> {
        let url = APIConstants.randomQuit(id).path
        return apiService.postWithToken(of: Response.self, url: url, parameters: nil, accessToken: token)
            .mapToAppError()
    }
    
    func postRandomEnd(token: String, id: Int) -> Single<Response> {
        let url = APIConstants.randomEnd(id).path
        return apiService.postWithToken(of: Response.self, url: url, parameters: nil, accessToken: token)
            .mapToAppError()
    }
    
    func postRandomComment(token: String, id: Int, oneLine: String) -> Single<Response> {
        let url = APIConstants.randomComment(id).path
        let params = ["oneLine": oneLine]
        return apiService.postWithTokenAndParams(of: Response.self, url: url, parameters: params, accessToken: token)
            .mapToAppError()
    }
    
    func postRandomStart(token: String) -> Single<APIResponse<RandomId>> {
        let url = APIConstants.randomStart.path
        return apiService.postWithToken(of: APIResponse<RandomId>.self, url: url, parameters: nil, accessToken: token)
            .mapToAppError()
    }
    
    func getRandomTopics(token: String, id: Int, parameters: [String: Any]?) -> Single<APIResponse<[RandomTopic]>> {
        let url = APIConstants.randomTopics(id).path
        return apiService.getWithTokenAndParams(of: APIResponse<[RandomTopic]>.self, url: url, parameters: parameters, accessToken: token)
            .mapToAppError()
    }
}
