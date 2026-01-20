
import RxSwift

class RandomUseCase: BaseUseCase, RandomUseCaseProtocol {
    private let randomRepository: RandomRepositoryProtocol
    
    init(
        randomRepository: RandomRepositoryProtocol = RandomRepository(),
        tokenProvider: TokenProviderProtocol = TokenProvider.shared
    ) {
        self.randomRepository = randomRepository
        super.init(tokenProvider: tokenProvider)
    }
    
    func postRandomTotalRecord(id: Int, totalRecords: [TotalRecord]) -> Single<Bool> {
        let params = ["totalRecords": totalRecords]
        
        return executeWithToken { token in
            self.randomRepository.postRandomTotalRecord(token: token, id: id, parameters: params)
                .map { _ in true }
        }
        .catchAndReturn(false)
    }
    
    func postRandomRate(id: Int, rating: Int) -> Single<Bool> {
        return executeWithToken { token in
            self.randomRepository.postRandomRate(token: token, id: id, rating: rating)
                .map { _ in true }
        }
        .catchAndReturn(false)
    }
    
    func postRandomQuit(id: Int) -> Single<Bool> {
        return executeWithToken { token in
            self.randomRepository.postRandomQuit(token: token, id: id)
                .map { _ in true }
        }
        .catchAndReturn(false)
    }
    
    func postRandomEnd(id: Int) -> Single<Bool> {
        return executeWithToken { token in
            self.randomRepository.postRandomEnd(token: token, id: id)
                .map { _ in true }
        }
        .catchAndReturn(false)
    }
    
    func postRandomComment(id: Int, oneLine: String) -> Single<Bool> {
        return executeWithToken { token in
            self.randomRepository.postRandomComment(token: token, id: id, oneLine: oneLine)
                .map { _ in true }
        }
        .catchAndReturn(false)
    }
    
    func postRandomStart() -> Single<APIResponse<RandomId>> {
        return executeWithToken { token in
            self.randomRepository.postRandomStart(token: token)
        }
    }
    
    func getRandomTopics(id: Int, order: Int, category: String) -> Single<APIResponse<[RandomTopic]>> {
        let params: [String: Any] = [
            "id": id,
            "order": order,
            "category": category
        ]
        
        return executeWithToken { token in
            self.randomRepository.getRandomTopics(token: token, id: id, parameters: params)
        }
    }
}
