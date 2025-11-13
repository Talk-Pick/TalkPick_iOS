//
//  TodayTopicCollectionViewCell.swift
//  TalkPick
//
//  Created by jaegu park on 10/4/25.
//

import UIKit
import SnapKit

class TodayTopicCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: TodayTopicCollectionViewCell.self)
    
    private let labelView: UIView = {
        let uv = UIView()
        uv.layer.cornerRadius = 12
        return uv
    }()
    
    private let labelLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 12, weight: .semibold)
        return lb
    }()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 2
        lb.font = .systemFont(ofSize: 16, weight: .bold)
        lb.textColor = .black
        return lb
    }()
    
    private let averageTalk: UILabel = {
        let lb = UILabel()
        lb.text = "평균 대화 시간"
        lb.font = .systemFont(ofSize: 10, weight: .medium)
        lb.textColor = .gray200
        return lb
    }()
    
    private let minuteLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 15, weight: .bold)
        lb.textColor = .gray200
        return lb
    }()
    
    private let selectCount: UILabel = {
        let lb = UILabel()
        lb.text = "선택된 횟수"
        lb.font = .systemFont(ofSize: 10, weight: .medium)
        lb.textColor = .gray200
        return lb
    }()
    
    private let countLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 15, weight: .bold)
        lb.textColor = .gray200
        return lb
    }()
    
    private let character: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_distance3"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUI()
    }
    
    private func setUI() {
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.gray50.cgColor
        contentView.clipsToBounds = false
        contentView.backgroundColor = .white
        
        layer.cornerRadius = 15
        layer.masksToBounds = false
        
        self.contentView.addSubview(labelView)
        labelView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(14)
            $0.height.equalTo(23)
        }
        
        self.labelView.addSubview(labelLabel)
        labelLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(14)
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(labelView.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(40)
        }
        
        self.contentView.addSubview(averageTalk)
        averageTalk.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.5)
            $0.leading.equalToSuperview().offset(14)
            $0.height.equalTo(14)
        }
        
        self.contentView.addSubview(minuteLabel)
        minuteLabel.snp.makeConstraints {
            $0.top.equalTo(averageTalk.snp.bottom).offset(3)
            $0.leading.equalToSuperview().offset(14)
            $0.height.equalTo(14)
        }
        
        self.contentView.addSubview(selectCount)
        selectCount.snp.makeConstraints {
            $0.top.equalTo(minuteLabel.snp.bottom).offset(3)
            $0.leading.equalToSuperview().offset(14)
            $0.height.equalTo(14)
        }
        
        self.contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints {
            $0.top.equalTo(selectCount.snp.bottom).offset(3)
            $0.leading.equalToSuperview().offset(14)
            $0.height.equalTo(14)
        }
        
        self.contentView.addSubview(character)
        character.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(14)
            $0.height.width.equalTo(88)
        }
    }
    
    func prepare(topic: Topic) {
        labelLabel.text = topic.category
        titleLabel.text = topic.title
        minuteLabel.text = String(topic.averageTalkTime) + "분"
        countLabel.text = String(topic.selectCount) + "개"
        
        if let style = categoryStyles[topic.category] {
            labelView.backgroundColor = style.bgColor
            labelLabel.textColor = style.textColor
            character.image = UIImage(named: style.imageName)
        } else {
            labelView.backgroundColor = .gray50
            labelLabel.textColor = .gray200
            character.image = UIImage(named: "talkpick_default")
        }
    }
}
