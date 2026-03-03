//
//  LikeTopicViewController.swift
//  TalkPick
//
//  Created by jaegu park on 12/29/25.
//

import UIKit
import RxSwift
import SkeletonView

class LikeTopicViewController: UIViewController {

    private let likeTopicView = LikeTopicView()
    private let mypageViewModel: MyPageViewModel
    private let disposeBag = DisposeBag()
    private var hasReceivedEmptyResponse = false
    
    init(mypageViewModel: MyPageViewModel = MyPageViewModel()) {
        self.mypageViewModel = mypageViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = likeTopicView
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
            tabBarVC.tabBar.isHidden = false
        }
        updateBackButtonVisibility()
        setAPI()
    }
    
    private func updateBackButtonVisibility() {
        // 탭바 루트(세 번째 탭)일 때는 뒤로가기 버튼 숨김, Mypage에서 push로 진입 시 표시
        let isRootOfNavigation = navigationController?.viewControllers.first == self
        likeTopicView.navigationbarView.backButton.isHidden = isRootOfNavigation
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        likeTopicView.navigationbarView.delegate = self
        // 초기 상태: 로딩 중이므로 모두 숨김
        likeTopicView.noLikeView.isHidden = true
        likeTopicView.likeTopicTableView.isHidden = true
    }
    
    private func setAPI() {
        // 데이터가 비어있다고 이미 확인된 경우 스켈레톤 표시하지 않음 (noLikeView만 표시)
        if !hasReceivedEmptyResponse {
            likeTopicView.showListSkeleton()
        }
        mypageViewModel.getLikedTopics(cursor: nil, size: "10")
    }
    
    private func bindViewModel() {
        likeTopicView.likeTopicTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        mypageViewModel.likeTopicList
            .observe(on: MainScheduler.instance)
            .skip(1) // 초기 빈 배열은 무시하고 실제 API 응답만 처리
            .subscribe(onNext: { [weak self] likedTopics in
                guard let self = self else { return }
                self.likeTopicView.hideListSkeleton()
                let isEmpty = likedTopics.isEmpty
                self.hasReceivedEmptyResponse = isEmpty
                self.likeTopicView.noLikeView.isHidden = !isEmpty
                self.likeTopicView.likeTopicTableView.isHidden = isEmpty
            })
            .disposed(by: disposeBag)
        
        mypageViewModel.likeTopicList
            .observe(on: MainScheduler.instance)
            .bind(to: likeTopicView.likeTopicTableView.rx.items(cellIdentifier: LikeTopicTableViewCell.identifier, cellType: LikeTopicTableViewCell.self)) { index, item, cell in
                cell.prepare(likedDetail: item)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        likeTopicView.likeTopicTableView.rx.modelSelected(LikedDetail.self)
            .subscribe(onNext: { [weak self] topicItem in
                guard let self = self else { return }
                let todayVC = TodayViewController(topicId: topicItem.topicId)
                self.navigationController?.pushViewController(todayVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        mypageViewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.likeTopicView.hideListSkeleton()
                AlertController(message: error.userMessage).show()
            })
            .disposed(by: disposeBag)
    }
}

extension LikeTopicViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
}
