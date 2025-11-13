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
    
    func loadDummy() {
        let dummy = [
            Topic(topicId: 0, title: "연애를 할때 가장 중요하게 생각하는 것은?", averageTalkTime: 25, selectCount: 34, category: "소개팅/과팅", keywordName: "소개팅/과팅", keywordIconUrl: ""),
            Topic(topicId: 0, title: "연애를 할때 가장 중요하게 생각하는 것은?", averageTalkTime: 25, selectCount: 34, category: "키워드/카테고리", keywordName: "키워드/카테고리", keywordIconUrl: ""),
        ]
        todayTopics.accept(dummy)
    }
}
