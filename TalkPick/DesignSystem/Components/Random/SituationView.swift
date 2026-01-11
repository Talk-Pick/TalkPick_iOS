
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
    
    private let cardStack: UIStackView = {
        let uv = UIStackView()
        uv.axis = .vertical
        uv.spacing = 30
        uv.alignment = .center
        return uv
    }()
    
    enum SituationKind: Int {
        case dating, firstGroup, firstRoommate, icebreak, family, friend, lover, coworker
    }
    
    var onSituationSelected: ((SituationKind) -> Void)?
    
    private var lastCalculatedWidth: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setupConstraints()
        setupCardStack()
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
            $0.top.equalToSuperview().offset(28)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        cardStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(56)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func setupCardStack() {
        // 모든 상황 카드를 표시
        let row1 = makeRow([
            (.pink50, "소개팅/과팅", .pink100, "talkpick_situation1", .dating),
            (.yellow50, "그룹 첫 모임", .yellow100, "talkpick_situation2", .firstGroup),
            (.green50, "룸메 첫 만남", .green100 , "talkpick_situation3", .firstRoommate)
        ])
        let row2 = makeRow([
            (.blue10, "기타/\n아이스브레이킹", .blue30, "talkpick_situation4", .icebreak),
            (.purple50, "가족", .purple100, "talkpick_situation5", .family),
            (.orange50, "친구", .orange100, "talkpick_situation6", .friend)
        ])
        let row3 = makeRow([
            (.pink10, "연인", .pink30, "talkpick_situation7", .lover),
            (.blue50, "동료", .blue100, "talkpick_situation8", .coworker)
        ])
        
        [row1, row2, row3].forEach { row in
            cardStack.addArrangedSubview(row)
            row.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(161)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // cardStack의 실제 너비 계산 (좌우 inset 24씩 포함된 상태)
        let availableWidth = cardStack.bounds.width
        guard availableWidth > 0, abs(availableWidth - lastCalculatedWidth) > 1 else { return }
        lastCalculatedWidth = availableWidth
        
        // 각 row의 카드들에 동일한 너비 적용 (가장 많은 카드를 가진 row 기준)
        var maxCardCount = 0
        cardStack.arrangedSubviews.forEach { rowContainer in
            if let rowStack = rowContainer.subviews.first as? UIStackView {
                maxCardCount = max(maxCardCount, rowStack.arrangedSubviews.count)
            }
        }
        
        // 가장 많은 카드를 가진 row 기준으로 카드 너비 계산
        let spacing: CGFloat = 20
        let totalSpacing = spacing * CGFloat(maxCardCount - 1)
        let cardWidth = (availableWidth - totalSpacing) / CGFloat(maxCardCount)
        
        // 모든 row의 카드에 동일한 너비 적용
        cardStack.arrangedSubviews.forEach { rowContainer in
            if let rowStack = rowContainer.subviews.first as? UIStackView {
                rowStack.arrangedSubviews.forEach { card in
                    if let card = card as? SituationButton {
                        card.snp.updateConstraints {
                            $0.width.equalTo(cardWidth)
                        }
                    }
                }
                
                let cardCount = rowStack.arrangedSubviews.count
                let rowTotalSpacing = spacing * CGFloat(cardCount - 1)
                let contentWidth = cardWidth * CGFloat(cardCount) + rowTotalSpacing
                rowStack.snp.updateConstraints {
                    $0.width.equalTo(contentWidth)
                }
            }
        }
    }
    
    private func makeRow(_ items: [(UIColor, String, UIColor, String, SituationKind)]) -> UIView {
        let containerView = UIView()
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fill
        stack.alignment = .center
        
        containerView.addSubview(stack)
        
        // 초기 카드 너비 (나중에 layoutSubviews에서 업데이트됨)
        let initialCardWidth: CGFloat = 100
        let spacing: CGFloat = 20
        let totalCardWidth = initialCardWidth * CGFloat(items.count)
        let totalSpacing = spacing * CGFloat(items.count - 1)
        let contentWidth = totalCardWidth + totalSpacing
        
        // 카드들 생성
        for (color, title, textColor, image, kind) in items {
            let card = SituationButton(color: color, title: title, textColor: textColor, image: UIImage(named: image))
            card.tag = kind.rawValue  // 어떤 카드인지 식별
            card.addTarget(self, action: #selector(tapSituation(_:)), for: .touchUpInside)
            
            // 초기 너비와 높이 제약
            card.snp.makeConstraints {
                $0.width.equalTo(initialCardWidth).priority(.required)
                $0.height.equalTo(161).priority(.required)
            }
            
            // 카드가 확장되지 않도록 priority 설정
            card.setContentHuggingPriority(.required, for: .horizontal)
            card.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            stack.addArrangedSubview(card)
        }
        
        // StackView를 containerView 중앙에 배치
        stack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(contentWidth).priority(.required)
        }
        
        return containerView
    }
    
    @objc private func tapSituation(_ sender: UIControl) {
        guard let kind = SituationKind(rawValue: sender.tag) else { return }
        onSituationSelected?(kind)  // 부모 VC로 이벤트 전달
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
