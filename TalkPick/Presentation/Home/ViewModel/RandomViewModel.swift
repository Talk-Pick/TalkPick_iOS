
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
            .subscribe(onSuccess: { success in
                print("기록하기 성공")
            }, onFailure: { error in
                AlertController(message: "약관 동의에 실패했습니다.\n다시 시도해주세요.").show()
            })
            .disposed(by: disposeBag)
    }
    
    func postRandomRate(id: Int, rating: Int) {
        useCase.postRandomRate(id: id, rating: rating)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { success in
                print("평점 매기기 성공")
            }, onFailure: { error in
                AlertController(message: "평점 남기기에 실패했습니다.\n다시 시도해주세요.").show()
            })
            .disposed(by: disposeBag)
    }
    
    func postRandomQuit(id: Int) {
        useCase.postRandomQuit(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { success in
                print("그만두기 성공")
            }, onFailure: { error in
                AlertController(message: "랜덤 대화 나가기에 실패했습니다.\n다시 시도해주세요.").show()
            })
            .disposed(by: disposeBag)
    }
    
    func postRandomEnd(id: Int) {
        useCase.postRandomEnd(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { success in
                print("종료 성공")
            }, onFailure: { error in
                AlertController(message: "랜덤 대화 종료에 실패했습니다.\n다시 시도해주세요.").show()
            })
            .disposed(by: disposeBag)
    }
    
    func postRandomComment(id: Int, oneLine: String) {
        useCase.postRandomComment(id: id, oneLine: oneLine)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { success in
                print("평가 성공")
            }, onFailure: { error in
                AlertController(message: "한줄평 남기기에 실패했습니다.\n다시 시도해주세요.").show()
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
                AlertController(message: "랜덤 대화 시작하기에 실패했습니다.\n다시 시도해주세요.").show()
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
                AlertController(message: "랜덤 대화 토픽 불러오기에 실패했습니다.\n다시 시도해주세요.").show()
            })
            .disposed(by: disposeBag)
    }
}
