
import UIKit
import SnapKit

class EditMbtiView: UIView {
    
    private let viewModel: MyPageViewModel
    
    private let contentView: UIView = {
        let uv = UIView()
        uv.backgroundColor = .white
        uv.layer.cornerRadius = 20
        return uv
    }()
    
    private let currentMBTI: UILabel = {
        let lb = UILabel()
        lb.text = "기존 MBTI"
        lb.font = .systemFont(ofSize: 16, weight: .bold)
        lb.textColor = .black
        return lb
    }()
    
    private let currentMBTITF: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 17, weight: .medium)
        tf.textColor = .gray200
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.gray100.cgColor
        tf.layer.masksToBounds = true
        tf.isEnabled = false
        tf.setLeftPadding(15)
        return tf
    }()
    
    private let modifyMBTI: UILabel = {
        let lb = UILabel()
        lb.text = "변경할 MBTI"
        lb.font = .systemFont(ofSize: 16, weight: .bold)
        lb.textColor = .black
        return lb
    }()
    
    private let modifyMBTITF: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 17, weight: .medium)
        tf.textColor = .black
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.gray100.cgColor
        tf.layer.masksToBounds = true
        tf.setLeftPadding(15)
        return tf
    }()
    
    private let cancelButton: UIButton = {
        let cb = UIButton(type: .system)
        cb.clipsToBounds = true
        cb.layer.cornerRadius = 12
        cb.layer.borderWidth = 1
        cb.layer.borderColor = UIColor.gray200.cgColor
        cb.backgroundColor = .white
        cb.setTitleColor(.gray200, for: .normal)
        cb.setTitle("취소", for: .normal)
        cb.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return cb
    }()
    
    private let modifyButton: UIButton = {
        let qb = UIButton(type: .system)
        qb.clipsToBounds = true
        qb.layer.cornerRadius = 12
        qb.backgroundColor = .black
        qb.setTitleColor(.white, for: .normal)
        qb.setTitle("변경하기", for: .normal)
        qb.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return qb
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(cancelButton)
        sv.addArrangedSubview(modifyButton)
        sv.axis = .horizontal
        sv.spacing = 9
        sv.distribution = .fillEqually
        return sv
    }()
    
    init(mbti: String, viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = UIColor(white: 0, alpha: 0.2)
        currentMBTITF.text = mbti
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(contentView)
        contentView.addSubview(currentMBTI)
        contentView.addSubview(currentMBTITF)
        contentView.addSubview(modifyMBTI)
        contentView.addSubview(modifyMBTITF)
        contentView.addSubview(buttonStackView)
        
        modifyMBTITF.delegate = self
        modifyMBTITF.keyboardType = .asciiCapable
        modifyMBTITF.autocapitalizationType = .allCharacters
        modifyMBTITF.autocorrectionType = .no
        modifyMBTITF.smartDashesType = .no
        modifyMBTITF.smartQuotesType = .no
        modifyMBTITF.smartInsertDeleteType = .no
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(56)
            $0.height.equalTo(260)
        }
        
        currentMBTI.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(34)
            $0.height.equalTo(33)
        }
        
        currentMBTITF.snp.makeConstraints {
            $0.top.equalTo(currentMBTI.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.height.equalTo(42)
        }
        
        modifyMBTI.snp.makeConstraints {
            $0.top.equalTo(currentMBTITF.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(34)
            $0.height.equalTo(33)
        }
        
        modifyMBTITF.snp.makeConstraints {
            $0.top.equalTo(modifyMBTI.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.height.equalTo(42)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(modifyMBTITF.snp.bottom).offset(23)
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.height.equalTo(35)
        }
        
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        modifyButton.addTarget(self, action: #selector(edit_Tapped), for: .touchUpInside)
        modifyMBTITF.addTarget(self, action: #selector(mbtiEditingChanged), for: .editingChanged)
        modifyButton.isEnabled = false
    }
    
    private func updateModifyButtonState(with text: String?) {
        modifyButton.isEnabled = (text?.count == 4)
    }
    
    @objc private func mbtiEditingChanged() {
        updateModifyButtonState(with: modifyMBTITF.text)
    }
    
    @objc private func edit_Tapped() {
        guard let newMbti = modifyMBTITF.text, newMbti.count == 4 else { return }
        viewModel.editMyProfile(mbti: newMbti)
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview() // 애니메이션 후 뷰에서 제거
        }
    }
    
    @objc private func dismissView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview() // 애니메이션 후 뷰에서 제거
        }
    }
}

extension EditMbtiView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // 백스페이스 등 비어있는 입력은 허용
        if string.isEmpty { return true }

        // 현재 텍스트와 prospective(적용될 최종 문자열) 계산
        let current = textField.text ?? ""
        guard let r = Range(range, in: current) else { return false }
        // 항상 대문자로 강제
        let prospective = current.replacingCharacters(in: r, with: string.uppercased())

        // 4글자 제한
        if prospective.count > 4 { return false }

        // 자리별 허용 문자 규칙
        let rules: [Set<Character>] = [
            ["I","E"], // 1번째
            ["S","N"], // 2번째
            ["T","F"], // 3번째
            ["J","P"]  // 4번째
        ]

        // 각 자리 검증
        let chars = Array(prospective)
        for (i, ch) in chars.enumerated() {
            // 알파벳 아닌 문자는 거절
            guard ch.isASCII, ch.isLetter, ch.isUppercase else { return false }
            // 해당 자리 규칙 위반 시 거절
            if i < rules.count, !rules[i].contains(ch) { return false }
        }

        // 여기까지 통과하면 직접 텍스트를 반영(대문자 강제 반영 위해 수동 세팅)
        textField.text = prospective
        
        updateModifyButtonState(with: prospective)
        return false
    }
}
