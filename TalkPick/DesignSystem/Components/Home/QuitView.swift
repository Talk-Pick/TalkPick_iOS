
import UIKit
import SnapKit

class QuitView: UIView {
    private var num: Int = 1
    private weak var targetViewController: UIViewController?
    private let randomId = UserDefaults.standard.integer(forKey: "randomId")
    private let randomViewModel = RandomViewModel()
    
    private let contentView: UIView = {
        let uv = UIView()
        uv.backgroundColor = .gray10
        uv.layer.cornerRadius = 20
        return uv
    }()
    
    private let character: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_stop"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let cautionLabel: UILabel = {
        let lb = UILabel()
        lb.text = "정말로 나가시겠습니까?"
        lb.font = .systemFont(ofSize: 16, weight: .bold)
        lb.textColor = .black
        return lb
    }()
    
    private let quitButton: UIButton = {
        let qb = UIButton(type: .system)
        qb.clipsToBounds = true
        qb.layer.cornerRadius = 12
        qb.backgroundColor = .black
        qb.setTitleColor(.white, for: .normal)
        qb.setTitle("나가기", for: .normal)
        qb.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        return qb
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
    
    private lazy var buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(quitButton)
        sv.addArrangedSubview(cancelButton)
        sv.axis = .horizontal
        sv.spacing = 9
        sv.distribution = .fillEqually
        return sv
    }()
    
    init(target: UIViewController, num: Int) {
        super.init(frame: .zero)
        backgroundColor = UIColor(white: 0, alpha: 0.2)
        self.targetViewController = target
        self.num = num
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(contentView)
        contentView.addSubview(character)
        contentView.addSubview(cautionLabel)
        contentView.addSubview(buttonStackView)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(56)
            $0.height.equalTo(260)
        }
        
        character.snp.makeConstraints {
            $0.top.equalToSuperview().offset(39)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(97)
        }

        cautionLabel.snp.makeConstraints {
            $0.top.equalTo(character.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(33)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(cautionLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(33)
            $0.height.equalTo(35)
        }
        
        quitButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
       if let target = targetViewController {
          setBackButtonTarget(target: target, num: num)
       }
    }
    
    @objc private func dismissView() {
        randomViewModel.postRandomQuit(id: randomId)
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    func setBackButtonTarget(target: UIViewController, num: Int) {
        if let navigationController = target.navigationController {
            let viewControllers = navigationController.viewControllers
            if viewControllers.count > 1 {
                let previousViewController = viewControllers[viewControllers.count - num]
                self.removeFromSuperview()
                navigationController.popToViewController(previousViewController, animated: true)
            }
        }
    }
}
