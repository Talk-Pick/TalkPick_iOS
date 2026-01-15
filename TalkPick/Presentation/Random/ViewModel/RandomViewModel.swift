
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
    
    func postRandomTotalRecord(id: Int, totalRecords: [TotalRecord]) {
        useCase.postRandomTotalRecord(id: id, totalRecords: totalRecords)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { _ in
            }, onFailure: { error in
                AlertController(message: ErrorMessage.randomTotalRecordFailed).show()
            })
            .disposed(by: disposeBag)
    }
    
    func postRandomRate(id: Int, rating: Int) {
        useCase.postRandomRate(id: id, rating: rating)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { _ in
            }, onFailure: { error in
                AlertController(message: ErrorMessage.randomRateFailed).show()
            })
            .disposed(by: disposeBag)
    }
    
    func postRandomQuit(id: Int) {
        useCase.postRandomQuit(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { _ in
            }, onFailure: { error in
                AlertController(message: ErrorMessage.randomQuitFailed).show()
            })
            .disposed(by: disposeBag)
    }
    
    func postRandomEnd(id: Int) {
        useCase.postRandomEnd(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { _ in
            }, onFailure: { error in
                AlertController(message: ErrorMessage.randomEndFailed).show()
            })
            .disposed(by: disposeBag)
    }
    
    func postRandomComment(id: Int, oneLine: String) {
        useCase.postRandomComment(id: id, oneLine: oneLine)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { _ in
            }, onFailure: { error in
                AlertController(message: ErrorMessage.randomCommentFailed).show()
            })
            .disposed(by: disposeBag)
    }
    
    func postRandomStart() {
        useCase.postRandomStart()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { success in
                let randomId = success.data.randomId
                UserDefaults.standard.set(randomId, forKey: "randomId")
            }, onFailure: { error in
                AlertController(message: ErrorMessage.randomStartFailed).show()
            })
            .disposed(by: disposeBag)
    }
    
    func getRandomTopics(id: Int, order: Int, category: String) {
        useCase.getRandomTopics(id: id, order: order, category: category)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] topics in
                self?.randomTopics.accept(topics.data[0].randomTopicDetails)
            }, onFailure: { error in
                AlertController(message: ErrorMessage.randomTopicLoadFailed).show()
            })
            .disposed(by: disposeBag)
    }
}
