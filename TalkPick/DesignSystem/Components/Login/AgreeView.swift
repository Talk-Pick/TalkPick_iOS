//
//  AgreeView.swift
//  TalkPick
//
//  Created by jaegu park on 12/1/25.
//

import UIKit
import SnapKit

class AgreeView: UIView {
    
    let navigationbarView = NavigationBarView(title: "회원가입")
    
    private let characterImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "talkpick_agree")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let agreementTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "약관동의"
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    private let agreementSubLabel: UILabel = {
        let label = UILabel()
        label.text = "필수항목 및 선택항목 약관에 동의해 주세요."
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray200
        return label
    }()
    
    private let allAgreeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let allAgreeCheck: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "talkpick_noncheck")
        return iv
    }()
    
    private let allAgreeLabel: UILabel = {
        let label = UILabel()
        label.text = "전체동의"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var row1 = makeAgreementRow(title: "서비스 이용약관 동의", type: "필수")
    lazy var row2 = makeAgreementRow(title: "전자금융거래 이용약관 동의", type: "필수")
    lazy var row3 = makeAgreementRow(title: "개인정보 수집 및 이용 동의", type: "필수")
    lazy var row4 = makeAgreementRow(title: "커뮤니티 이용규칙 확인", type: "선택")
    
    private let ageCheckContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let ageCheckIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "talkpick_noncheck")
        return iv
    }()
    
    private let ageCheckLabel: UILabel = {
        let label = UILabel()
        let text = "만 14세 이상이며 본인 명의로 가입을 진행하겠습니다"
        let attr = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "만 14세 이상")
        let range2 = (text as NSString).range(of: "본인 명의로 가입")
        attr.addAttribute(.foregroundColor, value: UIColor.purple100, range: range1)
        attr.addAttribute(.foregroundColor, value: UIColor.purple100, range: range2)
        label.attributedText = attr
        label.font = .systemFont(ofSize: 14, weight: .heavy)
        return label
    }()
    
    let nextButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("다음으로", for: .normal)
        bt.backgroundColor = .white
        bt.setTitleColor(.gray200, for: .normal)
        bt.layer.borderColor = UIColor.gray200.cgColor
        bt.layer.borderWidth = 1
        bt.layer.cornerRadius = 10
        bt.isEnabled = false
        bt.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return bt
    }()
    
    private var allAgree = false
    private var agree1 = false
    private var agree2 = false
    private var agree3 = false
    private var agreeOptional = false
    private var agreeAge = false
    
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
        addSubview(navigationbarView)
        addSubview(characterImageView)
        addSubview(agreementTitleLabel)
        addSubview(agreementSubLabel)
        addSubview(allAgreeContainer)
        addSubview(ageCheckContainer)
        addSubview(nextButton)
        
        let rows = [row1, row2, row3, row4]
        rows.forEach { addSubview($0) }
        
        row1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRow1)))
        row2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRow2)))
        row3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRow3)))
        row4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRow4)))
        allAgreeContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAllAgree)))
        ageCheckContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAgeCheck)))
    }
    
    private func setupConstraints() {
        navigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(40)
        }
        
        agreementTitleLabel.snp.makeConstraints {
            $0.top.equalTo(characterImageView.snp.bottom)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(35)
        }
        
        agreementSubLabel.snp.makeConstraints {
            $0.top.equalTo(agreementTitleLabel.snp.bottom)
            $0.leading.equalTo(agreementTitleLabel)
            $0.height.equalTo(20)
        }
        
        allAgreeContainer.addSubview(allAgreeCheck)
        allAgreeContainer.addSubview(allAgreeLabel)
        
        allAgreeContainer.snp.makeConstraints {
            $0.top.equalTo(agreementSubLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(55)
        }
        
        allAgreeCheck.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(18)
        }
        
        allAgreeLabel.snp.makeConstraints {
            $0.leading.equalTo(allAgreeCheck.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(23)
        }
        
        row1.snp.makeConstraints {
            $0.top.equalTo(allAgreeContainer.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(39)
        }
        row2.snp.makeConstraints {
            $0.top.equalTo(row1.snp.bottom)
            $0.leading.trailing.equalTo(row1)
            $0.height.equalTo(39)
        }
        row3.snp.makeConstraints {
            $0.top.equalTo(row2.snp.bottom)
            $0.leading.trailing.equalTo(row1)
            $0.height.equalTo(39)
        }
        row4.snp.makeConstraints {
            $0.top.equalTo(row3.snp.bottom)
            $0.leading.trailing.equalTo(row1)
            $0.height.equalTo(39)
        }
        
        ageCheckContainer.addSubview(ageCheckIcon)
        ageCheckContainer.addSubview(ageCheckLabel)
        
        ageCheckContainer.snp.makeConstraints {
            $0.top.equalTo(row4.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(55)
        }
        
        ageCheckIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(18)
        }
        
        ageCheckLabel.snp.makeConstraints {
            $0.leading.equalTo(ageCheckIcon.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().offset(-44)
            $0.height.equalTo(51)
        }
    }
    
    private func makeAgreementRow(title: String, type: String) -> UIView {
        let container = UIView()
        container.isUserInteractionEnabled = true   // 터치 가능하도록 추가
        
        let checkIcon = UIImageView()
        checkIcon.image = UIImage(named: "talkpick_noncheck")
        checkIcon.tag = 100
        
        let badgeView = UIView()
        badgeView.backgroundColor = (type == "필수") ? .purple50 : .clear
        badgeView.layer.cornerRadius = 8
        badgeView.layer.borderWidth = 1
        badgeView.layer.borderColor = (type == "필수") ? UIColor.clear.cgColor : UIColor.gray100.cgColor
        
        let badgeLabel = UILabel()
        badgeLabel.text = type
        badgeLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        badgeLabel.textColor = (type == "필수") ? .purple100 : .gray
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 14)
        
        let arrowIcon = UIImageView()
        arrowIcon.image = UIImage(named: "talkpick_more")
        
        container.addSubview(checkIcon)
        container.addSubview(badgeView)
        badgeView.addSubview(badgeLabel)
        container.addSubview(titleLabel)
        container.addSubview(arrowIcon)
        
        checkIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(18)
        }
        
        badgeView.snp.makeConstraints {
            $0.leading.equalTo(checkIcon.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(18)
        }
        
        badgeLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(6)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(badgeView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        arrowIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(18)
        }
        
        container.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        return container
    }
    
    private func updateUI() {
        updateCheckIcon(allAgreeCheck, isOn: allAgree)
        updateCheckIcon(ageCheckIcon, isOn: agreeAge)

        updateCheckIcon(checkIcon(in: row1)!, isOn: agree1)
        updateCheckIcon(checkIcon(in: row2)!, isOn: agree2)
        updateCheckIcon(checkIcon(in: row3)!, isOn: agree3)
        updateCheckIcon(checkIcon(in: row4)!, isOn: agreeOptional)

        // 전체동의 상태 갱신
        allAgree = agree1 && agree2 && agree3 && agreeOptional && agreeAge
        updateCheckIcon(allAgreeCheck, isOn: allAgree)

        // 필수 3개 + 만14세 모두 체크해야 활성화
        if agree1 && agree2 && agree3 && agreeAge{
            nextButton.isEnabled = true
            nextButton.backgroundColor = .black
            nextButton.setTitleColor(.white, for: .normal)
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .white
            nextButton.setTitleColor(.gray200, for: .normal)
            nextButton.layer.borderColor = UIColor.gray200.cgColor
            nextButton.layer.borderWidth = 1
        }
    }
    
    @objc private func didTapAllAgree() {
        let newState = !allAgree
        allAgree = newState
        agree1 = newState
        agree2 = newState
        agree3 = newState
        agreeOptional = newState
        agreeAge = newState
        updateUI()
    }

    @objc private func didTapRow1() {
        agree1.toggle()
        updateUI()
    }

    @objc private func didTapRow2() {
        agree2.toggle()
        updateUI()
    }

    @objc private func didTapRow3() {
        agree3.toggle()
        updateUI()
    }

    @objc private func didTapRow4() {
        agreeOptional.toggle()
        updateUI()
    }

    @objc private func didTapAgeCheck() {
        agreeAge.toggle()
        updateUI()
    }

    private func checkIcon(in row: UIView) -> UIImageView? {
        return row.viewWithTag(100) as? UIImageView
    }
    
    private func updateCheckIcon(_ icon: UIImageView, isOn: Bool) {
        icon.image = UIImage(named: isOn ? "talkpick_check" : "talkpick_noncheck")
    }
}
