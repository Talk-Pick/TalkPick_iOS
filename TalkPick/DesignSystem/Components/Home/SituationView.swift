//
//  SituationView.swift
//  TalkPick
//
//  Created by jaegu park on 11/4/25.
//

import UIKit
import SnapKit

class SituationView: UIView {
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "현재 어떤 상황이신가요?"
        lb.font = .systemFont(ofSize: 22, weight: .heavy)
        lb.textColor = .black
        return lb
    }()
    
    private let closeButton = RelationshipButton(image: UIImage(named: "talkpick_distance1"), title: "가까운 사이")
    private let firstMetButton = RelationshipButton(image: UIImage(named: "talkpick_distance2"), title: "처음 본 사이")
    
    private let cardStack: UIStackView = {
        let uv = UIStackView()
        uv.axis = .vertical
        uv.spacing = 30
        uv.alignment = .center
        return uv
    }()
    
    enum UIState {
        case pickRelationship, pickSituation
    }
    enum SituationKind: Int {
        case dating, firstGroup, firstRoommate, icebreak, family, friend, lover, coworker
    }
    private var state: UIState = .pickRelationship {
        didSet { apply(state, animated: true) }
    }
    private var history: [UIState] = []
    private var selectedRelationship: Bool? // true: 가까운 사이, false: 처음 본 사이
    
    var canGoBack: Bool {
        return !history.isEmpty
    }
    
    var onRelationshipPicked: ((Bool) -> Void)?
    var onSituationSelected: ((SituationKind) -> Void)?
    var onForwardStep: (() -> Void)?
    var onBackwardStep: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setupConstraints()
        wireActions()
        apply(.pickRelationship, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(firstMetButton)
        addSubview(cardStack)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(209)
            $0.width.equalTo(164)
        }
        closeButton.isHidden = false
        closeButton.alpha = 1
        
        firstMetButton.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(209)
            $0.width.equalTo(164)
        }
        firstMetButton.isHidden = false
        firstMetButton.alpha = 1
        
        cardStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(80)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        cardStack.isHidden = true
        cardStack.alpha = 0
    }
    
    private func setupCardStack(isClose: Bool) {
        // 기존 카드 제거
        cardStack.arrangedSubviews.forEach {
            cardStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        if isClose {
            let row1 = makeRow([
                (.purple50, "가족", .purple100, "talkpick_situation5", .family),
                (.orange50, "친구", .orange100, "talkpick_situation6", .friend)
            ])
            let row2 = makeRow([
                (.pink10, "연인", .pink30, "talkpick_situation7", .lover),
                (.blue50, "동료", .blue100, "talkpick_situation8", .coworker)
            ])
            [row1, row2].forEach { cardStack.addArrangedSubview($0) }
        } else {
            let row1 = makeRow([
                (.pink50, "소개팅/과팅", .pink100, "talkpick_situation1", .dating),
                (.yellow50, "그룹 첫 모임", .yellow100, "talkpick_situation2", .firstGroup)
            ])
            let row2 = makeRow([
                (.green50, "룸메 첫 만남", .green100 , "talkpick_situation3", .firstRoommate),
                (.blue10, "기타/\n아이스브레이킹", .blue30, "talkpick_situation4", .icebreak)
            ])
            [row1, row2].forEach { cardStack.addArrangedSubview($0) }
        }
    }
    
    private func makeRow(_ items: [(UIColor, String, UIColor, String, SituationKind)]) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 40
        stack.distribution = .fillEqually
        stack.alignment = .center
        
        for (color, title, textColor, image, kind) in items {
            let card = SituationButton(color: color, title: title, textColor: textColor, image: UIImage(named: image))
            card.tag = kind.rawValue  // 어떤 카드인지 식별
            card.addTarget(self, action: #selector(tapSituation(_:)), for: .touchUpInside)
            card.snp.makeConstraints {
                $0.width.equalTo(120)
                $0.height.equalTo(161)
            }
            stack.addArrangedSubview(card)
        }
        
        return stack
    }
    
    @objc private func tapSituation(_ sender: UIControl) {
        guard let kind = SituationKind(rawValue: sender.tag) else { return }
        onSituationSelected?(kind)  // 부모 VC로 이벤트 전달
    }
    
    private func goForward(to next: UIState) {
        history.append(state)
        state = next
    }
    
    @objc func goBack() {
        guard let prev = history.popLast() else { return }
        selectedRelationship = nil
        // 카드 스택 초기화
        cardStack.arrangedSubviews.forEach {
            cardStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        if state == .pickSituation && prev == .pickRelationship {
            onBackwardStep?()
        }
        state = prev
    }
    
    private func wireActions() {
        closeButton.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        firstMetButton.addTarget(self, action: #selector(tapFirstMet), for: .touchUpInside)
    }
    
    @objc private func tapClose() {
        selectedRelationship = true
        onRelationshipPicked?(true)
        setupCardStack(isClose: true)
        goForward(to: .pickSituation)
        onForwardStep?()
    }
    
    @objc private func tapFirstMet() {
        selectedRelationship = false
        onRelationshipPicked?(false)
        setupCardStack(isClose: false)
        goForward(to: .pickSituation)
        onForwardStep?()
    }
    
    private func apply(_ state: UIState, animated: Bool) {
        switch state {
        case .pickRelationship:
            titleLabel.text = "현재 어떤 상황이신가요?"
            setButtonsVisible(true, animated: animated)
            setCardStackVisible(false, animated: animated)
            
        case .pickSituation:
            titleLabel.text = "현재 어떤 상황이신가요?"
            setButtonsVisible(false, animated: animated)
            setCardStackVisible(true, animated: animated)
        }
    }
    
    private func setButtonsVisible(_ show: Bool, animated: Bool) {
        let change = {
            self.closeButton.isHidden = !show
            self.firstMetButton.isHidden = !show
            self.closeButton.alpha = show ? 1 : 0
            self.firstMetButton.alpha = show ? 1 : 0
        }
        animated ? UIView.animate(withDuration: 0.25, animations: change) : change()
    }
    
    private func setCardStackVisible(_ show: Bool, animated: Bool) {
        let change = {
            self.cardStack.isHidden = !show
            self.cardStack.alpha = show ? 1 : 0
        }
        animated ? UIView.animate(withDuration: 0.25, animations: change) : change()
    }
}

extension SituationView.SituationKind {
    var koreanTitle: String {
        switch self {
        case .dating:        return "소개팅/과팅"
        case .firstGroup:    return "그룹 첫 모임"
        case .firstRoommate: return "룸메 첫 만남"
        case .icebreak:      return "기타/아이스브레이킹"
        case .family:        return "가족"
        case .friend:        return "친구"
        case .lover:         return "연인"
        case .coworker:      return "동료"
        }
    }
}
