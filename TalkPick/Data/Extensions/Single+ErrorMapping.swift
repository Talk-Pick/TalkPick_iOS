
import RxSwift
import Foundation

extension PrimitiveSequence where Trait == SingleTrait {
    /// API 에러를 AppError로 변환
    func mapToAppError() -> Single<Element> {
        return self.catch { error in
            return .error(ErrorMapper.mapToAppError(error))
        }
    }
}