//
//  RandomNavigationBarView.swift
//  TalkPick
//
//  Created by jaegu park on 12/5/25.
//

import UIKit
import SnapKit

protocol RandomNavigationBarViewDelegate: AnyObject {
    func tapBackButton()
}

final class RandomNavigationBarView: UIView {
    
    let backButton: UIButton = {
        let bb = UIButton()
        bb.setImage(UIImage(named: "talkpick_back"), for: .normal)
        return bb
    }()
    private var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 17, weight: .bold)
        return lb
    }()
    let homeButton: UIButton = {
        let hb = UIButton()
        hb.setImage(UIImage(named: "talkpick_home"), for: .normal)
        return hb
    }()
    
    weak var delegate: RandomNavigationBarViewDelegate?
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        backgroundColor = .white
        
        addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.leading.equalTo(backButton.snp.trailing).offset(3)
            $0.height.equalTo(19)
        }
        
        addSubview(homeButton)
        homeButton.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(32)
        }
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        delegate?.tapBackButton()
    }
}
