
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MypageViewController: UIViewController {
    
    private let mypageView = MypageView()
    private let viewModel = MyPageViewModel()
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mypageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
        setAPI()
    }
    
    private func setUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        mypageView.etcSectionView.arrowRowViews.first?.chevronButton.addTarget(self,
                                                                               action: #selector(etcTapped),
                                                                               for: .touchUpInside)
        mypageView.etcSectionView.arrowRowViews[1].chevronButton.addTarget(self,
                                                                           action: #selector(etcTapped),
                                                                           for: .touchUpInside)
        mypageView.collectionSectionView.moreButton.addTarget(self,
                                                              action: #selector(moreTapped),
                                                              for: .touchUpInside)
        mypageView.withdrawButton.addTarget(self,
                                            action: #selector(deleteTapped),
                                            for: .touchUpInside)
        
        mypageView.logOutButton.addTarget(self,
                                          action: #selector(logoutTapped),
                                          for: .touchUpInside)
    }
    
    private func setAPI() {
        bindViewModel()
        viewModel.getMyProfile()
    }
    
    private func bindViewModel() {
        viewModel.profile
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] profile in
                guard let self = self else { return }
                mypageView.updateProfile(profile.nickname, profile.mbti ?? "미설정")
                let editView = EditMbtiView(mbti: profile.mbti ?? "미설정",
                                            viewModel: viewModel)
                mypageView.editMbtiView = editView
            })
            .disposed(by: disposeBag)
        
        viewModel.delete
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                navigateToLogin()
            })
            .disposed(by: disposeBag)
        
        viewModel.logout
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                navigateToLogin()
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func moreTapped() {
        let likeTopicVC = LikeTopicViewController()
        navigationController?.pushViewController(likeTopicVC, animated: true)
    }
    
    @objc private func etcTapped() {
        let serviceView = ServiceView()
        view.addSubview(serviceView)
        serviceView.alpha = 0
        serviceView.snp.makeConstraints { $0.edges.equalToSuperview() }
        UIView.animate(withDuration: 0.3) { serviceView.alpha = 1 }
    }
    
    @objc private func deleteTapped() {
        AlertController(message: "탈퇴하시겠어요?", isCancel: true) { [weak self] in
            self?.viewModel.deleteAccount()
        }.show()
    }
    
    @objc private func logoutTapped() {
        AlertController(message: "로그아웃 하시겠어요?", isCancel: true) { [weak self] in
            self?.viewModel.logOut()
        }.show()
    }
    
    private func navigateToLogin() {
        let loginVC = UINavigationController(rootViewController: LoginViewController())
        SceneDelegate().setRootViewController(loginVC)
    }
}
