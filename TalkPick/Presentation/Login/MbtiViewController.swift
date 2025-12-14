
import UIKit
import RxSwift

class MbtiViewController: UIViewController {
    
    private let mbtiView = MbtiView()
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    private var nickname: String?
    
    init(nickname: String) {
        self.nickname = nickname
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mbtiView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBind()
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // MbtiView의 startButton이 눌렸을 때 MBTI와 닉네임을 함께 전송
        mbtiView.onMbtiSelected = { [weak self] mbti in
            guard let self = self else { return }
            print(mbti)
            print(nickname)
            loginViewModel.signUp(nickname: nickname ?? "톡픽", mbti: mbti)
        }
    }
    
    private func setBind() {
        loginViewModel.signUp
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                let completeVC = CompleteViewController()
                self.navigationController?.pushViewController(completeVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
