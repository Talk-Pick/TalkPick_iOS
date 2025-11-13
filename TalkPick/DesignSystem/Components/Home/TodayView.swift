//
//  TodayView.swift
//  TalkPick
//
//  Created by jaegu park on 10/4/25.
//

import UIKit
import SnapKit

class TodayView: UIView {
    
    let navigationbarView = NavigationBarView(title: "오늘의 톡픽")
    
    private let labelView1: UIView = {
        let uv = UIView()
        uv.backgroundColor = .yellow50
        uv.layer.cornerRadius = 12
        return uv
    }()
    
    private let labelLabel1: UILabel = {
        let lb = UILabel()
        lb.text = "그룹 첫 모임"
        lb.font = .systemFont(ofSize: 12, weight: .semibold)
        lb.textColor = .yellow100
        return lb
    }()
    
    private let labelView2: UIView = {
        let uv = UIView()
        uv.backgroundColor = .pink50
        uv.layer.cornerRadius = 12
        return uv
    }()
    
    private let labelLabel2: UILabel = {
        let lb = UILabel()
        lb.text = "첫 번째"
        lb.font = .systemFont(ofSize: 12, weight: .semibold)
        lb.textColor = .pink100
        return lb
    }()
    
    private let cardView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_bluecard"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let flipButton: UIButton = {
        let fb = UIButton(type: .custom)
        fb.setImage(UIImage(named: "talkpick_flip"), for: .normal)
        fb.setTitle("카드 뒤집기 ", for: .normal)
        fb.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        fb.setTitleColor(.gray200, for: .normal)
        fb.semanticContentAttribute = .forceRightToLeft
        return fb
    }()
    
    private let cancelButton: UIButton = {
        let cb = UIButton(type: .custom)
        cb.clipsToBounds = true
        cb.layer.cornerRadius = 12
        cb.layer.borderWidth = 1
        cb.layer.borderColor = UIColor.gray200.cgColor
        cb.backgroundColor = .white
        cb.setImage(UIImage(named: "talkpick_like")?.withRenderingMode(.alwaysOriginal), for: .normal)
        cb.setTitleColor(.gray200, for: .normal)
        cb.setTitle(" 좋아요", for: .normal)
        cb.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return cb
    }()
    
    private let nextButton: UIButton = {
        let nb = UIButton(type: .system)
        nb.clipsToBounds = true
        nb.layer.cornerRadius = 12
        nb.backgroundColor = .black
        nb.setTitleColor(.white, for: .normal)
        nb.setTitle("다음으로", for: .normal)
        nb.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return nb
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(cancelButton)
        sv.addArrangedSubview(nextButton)
        sv.axis = .horizontal
        sv.spacing = 17
        sv.distribution = .fillEqually
        return sv
    }()
    
    private var isFront: Bool = true {
        didSet {
            cardView.image = isFront ? UIImage(named: "talkpick_bluecard") : UIImage(named: "talkpick_character1")
        }
    }
    
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
        
        addSubview(labelView1)
        labelView1.addSubview(labelLabel1)
        addSubview(labelView2)
        labelView2.addSubview(labelLabel2)
        
        addSubview(cardView)
        addSubview(flipButton)
        addSubview(buttonStackView)
    }
    
    private func setupConstraints() {
        navigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        labelView1.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom).offset(54)
            $0.leading.equalToSuperview().offset(35)
            $0.height.equalTo(31)
        }
        
        labelLabel1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(14)
        }
        
        labelView2.snp.makeConstraints {
            $0.centerY.equalTo(labelView1)
            $0.leading.equalTo(labelView1.snp.trailing).offset(8)
            $0.height.equalTo(31)
        }
        
        labelLabel2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(14)
        }
        
        cardView.snp.makeConstraints {
            $0.top.equalTo(labelView1.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(442)
        }
        
        flipButton.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22)
            $0.width.equalTo(90)
        }
        flipButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(flipButton.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(51)
        }
    }
    
    @objc func buttonTapped() {
        if isFront {
            isFront = false
            UIView.transition(with: cardView,
                              duration: 0.5,
                              options: .transitionFlipFromLeft,
                              animations: nil,
                              completion: nil)
            
        } else {
            isFront = true
            UIView.transition(with: cardView,
                              duration: 0.5,
                              options: .transitionFlipFromRight,
                              animations: nil,
                              completion: nil)
        }
    }
}
