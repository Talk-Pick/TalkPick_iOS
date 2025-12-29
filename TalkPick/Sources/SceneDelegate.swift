import UIKit
import KakaoSDKAuth
import SnapKit
import RxSwift
 
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let disposeBag = DisposeBag()
    
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
            
            if hasShown {
                // 자동 로그인 확인
                self.checkAutoLogin { [weak self] isLoggedIn in
                    guard let self = self else { return }
                    
                    let mainVC: UIViewController
                    if isLoggedIn {
                        // 로그인 상태면 메인 화면으로
                        mainVC = MainTabViewController()
                    } else {
                        // 로그인 상태가 아니면 로그인 화면으로
                        mainVC = UINavigationController(rootViewController: LoginViewController())
                    }
                    
                    self.window?.rootViewController = mainVC
                    
                    // 부드러운 전환 애니메이션
                    UIView.transition(with: self.window!,
                                    duration: 0.3,
                                    options: .transitionCrossDissolve,
                                    animations: nil,
                                    completion: nil)
                }
            } else {
                let mainVC = UINavigationController(rootViewController: OnboardingViewController())
                
                self.window?.rootViewController = mainVC
                
                // 부드러운 전환 애니메이션
                UIView.transition(with: self.window!,
                                duration: 0.3,
                                options: .transitionCrossDissolve,
                                animations: nil,
                                completion: nil)
            }
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func setRootViewController(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .first(where: { $0 is UIWindowScene }) as? UIWindowScene else {
            return
        }
        
        window.windows.first?.rootViewController = viewController
        window.windows.first?.makeKeyAndVisible()
    }
    
    /// 자동 로그인 확인
    private func checkAutoLogin(completion: @escaping (Bool) -> Void) {
        // Keychain에 저장된 토큰 확인
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user"),
              !token.isEmpty else {
            completion(false)
            return
        }
        
        // 토큰이 있으면 프로필 정보를 가져와서 로그인 상태 확인
        let useCase = UserUseCase()
        useCase.getMyProfile()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { _ in
                    // 프로필 정보를 성공적으로 가져오면 로그인 상태
                    completion(true)
                },
                onFailure: { error in
                    // 프로필 정보를 가져오지 못하면 로그인 상태가 아님
                    // 토큰이 만료되었거나 유효하지 않은 경우
                    print("자동 로그인 실패: \(error.localizedDescription)")
                    // 유효하지 않은 토큰 삭제
                    KeychainHelper.standard.delete(service: "access-token", account: "user")
                    RefreshTokenManager.shared.clearToken()
                    completion(false)
                }
            )
            .disposed(by: disposeBag)
    }
}
