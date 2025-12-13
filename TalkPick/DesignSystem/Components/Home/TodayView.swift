
import UIKit
import SnapKit

class TodayView: UIView {
    
    let navigationbarView = NavigationBarView(title: "오늘의 톡픽")
    
    let labelView1: UIView = {
        let uv = UIView()
        uv.backgroundColor = .yellow50
        uv.layer.cornerRadius = 15
        return uv
    }()
    
    let labelLabel1: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 12, weight: .semibold)
        lb.textColor = .yellow100
        return lb
    }()
    
    private let labelView2: UIView = {
        let uv = UIView()
        uv.backgroundColor = .pink50
        uv.layer.cornerRadius = 15
        return uv
    }()
    
    let labelLabel2: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 12, weight: .semibold)
        lb.textColor = .pink100
        return lb
    }()
    
    let cardView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let flipButton: UIButton = {
        let fb = UIButton(type: .custom)
        fb.setImage(UIImage(named: "talkpick_flip"), for: .normal)
        fb.setTitle("카드 뒤집기 ", for: .normal)
        fb.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        fb.setTitleColor(.gray100, for: .normal)
        fb.semanticContentAttribute = .forceRightToLeft
        return fb
    }()
    
    let likeButton: UIButton = {
        let cb = UIButton(type: .custom)
        cb.clipsToBounds = true
        cb.layer.cornerRadius = 12
        cb.layer.borderWidth = 1
        cb.layer.borderColor = UIColor.gray200.cgColor
        cb.backgroundColor = .white
        cb.setImage(UIImage(named: "talkpick_like")?.withRenderingMode(.alwaysOriginal), for: .normal)
        cb.setTitleColor(.gray200, for: .normal)
        cb.setTitle(" 좋아요", for: .normal)
        cb.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return cb
    }()
    
    var isFront: Bool = true
    var onFlip: ((Bool) -> Void)?
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(navigationbarView)
        
        addSubview(labelView1)
        labelView1.addSubview(labelLabel1)
        addSubview(labelView2)
        labelView2.addSubview(labelLabel2)
        
        addSubview(cardView)
        addSubview(flipButton)
        addSubview(likeButton)
    }
    
    private func setupConstraints() {
        navigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        labelView1.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom).offset(54)
            $0.leading.equalToSuperview().offset(35)
            $0.height.equalTo(31)
        }
        
        labelLabel1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(14)
        }
        
        labelView2.snp.makeConstraints {
            $0.centerY.equalTo(labelView1)
            $0.leading.equalTo(labelView1.snp.trailing).offset(8)
            $0.height.equalTo(31)
        }
        
        labelLabel2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(14)
        }
        
        cardView.snp.makeConstraints {
            $0.top.equalTo(labelView1.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(460)
        }
        
        flipButton.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22)
            $0.width.equalTo(90)
        }
        flipButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(flipButton.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(51)
        }
    }
    
    @objc func buttonTapped() {
        isFront.toggle()
        let options: UIView.AnimationOptions = isFront ? .transitionFlipFromRight : .transitionFlipFromLeft
        
        UIView.transition(with: cardView,
                          duration: 0.5,
                          options: options,
                          animations: {
            self.onFlip?(self.isFront)
        },
                          completion: nil)
    }
}
