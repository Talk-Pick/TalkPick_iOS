
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RandomViewController: UIViewController {
    
    private let randomView = RandomView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = randomView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
    }
}

extension RandomViewController {
    
    private func setUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        randomView.rightButton.addTarget(self, action: #selector(randomTapped), for: .touchUpInside)
    }
    
    @objc private func randomTapped() {
        let randomVC = RandomCourseViewController()
        navigationController?.pushViewController(randomVC, animated: true)
    }
}
