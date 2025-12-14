
import UIKit
import SnapKit

class LikeTopicTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: LikeTopicTableViewCell.self)

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
    
    private let categoryLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 12, weight: .bold)
        return lb
    }()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 16, weight: .bold)
        lb.textColor = .black
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUI()
    }
    
    private func setUI() {
        self.contentView.layer.cornerRadius = 14
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.2
        self.contentView.layer.shadowRadius = 6
        self.contentView.layer.shadowOffset = .zero
        self.contentView.clipsToBounds = false
        self.contentView.backgroundColor = .gray10
        
        
        self.contentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        
        self.contentView.addSubview(labelView)
        labelView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(23)
        }
        
        self.labelView.addSubview(labelLabel)
        labelLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(14)
        }
        
        self.contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.centerY.equalTo(labelView)
            $0.leading.equalTo(labelView.snp.trailing).offset(7)
            $0.height.equalTo(21)
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(labelView.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(32)
        }
    }
    
    func prepare(likedDetail: LikedDetail) {
        let style = categoryStyles[likedDetail.category.title]
        labelView.backgroundColor = style?.bgColor
        labelLabel.textColor = style?.textColor
        labelLabel.text = likedDetail.category.title
        categoryLabel.text = "#" + String(likedDetail.keyword)
        categoryLabel.textColor = style?.textColor
        titleLabel.text = likedDetail.title
    }
}
