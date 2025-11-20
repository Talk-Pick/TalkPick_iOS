//
//  TodayViewController.swift
//  TalkPick
//
//  Created by jaegu park on 10/4/25.
//

import UIKit

class TodayViewController: UIViewController {

    private var todayView = TodayView(viewModel: TopicViewModel())
    
    override func loadView() {
        self.view = todayView
    }
    
    init(viewModel: TopicViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.todayView = TodayView(viewModel: viewModel)
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
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        todayView.navigationbarView.delegate = self
    }
}
