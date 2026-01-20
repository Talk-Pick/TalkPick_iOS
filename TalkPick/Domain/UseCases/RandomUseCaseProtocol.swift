
import RxSwift
import Foundation

protocol RandomUseCaseProtocol {
    func postRandomTotalRecord(id: Int, totalRecords: [TotalRecord]) -> Single<Bool>
    func postRandomRate(id: Int, rating: Int) -> Single<Bool>
    func postRandomQuit(id: Int) -> Single<Bool>
    func postRandomEnd(id: Int) -> Single<Bool>
    func postRandomComment(id: Int, oneLine: String) -> Single<Bool>
    func postRandomStart() -> Single<APIResponse<RandomId>>
    func getRandomTopics(id: Int, order: Int, category: String) -> Single<APIResponse<[RandomTopic]>>
}