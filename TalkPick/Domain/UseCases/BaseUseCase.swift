
import RxSwift

/// UseCase의 공통 기능을 제공하는 베이스 클래스
class BaseUseCase {
    let tokenProvider: TokenProviderProtocol
    
    init(tokenProvider: TokenProviderProtocol = TokenProvider.shared) {
        self.tokenProvider = tokenProvider
    }
    
    /// 토큰이 필요한 작업을 실행합니다
    /// - Parameter operation: 토큰을 받아서 Single을 반환하는 클로저
    /// - Returns: 작업 결과를 담은 Single
    func executeWithToken<T>(_ operation: @escaping (String) -> Single<T>) -> Single<T> {
        guard let token = tokenProvider.getAccessToken() else {
            return .error(AppError.tokenNotFound)
        }
        return operation(token)
    }
    
    /// 토큰이 필요한 작업을 실행합니다 (에러 대신 기본값 반환)
    /// - Parameters:
    ///   - operation: 토큰을 받아서 Single을 반환하는 클로저
    ///   - defaultValue: 토큰이 없을 때 반환할 기본값
    /// - Returns: 작업 결과를 담은 Single
    func executeWithTokenOrDefault<T>(_ operation: @escaping (String) -> Single<T>, defaultValue: T) -> Single<T> {
        guard let token = tokenProvider.getAccessToken() else {
            return .just(defaultValue)
        }
        return operation(token)
    }
}
