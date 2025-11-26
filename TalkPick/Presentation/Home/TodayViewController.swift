//
//  TodayViewController.swift
//  TalkPick
//
//  Created by jaegu park on 10/4/25.
//

import UIKit
import RxSwift
import RxCocoa

class TodayViewController: UIViewController {

    private var todayView = TodayView()
    private var topicId = Int()
    private let topicViewModel = TopicViewModel()
    private var disposeBag = DisposeBag()
    
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
                self?.todayView.labelLabel1.text = detail.category
                self?.todayView.labelLabel2.text = detail.keywordName
                self?.todayView.cardView.image = self?.todayView.isFront ?? true ? UIImage(named: detail.keywordImageUrl) : UIImage(named: detail.topicImageUrl)
            })
            .disposed(by: disposeBag)
    }
}
