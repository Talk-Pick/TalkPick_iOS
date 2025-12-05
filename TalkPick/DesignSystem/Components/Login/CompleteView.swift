import UIKit
import SnapKit

class CompleteView: UIView {

    private let finishImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "talkpick_finish")
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입이 완료되었습니다."
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    let finishButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("홈 화면으로", for: .normal)
        bt.backgroundColor = .black
        bt.setTitleColor(.white, for: .normal)
        bt.layer.cornerRadius = 10
        bt.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return bt
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
        addSubview(finishImageView)
        addSubview(titleLabel)
        addSubview(finishButton)
    }
    
    private func setupConstraints() {
        finishImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.leading.trailing.equalToSuperview().inset(52)
            $0.height.equalTo(173)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(finishImageView.snp.bottom).offset(26)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        finishButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-225)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(51)
        }
    }
}
