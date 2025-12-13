
import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    private let images = ["talkpick_onboarding1", "talkpick_onboarding2", "talkpick_onboarding3", "talkpick_onboarding4"]
    private var currentIndex = 0
    
    private let currentImageView = UIImageView()
    private let nextImageView = UIImageView()
    private let pageControl = CustomPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupImageViews()
        setupPageControl()
        setupGesture()
    }
    
    private func setupImageViews() {
        currentImageView.image = UIImage(named: images[0])
        currentImageView.contentMode = .scaleAspectFit
        
        nextImageView.contentMode = .scaleAspectFit
        
        view.addSubview(currentImageView)
        view.addSubview(nextImageView)
        
        currentImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(1)
            $0.height.equalToSuperview().multipliedBy(1)
        }
        
        nextImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(1)
            $0.height.equalToSuperview().multipliedBy(1)
        }
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(85)
        }
    }
    
    private func setupGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        var newIndex = currentIndex
        
        if gesture.direction == .left {
            if currentIndex == images.count - 1 {
                goToLogin()
                return
            }
            
            newIndex += 1
            animateTransition(to: newIndex, direction: .left)
        } else if gesture.direction == .right {
            guard currentIndex > 0 else { return } // 첫 이미지면 멈춤
            newIndex -= 1
            animateTransition(to: newIndex, direction: .right)
        }
    }
    
    private func animateTransition(to newIndex: Int, direction: UISwipeGestureRecognizer.Direction) {
        let width = view.bounds.width
        let offset = direction == .left ? width : -width
        
        // 다음 이미지 준비
        nextImageView.image = UIImage(named: images[newIndex])
        nextImageView.transform = CGAffineTransform(translationX: offset, y: 0)
        
        // 애니메이션
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: {
            self.currentImageView.transform = CGAffineTransform(translationX: -offset, y: 0)
            self.nextImageView.transform = .identity
        }, completion: { _ in
            // 전환 완료 후 상태 정리
            self.currentImageView.image = self.nextImageView.image
            self.currentImageView.transform = .identity
            self.currentIndex = newIndex
            self.pageControl.currentPage = newIndex
        })
    }
    
    private func goToLogin() {
        UserDefaults.standard.set(true, forKey: AppStorageKey.hasShownOnboarding)
        
        let loginVC = LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }
}

final class CustomPageControl: UIStackView {
    
    var numberOfPages: Int = 0 {
        didSet { configureDots() }
    }

    var currentPage: Int = 0 {
        didSet { updateDots() }
    }

    private var dotViews: [UIView] = []
        private var widthConstraints: [Constraint] = []

        private let normalWidth: CGFloat = 6
        private let selectedWidth: CGFloat = 11
        private let dotHeight: CGFloat = 6

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        axis = .horizontal
        alignment = .center
        distribution = .equalSpacing
        spacing = 8
    }

    private func configureDots() {
        // 기존 점 제거
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        dotViews.removeAll()
        widthConstraints.removeAll()

        guard numberOfPages > 0 else { return }

        for _ in 0..<numberOfPages {
            let dot = UIView()
            addArrangedSubview(dot)
            
            dot.layer.cornerRadius = dotHeight / 2
            dot.layer.masksToBounds = true
            dot.backgroundColor = .lightGray
            
            dot.snp.makeConstraints { make in
                let width = make.width.equalTo(normalWidth).constraint
                make.height.equalTo(dotHeight)
                widthConstraints.append(width)
            }
            
            dotViews.append(dot)
        }

        updateDots()
    }

    private func updateDots() {
        guard !dotViews.isEmpty else { return }
        
        for (index, dot) in dotViews.enumerated() {
            let isCurrent = index == currentPage
            
            widthConstraints[index].update(offset: isCurrent ? selectedWidth : normalWidth)
            dot.backgroundColor = isCurrent ? .black : .lightGray
        }
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}
