
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
                AlertController(message: "좋아요에 실패했습니다.\n다시 시도해주세요.").show()
            })
            .disposed(by: disposeBag)
    }
    
    func getTopicDetail(topicId: Int) {
        useCase.getTopicDetail(topicId: topicId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] detail in
                self?.topicDetail.onNext(detail)
            }, onFailure: { error in
                AlertController(message: "토픽 상세 불러오기에 실패했습니다.\n다시 시도해주세요.").show()
            })
            .disposed(by: disposeBag)
    }
    
    func getTodayTopic() {
        useCase.getTodayTopic()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] topics in
                self?.todayTopics.accept(topics)
            }, onFailure: { error in
                AlertController(message: "오늘의 토픽 불러오기에 실패했습니다.\n다시 시도해주세요.").show()
            })
            .disposed(by: disposeBag)
    }
    
    func getCategories() {
        useCase.getCategories()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] categories in
                self?.categories.accept(categories)
            }, onFailure: { error in
                AlertController(message: "카테고리 불러오기에 실패했습니다.\n다시 시도해주세요.").show()
            })
            .disposed(by: disposeBag)
    }
}
