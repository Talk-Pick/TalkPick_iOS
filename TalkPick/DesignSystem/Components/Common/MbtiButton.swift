
import UIKit
import SnapKit

final class MbtiButton: UIControl {
    
    private let alphabetLabel = UILabel()
    private let titleLabel = UILabel()
    
    private let normalBG = UIColor.gray10
    private let normalAlphaColor = UIColor.gray200
    private let normalTitleColor = UIColor.gray100
    private let selectedBG = UIColor.purple50
    private let selectedAlphaColor = UIColor.black
    private let selectedTitleColor = UIColor.gray200
    
    override var isSelected: Bool {
        didSet { applyStyle() }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                // 햅틱 피드백 추가
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }
            
            UIView.animate(
                withDuration: 0.15,
                delay: 0,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0.8,
                options: [.allowUserInteraction, .beginFromCurrentState],
                animations: {
                    self.alpha = self.isHighlighted ? 0.8 : 1.0
                    self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.94, y: 0.94) : .identity
                    self.layer.shadowOpacity = self.isHighlighted ? 0.1 : 0.2
                }
            )
        }
    }
    
    init(mainTitle: String, subTitle: String) {
        super.init(frame: .zero)
        setupView(mainTitle: mainTitle, subTitle: subTitle)
        isAccessibilityElement = true
        accessibilityLabel = "\(mainTitle) \(subTitle)"
        accessibilityTraits = .button
        applyStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(mainTitle: String, subTitle: String) {
        backgroundColor = .gray10
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 6
        layer.shadowOffset = .zero
        
        alphabetLabel.text = mainTitle
        alphabetLabel.font = .systemFont(ofSize: 20, weight: .bold)
        alphabetLabel.textColor = .gray200
        alphabetLabel.isUserInteractionEnabled = false
        
        titleLabel.text = subTitle
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .gray100
        titleLabel.isUserInteractionEnabled = false
        
        addSubview(alphabetLabel)
        addSubview(titleLabel)
        
        alphabetLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(alphabetLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(14)
        }
    }
    
    private func applyStyle() {
        if isSelected {
            backgroundColor = selectedBG
            alphabetLabel.textColor = selectedAlphaColor
            titleLabel.textColor = selectedTitleColor
        } else {
            backgroundColor = normalBG
            alphabetLabel.textColor = normalAlphaColor
            titleLabel.textColor = normalTitleColor
        }
    }
}
