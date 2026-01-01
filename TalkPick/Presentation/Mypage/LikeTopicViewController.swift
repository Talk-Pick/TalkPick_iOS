//
//  LikeTopicViewController.swift
//  TalkPick
//
//  Created by jaegu park on 12/29/25.
//

import UIKit
import RxSwift

class LikeTopicViewController: UIViewController {

    private let likeTopicView = LikeTopicView()
    private let mypageViewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = likeTopicView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        setAPI()
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        likeTopicView.navigationbarView.delegate = self
    }
    
    private func setAPI() {
        mypageViewModel.getLikedTopics(cursor: nil, size: "10")
    }
    
    private func bindViewModel() {
        likeTopicView.likeTopicTableView.rx.setDelegate(self)
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
    }
}

extension LikeTopicViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
}
