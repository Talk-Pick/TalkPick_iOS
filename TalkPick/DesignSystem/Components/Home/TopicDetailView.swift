//
//  TopicDetailView.swift
//  TalkPick
//
//  Created by jaegu park on 12/5/25.
//

import UIKit
import SnapKit

class TopicDetailView: UIView {
    var onNext: (() -> Void)?
    var onLikeToggled: ((Bool) -> Void)?

    private let labelView1: UIView = {
        let uv = UIView()
        uv.backgroundColor = .yellow50
        uv.layer.cornerRadius = 15
        return uv
    }()
    
    let labelLabel1: UILabel = {
        let lb = UILabel()
        lb.text = "그룹 첫 모임"
        lb.font = .systemFont(ofSize: 12, weight: .semibold)
        lb.textColor = .yellow100
        return lb
    }()
    
    private let labelView2: UIView = {
        let uv = UIView()
        uv.backgroundColor = .pink50
        uv.layer.cornerRadius = 15
        return uv
    }()
    
    let stepLabel: UILabel = {
        let lb = UILabel()
        lb.text = "첫 번째"
        lb.font = .systemFont(ofSize: 12, weight: .semibold)
        lb.textColor = .pink100
        return lb
    }()
    
    let cardView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_bluecard"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let flipButton: UIButton = {
        let fb = UIButton(type: .custom)
        fb.setImage(UIImage(named: "talkpick_flip"), for: .normal)
        fb.setTitle("카드 뒤집기 ", for: .normal)
        fb.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        fb.setTitleColor(.gray100, for: .normal)
        fb.semanticContentAttribute = .forceRightToLeft
        return fb
    }()

    private let likeButton: UIButton = {
        let cb = UIButton(type: .custom)
        cb.clipsToBounds = true
        cb.layer.cornerRadius = 10
        cb.layer.borderWidth = 1
        cb.layer.borderColor = UIColor.gray200.cgColor
        cb.backgroundColor = .white
        cb.setImage(UIImage(named: "talkpick_like")?.withRenderingMode(.alwaysOriginal), for: .normal)
        cb.setTitleColor(.gray200, for: .normal)
        cb.setTitle(" 좋아요", for: .normal)
        cb.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return cb
    }()
    
    private lazy var nextButton: UIButton = {
        let cb = UIButton(type: .custom)
        cb.backgroundColor = .black
        cb.setTitleColor(.white, for: .normal)
        cb.setTitle("다음으로", for: .normal)
        cb.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        cb.layer.cornerRadius = 10
        cb.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return cb
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(likeButton)
        sv.addArrangedSubview(nextButton)
        sv.axis = .horizontal
        sv.spacing = 17
        sv.distribution = .fillEqually
        return sv
    }()

    var isFront: Bool = true
    private var isLiked = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        backgroundColor = .white

        addSubview(labelView1)
        labelView1.addSubview(labelLabel1)
        addSubview(labelView2)
        labelView2.addSubview(stepLabel)
        
        addSubview(cardView)
        addSubview(flipButton)
        addSubview(buttonsStack)
    }

    private func setupLayout() {
        
        labelView1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
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
        
        stepLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(14)
        }

        cardView.snp.makeConstraints {
            $0.top.equalTo(labelView1.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(450)
        }

        flipButton.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22)
            $0.width.equalTo(90)
        }
        flipButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        buttonsStack.snp.makeConstraints {
            $0.top.equalTo(flipButton.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(51)
        }
    }

    func configure(stepIndex: Int, topic: TopicModel) {
        let stepTitles = ["첫 번째 주제", "두 번째 주제", "세 번째 주제", "네 번째 주제"]
        stepLabel.text = stepTitles.indices.contains(stepIndex) ? stepTitles[stepIndex] : ""

        labelLabel1.text = topic.tagTitle
        cardView.image = UIImage(named: topic.imageName)
        
        print("Detail topic: id=\(topic.id), title=\(topic.tagTitle)")
    }

    @objc private func toggleLike() {
        isLiked.toggle()
        onLikeToggled?(isLiked)
    }

    @objc private func nextTapped() {
        onNext?()
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
