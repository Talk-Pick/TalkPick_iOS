//
//  RandomView.swift
//  TalkPick
//
//  Created by jaegu park on 10/8/25.
//

import UIKit
import SnapKit

class RandomView: UIView {
    
    let navigationbarView = NavigationBarView(title: "뒤로 가기")
    
    let situationView = SituationView()
    let topicView = TopicView()
    
    private let smallLogo: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_smallLogo"))
        iv.contentMode = .scaleAspectFit
        return iv
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
        addSubview(navigationbarView)
        addSubview(situationView)
        addSubview(smallLogo)
    }
    
    private func setupConstraints() {
        navigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        smallLogo.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(25)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(33)
            $0.width.equalTo(111)
        }
        
        situationView.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(smallLogo.snp.top)
        }
    }
}
