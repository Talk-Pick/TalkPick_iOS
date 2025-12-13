
import UIKit

class MbtiViewController: UIViewController {
    
    private let mbtiView = MbtiView()
    
    override func loadView() {
        self.view = mbtiView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        mbtiView.startButton.addTarget(self, action: #selector(home_Tapped), for: .touchUpInside)
    }
    
    @objc private func home_Tapped() {
        let completeVC = CompleteViewController()
        self.navigationController?.pushViewController(completeVC, animated: true)
    }
}
