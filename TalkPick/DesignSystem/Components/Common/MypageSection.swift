//
//  MypageSection.swift
//  TalkPick
//
//  Created by jaegu park on 10/29/25.
//

import UIKit
import SnapKit

final class SeparatorView: UIView {
    init(height: CGFloat = 1.2, color: UIColor = .lightGray.withAlphaComponent(0.4)) {
        super.init(frame: .zero)
        backgroundColor = color
        snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// 왼쪽 아이콘 + 타이틀 레이블 묶는 뷰
final class IconTitleRowView: UIView {
    let iconView = UIImageView()
    let titleLabel = UILabel()
    
    init(systemIconName: String, title: String) {
        super.init(frame: .zero)
        
        iconView.image = UIImage(named: systemIconName)
        
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .gray200
        
        addSubview(iconView)
        addSubview(titleLabel)
        
        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(14)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

final class SectionView: UIView {
    
    enum RowType {
        case info(icon: String, title: String, value: String)
    }
    
    private let titleLabel = UILabel()
    private let topSeparator = SeparatorView()
    private let stackView = UIStackView()
    let actionButton = UIButton(type: .custom)
    
    private(set) var rows: [RowType]
    
    init(title: String, rows: [RowType]) {
        self.rows = rows
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 19, weight: .heavy)
        titleLabel.textColor = .black
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        actionButton.setImage(UIImage(named: "talkpick_more"), for: .normal)
        actionButton.setTitle("변경하기", for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        actionButton.setTitleColor(.gray200, for: .normal)
        actionButton.semanticContentAttribute = .forceRightToLeft
        
        addSubview(titleLabel)
        addSubview(topSeparator)
        addSubview(stackView)
        addSubview(actionButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        topSeparator.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(topSeparator.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        actionButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(66)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview()
        }
        
        // row 하나씩 만들어 붙이기
        rows.forEach { row in
            switch row {
            case let .info(icon, title, value):
                let rowView = InfoRowView(
                    systemIconName: icon,
                    title: title,
                    value: value
                )
                stackView.addArrangedSubview(rowView)
            }
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension SectionView {
    func value(for title: String) -> String? {
        for row in rows {
            if case let .info(_, t, v) = row, t == title {
                return v
            }
        }
        return nil
    }
    
    func updateValue(for title: String, to newValue: String) {
        guard let index = rows.firstIndex(where: {
            if case .info(_, let t, _) = $0 { return t == title } else { return false }
        }) else { return }
        
        // RowType 수정
        if case let .info(icon, t, _) = rows[index] {
            rows[index] = .info(icon: icon, title: t, value: newValue)
        }
        
        // UIStackView의 InfoRowView도 같이 업데이트
        if let rowView = stackView.arrangedSubviews[index] as? InfoRowView {
            rowView.updateValue(newValue)
        }
    }
}

// 왼쪽 아이콘 + 제목, 오른쪽 값(또는 파란 텍스트) + optional '>' 터치 가능
final class InfoRowView: UIView {
    private let valueLabelRight = UILabel()
    private let chevron = UIImageView()
    
    init(systemIconName: String, title: String, value: String) {
        super.init(frame: .zero)
        
        let leftView = IconTitleRowView(systemIconName: systemIconName, title: title)
        addSubview(leftView)
        
        valueLabelRight.text = value
        valueLabelRight.font = .systemFont(ofSize: 14, weight: .medium)
        valueLabelRight.textColor = .purple100
        
        addSubview(valueLabelRight)
        
        self.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        
        leftView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        valueLabelRight.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    func updateValue(_ newValue: String) {
        valueLabelRight.text = newValue
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

final class CollectionSectionView: UIView {
    
    private let titleLabel = UILabel()
    private let topSeparator = SeparatorView()
    private let rowContainer = UIView()
    
    private let leftIcon = UIImageView()
    private let itemLabel = UILabel()
    let moreButton = UIButton(type: .custom)
    
    init(title: String, itemTitle: String, moreText: String) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 19, weight: .heavy)
        titleLabel.textColor = .black
        
        leftIcon.image = UIImage(named: "talkpick_like")
        
        itemLabel.text = itemTitle
        itemLabel.font = .systemFont(ofSize: 16, weight: .medium)
        itemLabel.textColor = .gray200
        
        moreButton.setImage(UIImage(named: "talkpick_more"), for: .normal)
        moreButton.setTitle(moreText, for: .normal)
        moreButton.setTitleColor(.gray200, for: .normal)
        moreButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        moreButton.semanticContentAttribute = .forceRightToLeft
        
        addSubview(titleLabel)
        addSubview(topSeparator)
        addSubview(rowContainer)
        
        rowContainer.addSubview(leftIcon)
        rowContainer.addSubview(itemLabel)
        rowContainer.addSubview(moreButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        topSeparator.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        rowContainer.snp.makeConstraints {
            $0.top.equalTo(topSeparator.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview()
        }
        
        leftIcon.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        itemLabel.snp.makeConstraints {
            $0.leading.equalTo(leftIcon.snp.trailing).offset(14)
            $0.centerY.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

final class EtcSectionView: UIView {
    
    enum EtcRow {
        case arrowRow(icon: String, title: String)
    }
    
    private let titleLabel = UILabel()
    private let topSeparator = SeparatorView()
    private let stackView = UIStackView()
    
    init(rows: [EtcRow]) {
        super.init(frame: .zero)
        backgroundColor = .white
        
        titleLabel.text = "기타"
        titleLabel.font = .systemFont(ofSize: 19, weight: .heavy)
        titleLabel.textColor = .black
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        addSubview(titleLabel)
        addSubview(topSeparator)
        addSubview(stackView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        topSeparator.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(topSeparator.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview()
        }
        
        rows.forEach { row in
            switch row {
            case let .arrowRow(icon, title):
                let r = ArrowRowView(icon: icon, title: title)
                stackView.addArrangedSubview(r)
            }
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}


// 공지사항/문의 행: 왼쪽 아이콘+텍스트, 오른쪽 >
final class ArrowRowView: UIView {
    
    private let leftIcon = UIImageView()
    private let titleLabel = UILabel()
    private let chevron = UIImageView()
    
    init(icon: String, title: String) {
        super.init(frame: .zero)
        
        leftIcon.image = UIImage(named: icon)
        
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .gray200
        
        chevron.image = UIImage(named: "talkpick_more")
        
        addSubview(leftIcon)
        addSubview(titleLabel)
        addSubview(chevron)
        
        self.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        
        leftIcon.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        chevron.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(leftIcon.snp.trailing).offset(14)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

final class TodayTopicView: UIView {
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 2
        lb.font = .systemFont(ofSize: 15, weight: .bold)
        lb.textColor = .black
        lb.textAlignment = .center
        return lb
    }()
    
    private let actionButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("보러가기", for: .normal)
        bt.setTitleColor(.gray200, for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        bt.backgroundColor = .white
        bt.layer.cornerRadius = 10
        bt.layer.borderWidth = 1
        bt.layer.borderColor = UIColor.gray200.cgColor
        return bt
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .gray10
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 16
        
        addSubview(titleLabel)
        addSubview(actionButton)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview().inset(16)
        }
        
        actionButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(35)
            $0.width.equalTo(103)
        }
    }
}

final class NoLikeView: UIView {
    
    private let mainLogo: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_nolike"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "아직 좋아요 누른 주제가 없어요"
        lb.font = .systemFont(ofSize: 16, weight: .bold)
        lb.textColor = .black
        return lb
    }()
    
    private let subTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "지금 바로 좋아요 누르러 가볼까요?"
        lb.font = .systemFont(ofSize: 16, weight: .medium)
        lb.textColor = .gray200
        return lb
    }()
    
    private let todayTopicView1 = TodayTopicView(title: "오늘의 톡픽 5개!")
    private let todayTopicView2 = TodayTopicView(title: "대중들의 픽, 좋아요를\n가장 많이 받은 주제 모아보기")
    private let todayTopicView3 = TodayTopicView(title: "랜덤 주제로 진행하는 것도 묘미\n랜덤 주제 코스")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(mainLogo)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(todayTopicView1)
        addSubview(todayTopicView2)
        addSubview(todayTopicView3)
    }
    
    private func setupConstraints() {
        mainLogo.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview().inset(16)
            $0.width.height.equalTo(90)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mainLogo.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        todayTopicView1.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(54)
            $0.height.equalTo(103)
        }
        
        todayTopicView2.snp.makeConstraints {
            $0.top.equalTo(todayTopicView1.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(54)
            $0.height.equalTo(125)
        }
        
        todayTopicView3.snp.makeConstraints {
            $0.top.equalTo(todayTopicView2.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(54)
            $0.height.equalTo(125)
        }
    }
}
