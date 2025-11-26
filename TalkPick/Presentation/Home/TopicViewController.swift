//
//  TopicViewController.swift
//  TalkPick
//
//  Created by jaegu park on 10/14/25.
//

import UIKit

class TopicViewController: UIViewController {
    
    private let topicView = TopicView()
    
    override func loadView() {
        self.view = topicView
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
        
//        topicView.navigationbarView.delegate = self
//        topicView.navigationbarView.homeButton.addTarget(self, action: #selector(homeButton), for: .touchUpInside)
    }
    
    @objc private func homeButton() {
        let quitView = QuitView(target: self, num: 3)
        self.view.addSubview(quitView)
        quitView.alpha = 0
        quitView.snp.makeConstraints { $0.edges.equalToSuperview() }
        UIView.animate(withDuration: 0.3) { quitView.alpha = 1 }
    }
}
