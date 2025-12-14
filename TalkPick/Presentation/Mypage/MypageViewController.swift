
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MypageViewController: UIViewController {
    
    private let mypageView = MypageView()
    private let viewModel = MyPageViewModel()
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mypageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        mypageView.etcSectionView.arrowRowViews.first?.chevronButton.addTarget(self,
                                                                               action: #selector(etc_Tapped),
                                                                               for: .touchUpInside)
        mypageView.etcSectionView.arrowRowViews[1].chevronButton.addTarget(self,
                                                                           action: #selector(etc_Tapped),
                                                                           for: .touchUpInside)
        mypageView.collectionSectionView.moreButton.addTarget(self,
                                                              action: #selector(more_Tapped),
                                                              for: .touchUpInside)
    }
    
    private func setProfile() {
        bindViewModel()
        viewModel.getMyProfile()
    }
    
    private func bindViewModel() {
        viewModel.profile
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] profile in
                guard let self = self else { return }
                self.mypageView.updateProfile(profile.nickname, profile.mbti ?? "미설정")
                let editView = EditMbtiView(mbti: profile.mbti ?? "미설정",
                                            viewModel: self.viewModel)
                self.mypageView.editMbtiView = editView
            })
            .disposed(by: disposeBag)
    }
    
    
    @objc private func more_Tapped() {
        let likeTopicVC = LikeTopicViewController()
        self.navigationController?.pushViewController(likeTopicVC, animated: true)
    }
    
    @objc private func etc_Tapped() {
        let serviceView = ServiceView()
        self.view.addSubview(serviceView)
        serviceView.alpha = 0
        serviceView.snp.makeConstraints { $0.edges.equalToSuperview() }
        UIView.animate(withDuration: 0.3) { serviceView.alpha = 1 }
    }
}
