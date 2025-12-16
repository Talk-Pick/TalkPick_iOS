import UIKit
import KakaoSDKAuth
import SnapKit
 
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // 런치스크린과 동일한 임시 화면 표시
        let launchVC = UIViewController()
        launchVC.view.backgroundColor = .white
        
        // 런치스크린 이미지 추가 (있다면)
        let launchImageView = UIImageView(image: UIImage(named: "talkpick_launch"))
        launchImageView.contentMode = .scaleAspectFit
        launchVC.view.addSubview(launchImageView)
        launchImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(270)
        }
        
        window?.rootViewController = launchVC
        window?.makeKeyAndVisible()
        
        // 3초 후 실제 화면으로 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }
            
            let hasShown = UserDefaults.standard.bool(forKey: AppStorageKey.hasShownOnboarding)
            let mainVC: UIViewController
            
            if hasShown {
                mainVC = UINavigationController(rootViewController: LoginViewController())
            } else {
                mainVC = UINavigationController(rootViewController: OnboardingViewController())
            }
            
            self.window?.rootViewController = mainVC
            
            // 부드러운 전환 애니메이션
            UIView.transition(with: self.window!,
                            duration: 0.3,
                            options: .transitionCrossDissolve,
                            animations: nil,
                            completion: nil)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
