
import RxSwift
import Foundation

protocol RandomRepositoryProtocol {
    func postRandomTotalRecord(token: String, id: Int, parameters: [String: Any]?) -> Single<Response>
    func postRandomRate(token: String, id: Int, rating: Int) -> Single<Response>
    func postRandomQuit(token: String, id: Int) -> Single<Response>
    func postRandomEnd(token: String, id: Int) -> Single<Response>
    func postRandomComment(token: String, id: Int, oneLine: String) -> Single<Response>
    func postRandomStart(token: String) -> Single<APIResponse<RandomId>>
    func getRandomTopics(token: String, id: Int, parameters: [String: Any]?) -> Single<APIResponse<[RandomTopic]>>
}