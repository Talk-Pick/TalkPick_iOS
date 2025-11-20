//
//  HomeView.swift
//  TalkPick
//
//  Created by jaegu park on 10/4/25.
//

import UIKit
import SnapKit

class HomeView: UIView {
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentInsetAdjustmentBehavior = .never
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView = UIView()
    
    private let mainLogo: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_homeLogo"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let mainLabel: UILabel = {
        let lb = UILabel()
        lb.text = "어색한 분위기를 풀고싶을때\n대화가 필요할때 톡픽!"
        lb.numberOfLines = 2
        lb.font = .systemFont(ofSize: 13, weight: .bold)
        lb.textColor = .black
        lb.textAlignment = .center
        return lb
    }()
    
    private let todayLabel: UILabel = {
        let lb = UILabel()
        lb.text = "오늘의 톡픽"
        lb.font = .systemFont(ofSize: 22, weight: .heavy)
        lb.textColor = .black
        return lb
    }()
    
    let todayTopicCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TodayTopicCollectionViewCell.self, forCellWithReuseIdentifier: TodayTopicCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private let randomLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 2
        lb.text = "오늘은 어떤 대화가 나올까?\n랜덤 코스 시작!"
        lb.font = .systemFont(ofSize: 22, weight: .heavy)
        lb.textColor = .black
        return lb
    }()
    
    private let randomView: UIView = {
        let rv = UIView()
        rv.backgroundColor = .gray50
        return rv
    }()
    
    private let topicLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 2
        lb.text = "랜덤 대화 코스로\n고민 없이 대화를 시작해요"
        lb.font = .systemFont(ofSize: 20, weight: .heavy)
        lb.textColor = .gray200
        return lb
    }()
    
    private let character: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_character1"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let topic: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_topic"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let startButton: UIButton = {
        let sb = UIButton(type: .system)
        sb.clipsToBounds = true
        sb.layer.cornerRadius = 12
        sb.layer.borderWidth = 1
        sb.layer.borderColor = UIColor.gray200.cgColor
        sb.backgroundColor = .white
        sb.setTitleColor(.gray200, for: .normal)
        sb.setTitle("시작하기", for: .normal)
        sb.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return sb
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
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(mainLogo)
        contentView.addSubview(mainLabel)
        
        contentView.addSubview(todayLabel)
        contentView.addSubview(todayTopicCollectionView)
        contentView.addSubview(randomLabel)
        contentView.addSubview(randomView)
        
        randomView.addSubview(topicLabel)
        randomView.addSubview(character)
        randomView.addSubview(topic)
        
        contentView.addSubview(startButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(startButton.snp.bottom).offset(105)
        }
        
        mainLogo.snp.makeConstraints {
            $0.top.equalToSuperview().offset(76)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(115)
            $0.width.equalTo(228)
        }
        
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(mainLogo.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        todayLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(27)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(24)
        }
        
        todayTopicCollectionView.snp.makeConstraints {
            $0.top.equalTo(todayLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(228)
        }
        
        randomLabel.snp.makeConstraints {
            $0.top.equalTo(todayTopicCollectionView.snp.bottom).offset(2)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(53)
            $0.width.equalTo(256)
        }
        
        randomView.snp.makeConstraints {
            $0.top.equalTo(randomLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(237)
        }
        
        topicLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(23)
            $0.height.equalTo(80)
            $0.width.equalTo(250)
        }
        
        character.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(-15)
            $0.height.width.equalTo(200)
        }
        
        topic.snp.makeConstraints {
            $0.top.equalTo(topicLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(23)
            $0.height.equalTo(113)
            $0.width.equalTo(274)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(randomView.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(88.5)
            $0.height.equalTo(51)
        }
    }
}
