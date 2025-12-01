//
//  AgreeViewController.swift
//  TalkPick
//
//  Created by jaegu park on 12/1/25.
//

import UIKit

class AgreeViewController: UIViewController {
    
    private let agreeView = AgreeView()
    
    override func loadView() {
        self.view = agreeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
