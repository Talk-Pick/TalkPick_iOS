import UIKit
import SnapKit

class OnboardingCustomViewController: UIViewController {
    private let images = ["talkpick_launch", "talkpick_launch", "talkpick_launch", "talkpick_launch"]
    private var currentIndex = 0
    
    private let currentImageView = UIImageView()
    private let nextImageView = UIImageView()
    private let pageControl = UIPageControl()
    
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
        
        currentImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        nextImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
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
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
