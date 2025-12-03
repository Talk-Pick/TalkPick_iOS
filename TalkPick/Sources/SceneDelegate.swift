import UIKit
import KakaoSDKAuth
 
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let hasShown = UserDefaults.standard.bool(forKey: AppStorageKey.hasShownOnboarding)
        if hasShown {
            window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
        } else {
            window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
        }
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
