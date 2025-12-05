//
//  CompleteViewController.swift
//  TalkPick
//
//  Created by jaegu park on 12/3/25.
//

import UIKit

class CompleteViewController: UIViewController {

    private let completeView = CompleteView()
    
    override func loadView() {
        self.view = completeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        completeView.finishButton.addTarget(self, action: #selector(home_Tapped), for: .touchUpInside)
    }
    
    @objc private func home_Tapped() {
        let mainVC = MainTabViewController()
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
}
