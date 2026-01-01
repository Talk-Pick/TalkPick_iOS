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
        // 액세스 토큰이 있으면 먼저 토큰 갱신 시도 (리프레시 토큰은 쿠키로 관리)
        if AccessTokenManager.shared.getToken() != nil {
            refreshAccessToken { [weak self] success in
                guard let self = self else {
                    completion(false)
                    return
                }
                
                if success {
                    // 토큰 갱신 성공 시 프로필 확인
                    self.verifyProfile(completion: completion)
                } else {
                    // 토큰 갱신 실패 시 프로필 확인으로 재시도 (쿠키의 리프레시 토큰으로 자동 갱신될 수 있음)
                    self.verifyProfile(completion: completion)
                }
            }
        } else {
            // 액세스 토큰이 없으면 프로필 확인
            verifyProfile(completion: completion)
        }
    }
    
    /// 액세스 토큰 갱신
    private func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let accessToken = AccessTokenManager.shared.getToken() else {
            completion(false)
            return
        }
        
        let url = APIConstants.tokenRefresh.path
        let headers: HTTPHeaders = [
            "Accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url,
                   method: .post,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: Token.self) { response in
            switch response.result {
            case .success(let data):
                AccessTokenManager.shared.saveToken(data.accessToken)
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    /// 프로필 확인으로 로그인 상태 검증
    private func verifyProfile(completion: @escaping (Bool) -> Void) {
        guard let token = AccessTokenManager.shared.getToken() ?? KeychainHelper.standard.read(service: "access-token", account: "user"),
              !token.isEmpty else {
            completion(false)
            return
        }
        
        let useCase = UserUseCase()
        useCase.getMyProfile()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { _ in
                    completion(true)
                },
                onFailure: { [weak self] error in
                    guard let self = self else {
                        completion(false)
                        return
                    }
                    
                    // 401 에러인지 확인 (토큰 만료)
                    if let afError = error as? AFError,
                       let responseCode = afError.responseCode,
                       responseCode == 401 {
                        // 토큰 만료 시 토큰 갱신 후 재시도
                        self.refreshAccessToken { success in
                            if success {
                                // 토큰 갱신 성공 시 프로필 확인 재시도
                                self.verifyProfile(completion: completion)
                            } else {
                                // 토큰 갱신 실패 시 로그아웃 처리
                                AccessTokenManager.shared.clearToken()
                                completion(false)
                            }
                        }
                    } else {
                        // 401이 아닌 다른 에러인 경우
                        AccessTokenManager.shared.clearToken()
                        completion(false)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}
