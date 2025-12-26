
import UIKit
import SnapKit

class CommentView: UIView {
    
    var onCommentSubmitted: ((String) -> Void)?
    var onCancelled: (() -> Void)?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
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
        backgroundColor = UIColor(white: 0, alpha: 0.2)
        setupUI()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(textField)
        containerView.addSubview(doneButton)
        
        textField.delegate = self
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(56)
            $0.height.equalTo(220)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(33)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(215)
            $0.height.equalTo(42)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(103)
            $0.height.equalTo(40)
        }
    }
    
    private func setupActions() {
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
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
    
    private func dismissWithAnimation() {
        textField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    func show() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.textField.becomeFirstResponder()
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

