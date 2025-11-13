//
//  RelationshipButton.swift
//  TalkPick
//
//  Created by jaegu park on 10/8/25.
//

import UIKit
import SnapKit

final class RelationshipButton: UIControl {

    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.12) {
                self.alpha = self.isHighlighted ? 0.85 : 1.0
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            }
        }
    }
    
    init(image: UIImage?, title: String) {
        super.init(frame: .zero)
        setupView(image: image, title: title)
        isAccessibilityElement = true
        accessibilityLabel = title
        accessibilityTraits = .button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(image: UIImage?, title: String) {
        backgroundColor = .gray50
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 6
        layer.shadowOffset = .zero
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.textColor = .gray200
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.isUserInteractionEnabled = false
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 95, height: 91))
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(23)
            $0.centerX.equalToSuperview()
        }
    }
}
