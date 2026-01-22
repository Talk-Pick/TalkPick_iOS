
import UIKit
import SnapKit
import Kingfisher

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
        
        let style = categoryStyles[topic.category]
        let bgColor = style?.bgColor ?? .gray50
        let textColor = style?.textColor ?? .gray100
        labelView.backgroundColor = bgColor
        labelLabel.textColor = textColor
        
        if let url = URL(string: topic.keywordIconUrl) {
            let processor = DownsamplingImageProcessor(size: CGSize(width: 88, height: 88))
            character.kf.setImage(
                with: url,
                placeholder: UIImage(named: "talkpick_default"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
            character.image = UIImage(named: "talkpick_default")
        }
    }
}
