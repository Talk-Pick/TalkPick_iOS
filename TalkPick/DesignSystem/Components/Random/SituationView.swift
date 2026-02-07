
import UIKit
import SnapKit
import RxSwift
import SkeletonView

class SituationView: UIView {
    
    private let topicViewModel = TopicViewModel()
    private let disposeBag = DisposeBag()
    
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
    
    var onSituationSelected: ((String) -> Void)?
    
    private let cardSkeletonView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.isHidden = true
        return v
    }()
    
    private let skeletonCard1: UIView = {
        let v = UIView()
        v.backgroundColor = .gray50
        v.layer.cornerRadius = 10
        return v
    }()
    
    private let skeletonCard2: UIView = {
        let v = UIView()
        v.backgroundColor = .gray50
        v.layer.cornerRadius = 10
        return v
    }()
    
    private var lastCalculatedWidth: CGFloat = 0
    private var categories: [Category] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setupConstraints()
        bindViewModel()
        fetchCategories()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(cardStack)
        addSubview(cardSkeletonView)
        cardSkeletonView.addSubview(skeletonCard1)
        cardSkeletonView.addSubview(skeletonCard2)
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
        
        cardSkeletonView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(56)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(350)
        }
        
        skeletonCard1.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(161)
        }
        
        skeletonCard2.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(skeletonCard1.snp.trailing).offset(20)
            $0.width.equalTo(100)
            $0.height.equalTo(161)
        }
        
        cardSkeletonView.isSkeletonable = true
        skeletonCard1.isSkeletonable = true
        skeletonCard2.isSkeletonable = true
    }
    
    func showCardSkeleton() {
        cardSkeletonView.isHidden = false
        cardSkeletonView.showAnimatedSkeleton()
    }
    
    func hideCardSkeleton() {
        cardSkeletonView.hideSkeleton()
        cardSkeletonView.isHidden = true
    }
    
    private func bindViewModel() {
        topicViewModel.categories
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] categories in
                guard let self = self else { return }
                self.hideCardSkeleton()
                self.categories = categories
                self.setupCardStack()
            })
            .disposed(by: disposeBag)
        
        topicViewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.hideCardSkeleton()
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchCategories() {
        showCardSkeleton()
        topicViewModel.getCategories()
    }
    
    private func setupCardStack() {
        // 기존 카드 제거
        cardStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard !categories.isEmpty else { return }
        
        // 카드 개수에 따라 열당 카드 수 결정
        // 6개 이하: 한 열에 2개씩
        // 7개 이상: 한 열에 3개씩
        let chunkSize = categories.count <= 6 ? 2 : 3
        // 2개씩 배치할 때는 간격을 더 넓게 설정
        let spacing: CGFloat = chunkSize == 2 ? 50 : 20
        var rows: [UIView] = []
        
        for i in stride(from: 0, to: categories.count, by: chunkSize) {
            let endIndex = min(i + chunkSize, categories.count)
            let chunk = Array(categories[i..<endIndex])
            let row = makeRow(from: chunk, startIndex: i, spacing: spacing)
            rows.append(row)
        }
        
        rows.forEach { row in
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
        
        // 각 row의 실제 spacing을 가져와서 계산
        cardStack.arrangedSubviews.forEach { rowContainer in
            if let rowStack = rowContainer.subviews.first as? UIStackView {
                let cardCount = rowStack.arrangedSubviews.count
                let rowSpacing = rowStack.spacing
                let totalSpacing = rowSpacing * CGFloat(cardCount - 1)
                let cardWidth = (availableWidth - totalSpacing) / CGFloat(cardCount)
                
                rowStack.arrangedSubviews.forEach { card in
                    if let card = card as? SituationButton {
                        card.snp.updateConstraints {
                            $0.width.equalTo(cardWidth)
                        }
                    }
                }
                
                let contentWidth = cardWidth * CGFloat(cardCount) + totalSpacing
                rowStack.snp.updateConstraints {
                    $0.width.equalTo(contentWidth)
                }
            }
        }
    }
    
    private func makeRow(from categories: [Category], startIndex: Int, spacing: CGFloat) -> UIView {
        let containerView = UIView()
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = spacing
        stack.distribution = .fill
        stack.alignment = .center
        
        containerView.addSubview(stack)
        
        // 초기 카드 너비 (나중에 layoutSubviews에서 업데이트됨)
        let initialCardWidth: CGFloat = 100
        let totalCardWidth = initialCardWidth * CGFloat(categories.count)
        let totalSpacing = spacing * CGFloat(categories.count - 1)
        let contentWidth = totalCardWidth + totalSpacing
        
        // 카드들 생성
        for (index, category) in categories.enumerated() {
            let globalIndex = startIndex + index
            let style = categoryStyles[category.title]
            let bgColor = style?.bgColor ?? .gray50
            let textColor = style?.textColor ?? .gray100
            
            let card = SituationButton(
                color: bgColor,
                title: category.title,
                textColor: textColor,
                imageUrl: category.imageUrl
            )
            card.tag = globalIndex  // categoryId를 tag로 사용
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
        let index = sender.tag
        guard index < categories.count else { return }
        let category = categories[index]
        
        // Category.title을 직접 전달
        onSituationSelected?(category.title)
    }
}