//
//  TopicView.swift
//  TalkPick
//
//  Created by jaegu park on 10/14/25.
//

import UIKit
import SnapKit

class TopicView: UIView {
    
    var onTopicSelected: ((TopicModel) -> Void)?

    private var topics: [TopicModel] = []
    
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
    }
    
    private func makeRow(_ items: [TopicModel], startIndex: Int) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 13
        stack.distribution = .fillEqually
        stack.alignment = .center
        
        for (offset, item) in items.enumerated() {
            let card = TopicButton(
                color: item.keywordColor,
                labelTitle: item.keyword,
                textColor: item.categoryColor,
                image: item.imageName,
                title: item.category
            )
            
            // 전체 topics 배열에서의 인덱스
            card.tag = startIndex + offset
            card.addTarget(self, action: #selector(tapTopic(_:)), for: .touchUpInside)
            
            card.snp.makeConstraints {
                $0.width.equalTo(164)
                $0.height.equalTo(209)
            }
            
            stack.addArrangedSubview(card)
        }
        
        return stack
    }
    
    func configure(stepIndex: Int, topics: [TopicModel]) {
        let titles = ["첫 번째 주제", "두 번째 주제", "세 번째 주제", "네 번째 주제"]
        titleLabel.text = titles.indices.contains(stepIndex) ? titles[stepIndex] : ""
        self.topics = topics
        rebuildStack()
    }
    
    private func rebuildStack() {
        cardStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // topics 배열을 2개씩 잘라서 row 만들기
        let rows = stride(from: 0, to: topics.count, by: 2).map {
            Array(topics[$0..<min($0+2, topics.count)])
        }
        
        var globalIndex = 0
        for rowTopics in rows {
            let rowStack = makeRow(rowTopics, startIndex: globalIndex)
            globalIndex += rowTopics.count
            cardStack.addArrangedSubview(rowStack)
        }
    }
    
    @objc private func tapTopic(_ sender: UIControl) {
        let index = sender.tag
        guard topics.indices.contains(index) else { return }
        onTopicSelected?(topics[index])
    }
}
