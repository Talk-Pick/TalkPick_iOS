//
//  SituationFirstViewController.swift
//  TalkPick
//
//  Created by jaegu park on 10/8/25.
//

import UIKit

class RandomViewController: UIViewController {
    
    private let randomView = RandomView()
    
    override func loadView() {
        self.view = randomView
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
        
        randomView.navigationbarView.delegate = self
        randomView.navigationbarView.homeButton.addTarget(self, action: #selector(homeButton), for: .touchUpInside)
        randomView.onExitRequested = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func homeButton() {
        let quitView = QuitView(target: self, num: 2)
        self.view.addSubview(quitView)
        quitView.alpha = 0
        quitView.snp.makeConstraints { $0.edges.equalToSuperview() }
        UIView.animate(withDuration: 0.3) { quitView.alpha = 1 }
    }
}

extension RandomViewController: RandomNavigationBarViewDelegate {
    func tapBackButton() {
        randomView.handleBack()
    }
}
