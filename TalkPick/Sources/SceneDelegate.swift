import UIKit
import KakaoSDKAuth
import SnapKit
import RxSwift
import Alamofire
 
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
    
    static func setRootViewController(_ viewController: UIViewController) {
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
        // 액세스 토큰이 있으면 먼저 프로필 확인 (401 발생 시 AuthInterceptor가 자동으로 refreshToken 호출)
        if TokenProvider.shared.getAccessToken() != nil {
            // 프로필 확인으로 로그인 상태 검증 (401 발생 시 자동으로 refreshToken 처리됨)
            verifyProfile(completion: completion)
        } else {
            // 액세스 토큰이 없으면 로그인 화면으로
            completion(false)
        }
    }
    
    /// 프로필 확인으로 로그인 상태 검증
    private func verifyProfile(completion: @escaping (Bool) -> Void) {
        guard let token = TokenProvider.shared.getAccessToken(),
              !token.isEmpty else {
            print("자동 로그인 실패: 액세스 토큰이 없습니다.")
            completion(false)
            return
        }
        
        let useCase = UserUseCase()
        useCase.getMyProfile()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { _ in
                    print("자동 로그인 성공: 프로필 확인 완료")
                    completion(true)
                },
                onFailure: { [weak self] error in
                    guard let self = self else {
                        completion(false)
                        return
                    }
                    
                    print("프로필 확인 실패: \(error)")
                    
                    // 401 에러인지 확인 (토큰 만료)
                    if let afError = error as? AFError,
                       let responseCode = afError.responseCode,
                       responseCode == 401 {
                        print("401 에러 발생: 토큰 만료 또는 유효하지 않음")
                        print("쿠키 확인 중...")
                        
                        // 쿠키 확인
                        if let allCookies = HTTPCookieStorage.shared.cookies {
                            print("저장된 쿠키 개수: \(allCookies.count)")
                            for cookie in allCookies {
                                print("  - \(cookie.name): \(cookie.domain) (expires: \(cookie.expiresDate?.description ?? "nil"))")
                            }
                        } else {
                            print("저장된 쿠키가 없습니다.")
                        }
                        
                        // AuthInterceptor가 이미 retry에서 refreshToken을 시도했을 수 있으므로
                        // 잠시 대기 후 다시 확인
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            // 토큰이 갱신되었는지 확인
                            if TokenProvider.shared.getAccessToken() != nil && TokenProvider.shared.getAccessToken() != token {
                                print("토큰이 갱신되었습니다. 프로필 확인 재시도")
                                self.verifyProfile(completion: completion)
                            } else {
                                print("토큰 갱신 실패 또는 쿠키에 refreshToken이 없습니다.")
                                TokenProvider.shared.clearAccessToken()
                                completion(false)
                            }
                        }
                    } else {
                        // 401이 아닌 다른 에러인 경우
                        print("401이 아닌 다른 에러: \(error)")
                        TokenProvider.shared.clearAccessToken()
                        completion(false)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}
