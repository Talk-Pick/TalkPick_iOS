
import UIKit

extension UIViewController {
    
    func findPresentViewController() -> UIViewController {
        let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let keyWindow = windowScene.windows.first
        assert((keyWindow != nil), "keyWindow is empty")
        
        var presentViewController = keyWindow?.rootViewController
        
        while true {
            while let presentedViewController = presentViewController?.presentedViewController {
                presentViewController = presentedViewController
            }
            if let navigationController = presentViewController as? UINavigationController {
                presentViewController = navigationController.visibleViewController
                continue
            }
            if let tabBarController = presentViewController as? UITabBarController {
                presentViewController = tabBarController.selectedViewController
                continue
            }
            break
        }
        
        guard let presentViewController = presentViewController else {
            return UIViewController()
        }
        
        return presentViewController
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

