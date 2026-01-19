
import UIKit
import SnapKit

protocol TutorialViewDelegate: AnyObject {
    func didTapSkip()
    func didTapStart()
}

class TutorialView: UIView {
    
    weak var delegate: TutorialViewDelegate?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "만나서 반가워요!"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "앱 튜토리얼을 진행할까요?"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray200.cgColor
        button.setTitle("스킵하기", for: .normal)
        button.setTitleColor(.gray200, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return button
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.setTitle("튜토리얼 진행", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private let touchImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_tutorial1"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(skipButton)
        buttonStackView.addArrangedSubview(startButton)
        
        addSubview(touchImageView)
        
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(249)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(33)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(33)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().offset(-34)
            $0.height.equalTo(43)
        }
        
        touchImageView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(81)
            $0.width.equalTo(227)
            $0.height.equalTo(130)
        }
    }
    
    @objc private func skipButtonTapped() {
        delegate?.didTapSkip()
    }
    
    @objc private func startButtonTapped() {
        delegate?.didTapStart()
    }
}
