
import UIKit
import SnapKit

class CommentView: UIView {
    
    var onCommentSubmitted: ((String) -> Void)?
    var onCancelled: (() -> Void)?
    
    private let dimmedBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "기억에 남는 한줄평을 적어주세요."
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 15)
        tf.textColor = .black
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.gray100.cgColor
        tf.placeholder = "한줄평"
        tf.textAlignment = .left
        tf.setLeftPadding(15)
        
        return tf
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let maxCharacterCount = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(dimmedBackground)
        addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(textField)
        containerView.addSubview(doneButton)
        
        textField.delegate = self
    }
    
    private func setupLayout() {
        dimmedBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(260)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(33)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(90)
            $0.height.equalTo(42)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(110)
            $0.height.equalTo(40)
        }
    }
    
    private func setupActions() {
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        dimmedBackground.addGestureRecognizer(tapGesture)
    }
    
    @objc private func doneTapped() {
        let comment = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard !comment.isEmpty else {
            // 한줄평이 비어있으면 알림
            return
        }
        
        onCommentSubmitted?(comment)
        dismissWithAnimation()
    }
    
    @objc private func backgroundTapped() {
        textField.resignFirstResponder()
    }
    
    private func dismissWithAnimation() {
        textField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    func show() {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut) {
            self.containerView.transform = .identity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.textField.becomeFirstResponder()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 초기에 아래에서 올라오는 애니메이션을 위해
        if containerView.transform == .identity {
            containerView.transform = CGAffineTransform(translationX: 0, y: containerView.frame.height)
        }
    }
}

extension CommentView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= maxCharacterCount
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

