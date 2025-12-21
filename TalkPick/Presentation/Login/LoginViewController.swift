
import KakaoSDKUser
import AuthenticationServices
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
        
        UserApi.shared.loginWithKakaoAccount(nonce: nonce) { [weak self] (oauthToken, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("카카오 로그인 에러: \(error)")
                return
            }
            
            guard let idToken = oauthToken?.idToken else {
                print("idToken이 없습니다. (OpenID Connect 설정/동의항목 확인 필요)")
                return
            }
            
            UserApi.shared.me { [weak self] (user, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("카카오 사용자 정보 가져오기 오류: \(error)")
                    return
                }
                
                let nickname = user?.kakaoAccount?.profile?.nickname ?? ""
                self.userNickname = nickname.isEmpty ? "톡픽" : nickname
                
                self.loginViewModel.kakaoLogin(idToken: idToken)
                    .observe(on: MainScheduler.instance)
                    .subscribe(
                        onSuccess: { [weak self] _ in
                            guard let self = self else { return }
                            self.myPageViewModel.getMyProfile()
                        },
                        onFailure: { error in
                            print("서버 로그인 실패: \(error)")
                        }
                    )
                    .disposed(by: self.disposeBag)
            }
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
            
            let appleNickname = "\(nickName.familyName ?? "")\(nickName.givenName ?? "")"
            self.userNickname = appleNickname.isEmpty ? "톡픽" : appleNickname
            
            self.loginViewModel.appleLogin(idToken: idTokenString)
                .observe(on: MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] response in
                    guard let self = self else { return }
                    self.myPageViewModel.getMyProfile()
                })
                .disposed(by: self.disposeBag)
            
        case let passwordCredential as ASPasswordCredential:
            print("암호 기반 인증에 성공하였습니다.")
            
        default: break
        }
    }
}
