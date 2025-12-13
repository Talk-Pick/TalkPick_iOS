//
//  AgreeViewController.swift
//  TalkPick
//
//  Created by jaegu park on 12/1/25.
//

import UIKit

class AgreeViewController: UIViewController {
    
    private let agreeView = AgreeView()
    private let loginViewModel = LoginViewModel()
    
    override func loadView() {
        self.view = agreeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        agreeView.navigationbarView.delegate = self
        agreeView.nextButton.addTarget(self, action: #selector(mbti_Tapped), for: .touchUpInside)
        agreeView.configureTermsContent()
    }
    
    @objc private func mbti_Tapped() {
        loginViewModel.postTerm(agreeTermIdList: [1, 2, 3], disagreeTermIdList: [])
        let mbtiVC = MbtiViewController()
        self.navigationController?.pushViewController(mbtiVC, animated: true)
    }
}
