
import UIKit
import RxSwift

class TodayViewController: UIViewController {

    private var todayView = TodayView()
    private var topicId = Int()
    private let topicViewModel = TopicViewModel()
    private let myPageViewModel = MyPageViewModel()
    private var disposeBag = DisposeBag()
    
    private var isLiked: Bool = false
    
    override func loadView() {
        view = todayView
    }
    
    init(topicId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.topicId = topicId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
        
        setAPI()
    }
    
    private func setUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        todayView.navigationbarView.delegate = self
        todayView.likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
    }
}

extension TodayViewController {
    
    private func setAPI() {
        setBind()
        topicViewModel.getTopicDetail(topicId: topicId)
        myPageViewModel.getLikedTopics(cursor: nil, size: "10")
    }
    
    private func setBind() {
        topicViewModel.topicDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                guard let self = self else { return }
                todayView.updateDetail(
                    category: detail.category,
                    keyword: detail.keywordName,
                    frontImageUrl: detail.keywordImageUrl,
                    backImageUrl: detail.topicImageUrl
                )
            })
            .disposed(by: disposeBag)
        
        myPageViewModel.likeTopicList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] likedTopics in
                guard let self = self else { return }
                isLiked = likedTopics.contains(where: { $0.topicId == self.topicId })
                updateLikeButton()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateLikeButton() {
        if isLiked {
            todayView.likeButton.setImage(UIImage(named: "talkpick_like2")?.withRenderingMode(.alwaysOriginal), for: .normal)
            todayView.likeButton.isEnabled = false
        } else {
            todayView.likeButton.setImage(UIImage(named: "talkpick_like3")?.withRenderingMode(.alwaysOriginal), for: .normal)
            todayView.likeButton.isEnabled = true
        }
    }
    
    @objc private func likeTapped() {
        isLiked = true
        updateLikeButton()
        topicViewModel.postTopicLike(topicId: topicId)
    }
}
