
import UIKit
import SnapKit

class RandomCourseViewController: UIViewController {
    
    private let randomCourseView = RandomCourseView()
    private let randomViewModel = RandomViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = randomCourseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
    
    private func setUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        randomCourseView.navigationbarView.delegate = self
        randomCourseView.navigationbarView.homeButton.addTarget(self, action: #selector(homeButton), for: .touchUpInside)
        randomCourseView.onExitRequested = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func startAPI() {
//        randomViewModel.postRandomStart()
    }
    
    @objc private func homeButton() {
        let quitView = QuitView(target: self, num: 2)
        view.addSubview(quitView)
        quitView.alpha = 0
        quitView.snp.makeConstraints { $0.edges.equalToSuperview() }
        UIView.animate(withDuration: 0.3) { quitView.alpha = 1 }
    }
}

extension RandomCourseViewController: RandomNavigationBarViewDelegate {
    func tapBackButton() {
        randomCourseView.handleBack()
    }
}
