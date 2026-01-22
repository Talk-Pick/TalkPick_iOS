
import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let topicViewModel: TopicViewModel
    private let disposeBag = DisposeBag()
    
    init(topicViewModel: TopicViewModel = TopicViewModel()) {
        self.topicViewModel = topicViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        setAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let tabBarVC = tabBarController as? MainTabViewController {
            TutorialManager.shared.startTutorial(homeViewController: self, tabBarController: tabBarVC)
        }
    }
    
    private func setUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        homeView.startButton.addTarget(self, action: #selector(randomTapped), for: .touchUpInside)
    }
    
    @objc private func randomTapped() {
        let randomVC = RandomCourseViewController()
        navigationController?.pushViewController(randomVC, animated: true)
    }
}

extension HomeViewController {
    
    private func setAPI() {
        topicViewModel.getTodayTopic()
    }
    
    private func bindViewModel() {
        topicViewModel.todayTopics
            .observe(on: MainScheduler.instance)
            .bind(to: homeView.todayTopicCollectionView.rx.items(cellIdentifier: TodayTopicCollectionViewCell.identifier, cellType: TodayTopicCollectionViewCell.self)) { index, item, cell in
                cell.prepare(topic: item)
            }
            .disposed(by: disposeBag)
        
        homeView.todayTopicCollectionView.rx.modelSelected(Topic.self)
            .subscribe(onNext: { [weak self] topicItem in
                guard let self = self else { return }
                let todayVC = TodayViewController(topicId: topicItem.topicId)
                navigationController?.pushViewController(todayVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        topicViewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                AlertController(message: error.userMessage).show()
            })
            .disposed(by: disposeBag)
    }
}
