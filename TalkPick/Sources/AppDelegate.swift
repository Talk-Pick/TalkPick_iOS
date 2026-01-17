
import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn
 
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        KakaoSDK.initSDK(appKey: "b22931e9df6d3e96fbbfa03c2dcf630f")
        
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
