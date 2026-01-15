
import RxSwift
import RxCocoa

class TopicViewModel {
    
    private let disposeBag = DisposeBag()
    private let useCase: TopicUseCase

    let topicDetail = PublishSubject<TopicDetail>()
    let todayTopics = BehaviorRelay<[Topic]>(value: [])
    let categories = BehaviorRelay<[Category]>(value: [])
    
    init(useCase: TopicUseCase = TopicUseCase()) {
        self.useCase = useCase
    }
    
    func postTopicLike(topicId: Int) {
        useCase.postTopicLike(topicId: topicId)
            .subscribe(onSuccess: { success in
            }, onFailure: { error in
                AlertController(message: ErrorMessage.topicLikeFailed).show()
            })
            .disposed(by: disposeBag)
    }
    
    func getTopicDetail(topicId: Int) {
        useCase.getTopicDetail(topicId: topicId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] detail in
                self?.topicDetail.onNext(detail)
            }, onFailure: { error in
                AlertController(message: ErrorMessage.topicDetailLoadFailed).show()
            })
            .disposed(by: disposeBag)
    }
    
    func getTodayTopic() {
        useCase.getTodayTopic()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] topics in
                self?.todayTopics.accept(topics)
            }, onFailure: { error in
                AlertController(message: ErrorMessage.todayTopicLoadFailed).show()
            })
            .disposed(by: disposeBag)
    }
    
    func getCategories() {
        useCase.getCategories()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] categories in
                self?.categories.accept(categories)
            }, onFailure: { error in
                AlertController(message: ErrorMessage.categoryLoadFailed).show()
            })
            .disposed(by: disposeBag)
    }
}
