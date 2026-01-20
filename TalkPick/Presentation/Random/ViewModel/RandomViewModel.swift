
import RxSwift
import RxCocoa
import Foundation

class RandomViewModel: BaseViewModel {
    
    private let useCase: RandomUseCaseProtocol
    
    let randomTopics = BehaviorRelay<[RandomTopicDetail]>(value: [])
    
    init(useCase: RandomUseCaseProtocol = RandomUseCase()) {
        self.useCase = useCase
    }
    
    func postRandomTotalRecord(id: Int, totalRecords: [TotalRecord]) {
        executeWithLoading {
            self.useCase.postRandomTotalRecord(id: id, totalRecords: totalRecords)
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { _ in }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
    
    func postRandomRate(id: Int, rating: Int) {
        executeWithLoading {
            self.useCase.postRandomRate(id: id, rating: rating)
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { _ in }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
    
    func postRandomQuit(id: Int) {
        executeWithLoading {
            self.useCase.postRandomQuit(id: id)
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { _ in }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
    
    func postRandomEnd(id: Int) {
        executeWithLoading {
            self.useCase.postRandomEnd(id: id)
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { _ in }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
    
    func postRandomComment(id: Int, oneLine: String) {
        executeWithLoading {
            self.useCase.postRandomComment(id: id, oneLine: oneLine)
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { _ in }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
    
    func postRandomStart() {
        executeWithLoading {
            self.useCase.postRandomStart()
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { success in
            UserDefaults.standard.set(success.data.randomId, forKey: "randomId")
        }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
    
    func getRandomTopics(id: Int, order: Int, category: String) {
        executeWithLoading {
            self.useCase.getRandomTopics(id: id, order: order, category: category)
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] topics in
            self?.randomTopics.accept(topics.data[0].randomTopicDetails)
        }, onFailure: { [weak self] error in
            self?.handleError(error)
        })
        .disposed(by: disposeBag)
    }
}
