
import UIKit
import SnapKit

final class SituationButton: UIControl {
    
    private let contentView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
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
    
    init(color: UIColor, title: String, textColor: UIColor, image: UIImage?) {
        super.init(frame: .zero)
        setupView(color: color, title: title, textColor: textColor, image: image)
        isAccessibilityElement = true
        accessibilityLabel = title
        accessibilityTraits = .button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(color: UIColor, title: String, textColor: UIColor, image: UIImage?) {
        backgroundColor = color
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 4)
        
        contentView.backgroundColor = .gray50
        contentView.layer.cornerRadius = 17
        contentView.isUserInteractionEnabled = false
        
        iconImageView.image = image
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.isUserInteractionEnabled = false
        
        titleLabel.text = title
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = textColor
        titleLabel.textAlignment = .center
        titleLabel.isUserInteractionEnabled = false
        
        addSubview(contentView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(6)
        }
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 56, height: 47))
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(17)
            $0.centerX.equalToSuperview()
        }
    }
}
