//
//  FinishView.swift
//  TalkPick
//
//  Created by jaegu park on 12/5/25.
//

import UIKit
import SnapKit

class FinishView: UIView {
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "랜덤 대화 코스가 종료되었습니다!"
        lb.font = .systemFont(ofSize: 22, weight: .heavy)
        lb.textColor = .black
        return lb
    }()
    
    private let finishImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_finish"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "대화 주제가 마음에 드셨나요?"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "별점을 눌러 평가해주세요."
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray100
        label.textAlignment = .center
        return label
    }()
    
    private let starsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var starButtons: [UIButton] = []
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("한줄평 남기기", for: .normal)
        button.setTitleColor(.gray200, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray200.cgColor
        button.backgroundColor = .clear
        return button
    }()
    
    private(set) var rating: Int = 0 {
        didSet {
            updateStars()
            onRatingChanged?(rating)
        }
    }
    
    var onRatingChanged: ((Int) -> Void)?
    var onSubmit: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupStars()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(finishImageView)
        addSubview(questionLabel)
        addSubview(subLabel)
        addSubview(starsStackView)
        addSubview(submitButton)
        
        submitButton.addTarget(self,
                               action: #selector(submitTapped),
                               for: .touchUpInside)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(26)
        }
        
        finishImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(195)
        }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(finishImageView.snp.bottom).offset(43)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(9)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(14)
        }
        
        starsStackView.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(22)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        submitButton.snp.makeConstraints {
            $0.top.equalTo(starsStackView.snp.bottom).offset(73)
            $0.leading.trailing.equalToSuperview().inset(80)
            $0.height.equalTo(55)
        }
    }
    
    private func setupStars() {
        // 5개의 별 버튼 생성
        for i in 1...5 {
            let button = UIButton(type: .custom)
            button.tag = i
            button.setImage(UIImage(named: "talkpick_starOff"), for: .normal)
            button.setImage(UIImage(named: "talkpick_starOn"), for: .selected)
            button.addTarget(self,
                             action: #selector(starTapped(_:)),
                             for: .touchUpInside)
            
            starButtons.append(button)
            starsStackView.addArrangedSubview(button)
            
            button.snp.makeConstraints { make in
                make.width.height.equalTo(32)
            }
        }
        
        updateStars()
    }
    
    @objc private func starTapped(_ sender: UIButton) {
        rating = sender.tag
    }
    
    @objc private func submitTapped() {
        onSubmit?()
    }
    
    private func updateStars() {
        for button in starButtons {
            button.isSelected = button.tag <= rating
        }
    }
    
    func setInitialRating(_ value: Int) {
        rating = max(0, min(5, value))
    }
}
