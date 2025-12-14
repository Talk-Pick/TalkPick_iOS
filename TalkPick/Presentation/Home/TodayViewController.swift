
import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class TodayViewController: UIViewController {

    private var todayView = TodayView()
    private var topicId = Int()
    private let topicViewModel = TopicViewModel()
    private var disposeBag = DisposeBag()
    
    private var frontURL: URL?
    private var backURL: URL?
    
    override func loadView() {
        self.view = todayView
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
        setAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        todayView.navigationbarView.delegate = self
        todayView.likeButton.addTarget(self, action: #selector(like_Tapped), for: .touchUpInside)
        todayView.onFlip = { [weak self] _ in
            self?.updateCardImage()
        }
    }
}

extension TodayViewController {
    
    private func setAPI() {
        setBind()
        topicViewModel.getTopicDetail(topicId: topicId)
    }
    
    private func setBind() {
        topicViewModel.topicDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                guard let self = self else { return }
                self.todayView.labelLabel1.text = detail.category
                self.todayView.labelLabel2.text = detail.keywordName
                self.frontURL = URL(string: detail.keywordImageUrl)
                self.backURL  = URL(string: detail.topicImageUrl)
                
                // 두 이미지 모두 미리 프리페칭
                self.prefetchImages()
                self.updateCardImage()
            })
            .disposed(by: disposeBag)
    }
    
    private func prefetchImages() {
        let urls = [frontURL, backURL].compactMap { $0 }
        ImagePrefetcher(urls: urls).start()
    }
    
    private func updateCardImage() {
        let url = todayView.isFront ? frontURL : backURL
        let processor = DownsamplingImageProcessor(size: todayView.cardView.bounds.size)
        
        todayView.cardView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.none), // 애니메이션 제거로 즉시 표시
                .cacheOriginalImage, // 원본 이미지도 캐시
                .diskCacheExpiration(.days(7)), // 디스크 캐시 7일
                .memoryCacheExpiration(.days(1)) // 메모리 캐시 1일
            ]
        )
    }
    
    @objc private func like_Tapped() {
        topicViewModel.postTopicLike(topicId: topicId)
    }
}
