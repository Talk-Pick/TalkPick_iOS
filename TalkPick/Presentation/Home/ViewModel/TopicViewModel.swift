
import RxSwift
import RxCocoa

class TopicViewModel: BaseViewModel {
    
    private let useCase: TopicUseCaseProtocol

    let topicDetail = PublishSubject<TopicDetail>()
    let todayTopics = BehaviorRelay<[Topic]>(value: [])
    let categories = BehaviorRelay<[Category]>(value: [])
    
    init(useCase: TopicUseCaseProtocol = TopicUseCase()) {
        self.useCase = useCase
    }
    
    func postTopicLike(topicId: Int) {
        executeWithLoading {
            self.useCase.postTopicLike(topicId: topicId)
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { _ in }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
    
    func getTopicDetail(topicId: Int) {
        executeWithLoading {
            self.useCase.getTopicDetail(topicId: topicId)
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] detail in
            self?.topicDetail.onNext(detail)
        }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
    
    func getTodayTopic() {
        executeWithLoading {
            self.useCase.getTodayTopic()
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] topics in
            self?.todayTopics.accept(topics)
        }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
    
    func getCategories() {
        executeWithLoading {
            self.useCase.getCategories()
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] categories in
            self?.categories.accept(categories)
        }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
}
