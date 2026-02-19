
import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn
import SkeletonView

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        KakaoSDK.initSDK(appKey: "b22931e9df6d3e96fbbfa03c2dcf630f")
        
        // SkeletonView 옅은 회색으로 설정 (실기기에서 검은색으로 보이는 현상 방지)
        let lightGrayColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        SkeletonAppearance.default.tintColor = lightGrayColor
        SkeletonAppearance.default.gradient = SkeletonGradient(baseColor: lightGrayColor)
        
        if let clientId = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String {
            let config = GIDConfiguration(clientID: clientId)
            GIDSignIn.sharedInstance.configuration = config
        }
        
        return true
    }
 
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Google Sign-In URL 핸들링
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }
        
        // Kakao URL 핸들링
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
}
