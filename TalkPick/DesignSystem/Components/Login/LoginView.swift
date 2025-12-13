//
//  Loginswift
//  TalkPick
//
//  Created by jaegu park on 10/3/25.
//

import UIKit
import SnapKit

class LoginView: UIView {
    
    private let loginMainView = UIView()
    private let loginSubView = UIView()
    
    private let smallLogo: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_smallLogo"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let mainLogo1: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_mainLogo"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let loginButton: UIButton = {
        let qb = UIButton(type: .system)
        qb.clipsToBounds = true
        qb.layer.cornerRadius = 12
        qb.backgroundColor = .black
        qb.setTitleColor(.white, for: .normal)
        qb.setTitle("로그인", for: .normal)
        qb.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return qb
    }()
    
    private let mainLogo2: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_mainLogo"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var appleButton = makeLoginButton(
        title: "Apple로 로그인",
        titleColor: .white,
        background: .black,
        iconName: "talkpick_apple"
    )
    
    lazy var kakaoButton = makeLoginButton(
        title: "카카오톡으로 로그인",
        titleColor: .black,
        background: UIColor(red: 0xFE/255, green: 0xE5/255, blue: 0x00/255, alpha: 1),
        iconName: "talkpick_kakao"
    )
    
    lazy var buttonsStack: UIStackView = {
        let st = UIStackView()
        st.addArrangedSubview(appleButton)
        st.addArrangedSubview(kakaoButton)
        st.axis = .vertical
        st.spacing = 14
        return st
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(loginMainView)
        loginMainView.addSubview(smallLogo)
        loginMainView.addSubview(mainLogo1)
        loginMainView.addSubview(loginButton)
        
        addSubview(loginSubView)
        loginSubView.addSubview(mainLogo2)
        loginSubView.addSubview(buttonsStack)
    }
    
    private func setupConstraints() {
        loginMainView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(49)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        smallLogo.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
            $0.height.equalTo(42)
            $0.width.equalTo(140)
        }
        
        mainLogo1.snp.makeConstraints {
            $0.top.equalTo(smallLogo.snp.bottom).offset(100)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(342)
        }
        
        loginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-148)
            $0.leading.trailing.equalToSuperview().inset(72)
            $0.height.equalTo(55)
        }
        loginButton.addTarget(self, action: #selector(setloginVisible), for: .touchUpInside)
        
        loginSubView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(158)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        loginSubView.isHidden = true
        
        mainLogo2.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(342)
        }
        
        buttonsStack.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-122)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(114)
        }
        appleButton.snp.makeConstraints {
            $0.height.equalTo(51)
        }
        kakaoButton.snp.makeConstraints {
            $0.height.equalTo(51)
        }
    }
    
    private func makeLoginButton(title: String,
                                 titleColor: UIColor,
                                 background: UIColor,
                                 iconName: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.backgroundColor = background
        btn.layer.cornerRadius = 14
        btn.clipsToBounds = true
        
        let icon = UIImageView(image: UIImage(named: iconName))
        icon.contentMode = .scaleAspectFit
        icon.isUserInteractionEnabled = false
        
        let label = UILabel()
        label.text = title
        label.textColor = titleColor
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.isUserInteractionEnabled = false
        
        let container = UIView()
        container.isUserInteractionEnabled = false
        btn.addSubview(container)
        container.addSubview(icon)
        container.addSubview(label)
        
        container.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview()
        }
        
        icon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(6)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(22)
        }
        
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        return btn
    }
    
    @objc private func setloginVisible() {
        UIView.animate(withDuration: 0.25, animations: {
            self.loginMainView.alpha = 0
        }, completion: { _ in
            self.loginMainView.isHidden = true
            self.loginSubView.isHidden = false
            self.loginSubView.alpha = 0
            
            UIView.animate(withDuration: 0.25) {
                self.loginSubView.alpha = 1
            }
        })
    }
}
