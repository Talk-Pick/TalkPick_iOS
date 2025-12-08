//
//  TodayViewController.swift
//  TalkPick
//
//  Created by jaegu park on 10/4/25.
//

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
                let style = categoryStyles[detail.category]
                self.todayView.labelView1.backgroundColor = style?.bgColor
                self.todayView.labelLabel1.textColor = style?.textColor
                self.todayView.labelLabel1.text = detail.category
                self.todayView.labelLabel2.text = detail.keywordName
                self.frontURL = URL(string: detail.keywordImageUrl)
                self.backURL  = URL(string: detail.topicImageUrl)
                self.updateCardImage()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateCardImage() {
        let url = todayView.isFront ? frontURL : backURL
        todayView.cardView.kf.setImage(with: url)
    }
    
    @objc private func like_Tapped() {
        topicViewModel.postTopicLike(topicId: topicId)
    }
}
