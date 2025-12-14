
import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let topicViewModel = TopicViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        setAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        homeView.startButton.addTarget(self, action: #selector(situation_Tapped), for: .touchUpInside)
    }
    
    @objc private func situation_Tapped() {
        let randomVC = RandomViewController()
        self.navigationController?.pushViewController(randomVC, animated: true)
    }
}

extension HomeViewController {
    
    private func setAPI() {
        topicViewModel.getTodayTopic()
    }
    
    private func bindViewModel() {
        homeView.todayTopicCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
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
                self.navigationController?.pushViewController(todayVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 221, height: 178)
    }
}
