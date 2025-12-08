//
//  TopicViewModel.swift
//  TalkPick
//
//  Created by jaegu park on 11/4/25.
//

import RxSwift
import RxCocoa

class TopicViewModel {
    
    private let disposeBag = DisposeBag()
    private let useCase: TopicUseCase
    
    let todayTopics = BehaviorRelay<[Topic]>(value: [])
    let topicDetail = PublishSubject<TopicDetail>()
    let topicLiked = PublishSubject<Bool>()
    
    init(useCase: TopicUseCase = TopicUseCase()) {
        self.useCase = useCase
    }
    
    func getTodayTopic() {
        useCase.getTodayTopic()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] topics in
                self?.todayTopics.accept(topics)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func getTopicDetail(topicId: Int) {
        useCase.getTopicDetail(topicId: topicId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] detail in
                self?.topicDetail.onNext(detail)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func postTopicLike(topicId: Int) {
        useCase.postTopicLike(topicId: topicId)
            .subscribe(onSuccess: { [weak self] success in
                self?.topicLiked.onNext(success)
                print("좋아요 성공")
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
