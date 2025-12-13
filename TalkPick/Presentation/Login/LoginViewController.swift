
import KakaoSDKUser
import AuthenticationServices
import RxSwift

class LoginViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel()
    private let myPageViewModel = MyPageViewModel()
    private let loginView = LoginView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBind()
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        loginView.appleButton.addTarget(self, action: #selector(apple_Tapped), for: .touchUpInside)
        loginView.kakaoButton.addTarget(self, action: #selector(kakao_Tapped), for: .touchUpInside)
    }
    
    private func setBind() {
        myPageViewModel.profile
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] profile in
                guard let self = self else { return }
                if let mbti = profile.mbti, !mbti.isEmpty {
                    let mainTabVC = MainTabViewController()
                    self.navigationController?.pushViewController(mainTabVC, animated: true)
                } else {
                    let agreeVC = AgreeViewController()
                    self.navigationController?.pushViewController(agreeVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func apple_Tapped() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        
        let rawNonce = CryptoHelper.randomNonceString()
        request.nonce = CryptoHelper.sha256(rawNonce)
        
        request.requestedScopes = [.email, .fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @objc private func kakao_Tapped() {
        let randomNonce = CryptoHelper.randomNonceString()
        let nonce = CryptoHelper.sha256(randomNonce)
        if (UserApi.isKakaoTalkLoginAvailable()) {
            //카톡 설치되어있으면 -> 카톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    guard let idToken = oauthToken?.idToken else { return }
                    self.loginViewModel.kakaoLogin(idToken: idToken)
                        .observe(on: MainScheduler.instance)
                        .subscribe(onSuccess: { success in
                            self.myPageViewModel.getMyProfile()
                        })
                        .disposed(by: self.disposeBag)
                }
            }
        }
        else {
            // 카톡 없으면 -> 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount(nonce: nonce) { (oauthToken, error) in
                if let error = error {
                    print("에러는 \(error)")
                } else {
                    guard let idToken = oauthToken?.idToken else { return }
                    self.loginViewModel.kakaoLogin(idToken: idToken)
                        .observe(on: MainScheduler.instance)
                        .subscribe(onSuccess: { success in
                            self.myPageViewModel.getMyProfile()
                        })
                        .disposed(by: self.disposeBag)
                }
            }
        }
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    // 인증창을 보여주기 위한 메서드 (인증창을 보여 줄 화면을 설정)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    // 로그인 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print("로그인 실패", error.localizedDescription)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            guard
                let identityToken = appleIdCredential.identityToken,
                let nickName = appleIdCredential.fullName,
                let idTokenString = String(data: identityToken, encoding: .utf8)
            else {
                print("idToken 또는 nonce 없음")
                return
            }
            
            print("Apple ID 로그인에 성공하였습니다.: \(idTokenString)")
            
            // 여기에 로그인 성공 후 수행할 작업을 추가하세요.
            self.loginViewModel.appleLogin(idToken: idTokenString)
                .observe(on: MainScheduler.instance)
                .subscribe(onSuccess: { response in
                    self.myPageViewModel.getMyProfile()
                })
                .disposed(by: self.disposeBag)
            
        // 암호 기반 인증에 성공한 경우(iCloud), 사용자의 인증 정보를 확인하고 필요한 작업을 수행합니다
        case let passwordCredential as ASPasswordCredential:
            // let userIdentifier = passwordCredential.user
            // let password = passwordCredential.password
            print("암호 기반 인증에 성공하였습니다.")
            
        default: break
        }
    }
}
