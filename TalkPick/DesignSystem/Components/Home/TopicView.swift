//
//  TopicView.swift
//  TalkPick
//
//  Created by jaegu park on 10/14/25.
//

import UIKit
import SnapKit

class TopicView: UIView {
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "첫 번째 주제"
        lb.font = .systemFont(ofSize: 22, weight: .heavy)
        lb.textColor = .black
        return lb
    }()
    
    private let cardStack: UIStackView = {
        let uv = UIStackView()
        uv.axis = .vertical
        uv.spacing = 20
        uv.alignment = .center
        return uv
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
        addSubview(titleLabel)
        addSubview(cardStack)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        cardStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(56)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        let row1 = makeRow([
            (.pink50, "#만약에", .pink100, "talkpick_distance1", "#만약에"),
            (.yellow50, "#연애", .yellow100, "talkpick_distance2", "MBTI 야구 게임")
        ])
        let row2 = makeRow([
            (.purple50, "#스포츠", .purple100, "talkpick_distance3", "MBTI 야구 게임"),
            (.orange50, "가족", .orange100, "talkpick_distance4", "MBTI 야구 게임")
        ])
        
        [row1, row2].forEach { cardStack.addArrangedSubview($0) }
    }
    
    private func makeRow(_ items: [(UIColor, String, UIColor, String, String)]) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 13
        stack.distribution = .fillEqually
        stack.alignment = .center
        
        for (color, labelTitle, textColor, image, title) in items {
            let card = TopicButton(color: color, labelTitle: labelTitle, textColor: textColor, image: UIImage(named: image), title: title)
            card.snp.makeConstraints {
                $0.width.equalTo(164)
                $0.height.equalTo(209)
            }
            stack.addArrangedSubview(card)
        }
        
        return stack
    }
}
