//
//  MypageViewController.swift
//  TalkPick
//
//  Created by jaegu park on 11/14/25.
//

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
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setProfile() {
        bindViewModel()
        viewModel.getMyProfile()
    }
    
    private func bindViewModel() {
        viewModel.profile
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] profile in
                self?.mypageView.updateProfile(profile.nickname, profile.mbti ?? "미설정")
                self?.mypageView.editMbtiView = EditMbtiView(mbti: profile.mbti ?? "미설정")
            })
            .disposed(by: disposeBag)
    }
}
