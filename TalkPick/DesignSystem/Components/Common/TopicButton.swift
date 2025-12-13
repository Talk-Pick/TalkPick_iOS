//
//  TopicButton.swift
//  TalkPick
//
//  Created by jaegu park on 10/14/25.
//

import UIKit
import SnapKit
import Kingfisher

final class TopicButton: UIControl {
    
    private let labelView = UIView()
    private let labelLabel = UILabel()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.08) {
                self.alpha = self.isHighlighted ? 0.85 : 1.0
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            }
        }
    }
    
    init(color: UIColor, labelTitle: String, textColor: UIColor, image: String, title: String) {
        super.init(frame: .zero)
        setupView(color: color, labelTitle: labelTitle, textColor: textColor, image: image, title: title)
        isAccessibilityElement = true
        accessibilityLabel = labelTitle
        accessibilityLabel = title
        accessibilityTraits = .button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(color: UIColor, labelTitle: String, textColor: UIColor, image: String, title: String) {
        backgroundColor = .gray50
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 6
        layer.shadowOffset = .zero
        
        labelView.backgroundColor = color
        labelView.layer.cornerRadius = 15
        labelView.isUserInteractionEnabled = false
        
        labelLabel.text = labelTitle
        labelLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        labelLabel.textColor = textColor
        labelLabel.isUserInteractionEnabled = false
        
        let url = URL(string: image)
        imageView.kf.setImage(with: url)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        
        titleLabel.text = title
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        titleLabel.textColor = .gray200
        titleLabel.textAlignment = .center
        titleLabel.isUserInteractionEnabled = false
        
        addSubview(labelView)
        labelView.addSubview(labelLabel)
        addSubview(imageView)
        addSubview(titleLabel)
        
        labelView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(31)
        }
        labelLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(14)
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(labelView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 95, height: 91))
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(13.5)
            $0.centerX.equalToSuperview()
        }
    }
}
