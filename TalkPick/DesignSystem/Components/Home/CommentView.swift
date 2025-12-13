
import UIKit
import SnapKit

class CommentView: UIView {
    private let randomId = UserDefaults.standard.integer(forKey: "randomId")
    private let randomViewModel = RandomViewModel()
    
    private let contentView: UIView = {
        let uv = UIView()
        uv.backgroundColor = .white
        uv.layer.cornerRadius = 20
        return uv
    }()
    
    private let commentLabel: UILabel = {
        let lb = UILabel()
        lb.text = "기억에 남는 한줄평을 적어주세요."
        lb.font = .systemFont(ofSize: 16, weight: .bold)
        lb.textColor = .black
        return lb
    }()
    
    private let commentTF: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 17, weight: .medium)
        tf.textColor = .gray200
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.gray100.cgColor
        tf.layer.masksToBounds = true
        tf.placeholder = "한줄평"
        tf.setLeftPadding(15)
        return tf
    }()
    
    private let doneButton: UIButton = {
        let qb = UIButton(type: .system)
        qb.clipsToBounds = true
        qb.layer.cornerRadius = 12
        qb.backgroundColor = .black
        qb.setTitleColor(.white, for: .normal)
        qb.setTitle("완료", for: .normal)
        qb.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return qb
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(white: 0, alpha: 0.2)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(contentView)
        contentView.addSubview(commentLabel)
        contentView.addSubview(commentTF)
        contentView.addSubview(doneButton)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(56)
            $0.height.equalTo(224)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(34)
            $0.height.equalTo(33)
        }
        
        commentTF.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.height.equalTo(42)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(commentTF.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(90)
            $0.height.equalTo(35)
        }
    }
    
    @objc private func dismissView() {
        randomViewModel.postRandomEnd(id: randomId)
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview() // 애니메이션 후 뷰에서 제거
        }
    }
}
