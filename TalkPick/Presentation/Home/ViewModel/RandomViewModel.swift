//
//  RandomViewModel.swift
//  TalkPick
//
//  Created by jaegu park on 12/9/25.
//

import RxSwift
import RxCocoa
import Foundation

class RandomViewModel {
    
    private let disposeBag = DisposeBag()
    private let useCase: RandomUseCase
    
    let randomTopics = BehaviorRelay<[RandomTopicDetail]>(value: [])
    
    init(useCase: RandomUseCase = RandomUseCase()) {
        self.useCase = useCase
    }
    
    func postRandomRate(id: Int, rating: Int) {
        useCase.postRandomRate(id: id, rating: rating)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { success in
                print("평점 매기기 성공")
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func postRandomComment(id: Int, oneLine: String) {
        useCase.postRandomComment(id: id, oneLine: oneLine)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { success in
                print("평가 성공")
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func postRandomStart() {
        useCase.postRandomStart()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { success in
                let randomId = success.data.randomId
                UserDefaults.standard.set(randomId, forKey: "randomId")
                print("랜덤 시작 성공")
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func getRandomTopics(id: Int, order: Int, categoryGroup: String, category: String) {
        useCase.getRandomTopics(id: id, order: order, categoryGroup: categoryGroup, category: category)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] topics in
                self?.randomTopics.accept(topics.data[0].randomTopicDetails)
                print("토픽 불러오기 성공")
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
