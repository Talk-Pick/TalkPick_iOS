
import UIKit

final class AlertController {
    
    var alertController: UIAlertController
    
    init(message: String, isCancel: Bool = false, completion: @escaping () -> () = {}) {
        alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let okAction = UIAlertAction(title: "확인", style: .default) { alert in
            completion()
        }
        if isCancel {
            alertController.addAction(cancelAction)
        }
        alertController.addAction(okAction)
    }
    
    func show() {
        let presentVC = UIViewController().findPresentViewController()
        presentVC.present(alertController, animated: true, completion: nil)
    }
}

