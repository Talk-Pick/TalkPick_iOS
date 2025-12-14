
import UIKit

class AgreeViewController: UIViewController {
    
    private let agreeView = AgreeView()
    private let loginViewModel = LoginViewModel()
    private let nickname: String
    
    init(nickname: String) {
        self.nickname = nickname
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
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        agreeView.navigationbarView.delegate = self
        agreeView.nextButton.addTarget(self, action: #selector(mbti_Tapped), for: .touchUpInside)
        agreeView.configureTermsContent()
    }
    
    @objc private func mbti_Tapped() {
        loginViewModel.postTerm(agreeTermIdList: [1, 2, 3], disagreeTermIdList: [])
        let mbtiVC = MbtiViewController(nickname: nickname)
        self.navigationController?.pushViewController(mbtiVC, animated: true)
    }
}
