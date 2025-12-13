
import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
 
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var window: UIWindow?
 
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
                let viewController = UIViewController()
                viewController.view.backgroundColor = .orange
                window?.rootViewController = viewController
                window?.makeKeyAndVisible()
        
        KakaoSDK.initSDK(appKey: "b22931e9df6d3e96fbbfa03c2dcf630f")
 
        return true
    }
 
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
}
