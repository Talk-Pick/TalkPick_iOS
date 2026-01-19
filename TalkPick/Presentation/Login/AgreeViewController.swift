
import UIKit
import RxSwift

class AgreeViewController: UIViewController {
    
    private let agreeView = AgreeView()
    private let loginViewModel: LoginViewModel
    private let nickname: String?
    private let disposeBag = DisposeBag()
    
    init(
        nickname: String,
        loginViewModel: LoginViewModel = LoginViewModel()
    ) {
        self.nickname = nickname
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = agreeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindViewModel()
    }
    
    private func bindViewModel() {
        loginViewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                AlertController(message: error.userMessage).show()
            })
            .disposed(by: disposeBag)
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        agreeView.navigationbarView.delegate = self
        agreeView.nextButton.addTarget(self, action: #selector(mbti_Tapped), for: .touchUpInside)
        agreeView.configureTermsContent()
    }
    
    @objc private func mbti_Tapped() {
        loginViewModel.postTerm(agreeTermIdList: [1, 2, 3], disagreeTermIdList: [])
        let mbtiVC = MbtiViewController(nickname: nickname ?? "TalkPick")
        self.navigationController?.pushViewController(mbtiVC, animated: true)
    }
}
