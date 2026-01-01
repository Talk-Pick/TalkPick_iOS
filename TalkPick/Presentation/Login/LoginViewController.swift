
import KakaoSDKUser
import AuthenticationServices
import GoogleSignIn
import RxSwift

class LoginViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel()
    private let myPageViewModel = MyPageViewModel()
    private let loginView = LoginView()
    private let disposeBag = DisposeBag()

    private var userNickname: String?
    
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
        loginView.googleButton.addTarget(self, action: #selector(google_Tapped), for: .touchUpInside)
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
                    let agreeVC = AgreeViewController(nickname: self.userNickname ?? "톡픽")
                    self.navigationController?.pushViewController(agreeVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func apple_Tapped() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.nonce = CryptoHelper.sha256(CryptoHelper.randomNonceString())
        request.requestedScopes = [.email, .fullName]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @objc private func kakao_Tapped() {
        let randomNonce = CryptoHelper.randomNonceString()
        let nonce = CryptoHelper.sha256(randomNonce)
        
        UserApi.shared.loginWithKakaoAccount(nonce: nonce) { [weak self] (oauthToken, error) in
            guard let self = self else { return }
            
            guard let idToken = oauthToken?.idToken else {
                AlertController(message: "로그인 정보를 가져오는데 실패했습니다.\n다시 시도해주세요.").show()
                return
            }
            print("idToken: " + idToken)
            
            UserApi.shared.me { [weak self] (user, error) in
                guard let self = self else { return }
                
                let nickname = user?.kakaoAccount?.profile?.nickname ?? ""
                self.userNickname = nickname.isEmpty ? "톡픽" : nickname
                
                self.loginViewModel.kakaoLogin(idToken: idToken)
                    .observe(on: MainScheduler.instance)
                    .subscribe(
                        onSuccess: { [weak self] success in
                            guard let self = self else { return }
                            if success {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.myPageViewModel.getMyProfile()
                                }
                            } else {
                                AlertController(message: "로그인에 실패했습니다.\n다시 시도해주세요.").show()
                            }
                        },
                        onFailure: { error in
                            AlertController(message: "로그인에 실패했습니다.\n다시 시도해주세요.").show()
                        }
                    )
                    .disposed(by: self.disposeBag)
            }
        }
    }
    
    @objc private func google_Tapped() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            guard let self = self else { return }
            
            guard let idToken = result?.user.idToken?.tokenString else {
                AlertController(message: "로그인 정보를 가져오는데 실패했습니다.\n다시 시도해주세요.").show()
                return
            }
            
            let nickname = result?.user.profile?.name ?? ""
            self.userNickname = nickname.isEmpty ? "톡픽" : nickname
            print("idToken: " + idToken)
            
            self.loginViewModel.googleLogin(idToken: idToken)
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onSuccess: { [weak self] success in
                        guard let self = self else { return }
                        if success {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.myPageViewModel.getMyProfile()
                            }
                        } else {
                            AlertController(message: "로그인에 실패했습니다.\n다시 시도해주세요.").show()
                        }
                    },
                    onFailure: { error in
                        AlertController(message: "로그인에 실패했습니다.\n다시 시도해주세요.").show()
                    }
                )
                .disposed(by: self.disposeBag)
        }
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        AlertController(message: "애플 로그인에 실패했습니다.\n다시 시도해주세요.").show()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            guard
                let identityToken = appleIdCredential.identityToken,
                let idTokenString = String(data: identityToken, encoding: .utf8)
            else {
                AlertController(message: "로그인 정보를 가져오는데 실패했습니다.\n다시 시도해주세요.").show()
                return
            }
            
            if let nickName = appleIdCredential.fullName {
                let appleNickname = "\(nickName.familyName ?? "")\(nickName.givenName ?? "")"
                self.userNickname = appleNickname.isEmpty ? "톡픽" : appleNickname
            } else {
                self.userNickname = "톡픽"
            }
            print("idToken: " + idTokenString)
            
            self.loginViewModel.appleLogin(idToken: idTokenString)
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onSuccess: { [weak self] success in
                        guard let self = self else { return }
                        if success {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.myPageViewModel.getMyProfile()
                            }
                        } else {
                            AlertController(message: "로그인에 실패했습니다.\n다시 시도해주세요.").show()
                        }
                    },
                    onFailure: { error in
                        AlertController(message: "로그인에 실패했습니다.\n다시 시도해주세요.").show()
                    }
                )
                .disposed(by: self.disposeBag)
            
        default: break
        }
    }
}
