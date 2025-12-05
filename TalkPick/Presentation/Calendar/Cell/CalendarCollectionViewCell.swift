//
//  CalendarCollectionViewCell.swift
//  TalkPick
//
//  Created by jaegu park on 11/13/25.
//

import UIKit
import SnapKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CalendarCollectionViewCell.self)
    
    private var isTodayCell: Bool = false
    private var isInCurrentMonth: Bool = true
    
    private let dayView: CircleView = {
        let cv = CircleView()
        cv.backgroundColor = .clear
        cv.clipsToBounds = true
        return cv
    }()
    
    private let dayLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 10, weight: .medium)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setUI()
        applyAppearance()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isTodayCell = false
        isInCurrentMonth = true
        // 선택 상태는 UICollectionView가 관리하지만, 외형은 다시 맞춰줌
        applyAppearance()
    }
    
    private func setUI() {
        if dayView.superview == nil {
            contentView.addSubview(dayView)
            dayView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(6)
                make.leading.trailing.equalToSuperview().inset(14)
            }
            
            dayView.addSubview(dayLabel)
            dayLabel.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
        }
    }
    
    private func applyAppearance() {
        if isTodayCell && isInCurrentMonth {
            dayView.backgroundColor = .purple100
            dayLabel.textColor = .white
        } else {
            dayView.backgroundColor = .clear
            dayLabel.textColor = isInCurrentMonth ? .black : .gray100
        }
    }
    
    func updateDay(day: String, isToday: Bool = false, isCurrentMonth: Bool = true) {
        self.dayLabel.text = day
        isTodayCell = isToday
        isInCurrentMonth = isCurrentMonth
        applyAppearance()
    }
}

final class CircleView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let r = min(bounds.width, bounds.height) / 2
        if layer.cornerRadius != r {
            layer.cornerRadius = r
        }
        layer.masksToBounds = true
    }
}
