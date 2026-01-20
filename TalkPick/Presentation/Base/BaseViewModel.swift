
import RxSwift
import RxCocoa

/// ViewModel의 공통 기능을 제공하는 베이스 클래스
class BaseViewModel {
    let disposeBag = DisposeBag()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishSubject<AppError>()
    
    /// 로딩 상태와 함께 작업을 실행합니다
    func executeWithLoading<T>(_ operation: @escaping () -> Single<T>) -> Single<T> {
        isLoading.accept(true)
        return operation()
            .do(onSuccess: { [weak self] _ in
                self?.isLoading.accept(false)
            }, onError: { [weak self] _ in
                self?.isLoading.accept(false)
            })
    }
    
    /// 에러를 AppError로 변환하여 error Subject에 전달합니다
    func handleError(_ error: Error) {
        self.error.onNext(error as? AppError ?? .unknown(error.localizedDescription))
    }
}
