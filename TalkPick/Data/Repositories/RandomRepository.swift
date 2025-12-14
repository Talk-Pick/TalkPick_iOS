
import RxSwift

class RandomRepository {
    static let shared = RandomRepository()
    
    func postRandomTotalRecord(token: String, id: Int, parameters: [String: Any]?) -> Single<Response> {
        let url = APIConstants.randomTotalRecord(id).path
        return APIService.shared.postWithTokenAndParams(of: Response.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func postRandomRate(token: String, id: Int, rating: Int) -> Single<Response> {
        let url = APIConstants.randomRate(id).path
        let param = ["rating": rating]
        return APIService.shared.postWithTokenAndParams(of: Response.self, url: url, parameters: param, accessToken: token)
    }
    
    func postRandomQuit(token: String, id: Int) -> Single<Response> {
        let url = APIConstants.randomQuit(id).path
        return APIService.shared.postWithToken(of: Response.self, url: url, parameters: nil, accessToken: token)
    }
    
    func postRandomEnd(token: String, id: Int) -> Single<Response> {
        let url = APIConstants.randomEnd(id).path
        return APIService.shared.postWithToken(of: Response.self, url: url, parameters: nil, accessToken: token)
    }
    
    func postRandomComment(token: String, id: Int, oneLine: String) -> Single<Response> {
        let url = APIConstants.randomComment(id).path
        let param = ["oneLine": oneLine]
        return APIService.shared.postWithTokenAndParams(of: Response.self, url: url, parameters: param, accessToken: token)
    }
    
    func postRandomStart(token: String) -> Single<APIResponse<RandomId>> {
        let url = APIConstants.randomStart.path
        return APIService.shared.postWithToken(of: APIResponse<RandomId>.self, url: url, parameters: nil, accessToken: token)
    }
    
    func getRandomTopics(token: String, id: Int, parameters: [String: Any]?) -> Single<APIResponse<[RandomTopic]>> {
        let url = APIConstants.randomTopics(id).path
        return APIService.shared.getWithTokenAndParams(of: APIResponse<[RandomTopic]>.self, url: url, parameters: parameters, accessToken: token)
    }
}
