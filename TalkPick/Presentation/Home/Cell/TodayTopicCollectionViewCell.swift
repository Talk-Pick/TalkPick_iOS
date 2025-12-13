
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
    
    private let character: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_topic1"))
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
            $0.top.equalToSuperview().offset(12)
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
        
        self.contentView.addSubview(character)
        character.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(14)
            $0.height.width.equalTo(88)
        }
    }
    
    func prepare(topic: Topic) {
        labelLabel.text = topic.category
        titleLabel.text = topic.title
        
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
