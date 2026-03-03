
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RandomViewController: UIViewController {
    private let images = ["talkpick_random1", "talkpick_random2", "talkpick_random3", "talkpick_random4", "talkpick_random5"]
    private var currentIndex = 0
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = true
        sv.showsHorizontalScrollIndicator = false
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    private let contentView = UIView()
    
    private let pageControl = CustomPageControl()
    private let currentImageView = UIImageView()
    private let nextImageView = UIImageView()
    private let slideImageView = UIImageView(image: UIImage(named: "talkpick_slide"))
    
    let startButton: UIButton = {
        let sb = UIButton(type: .system)
        sb.clipsToBounds = true
        sb.layer.cornerRadius = 12
        sb.layer.borderWidth = 1
        sb.layer.borderColor = UIColor.gray200.cgColor
        sb.backgroundColor = .white
        sb.setTitleColor(.gray200, for: .normal)
        sb.setTitle("시작하기", for: .normal)
        sb.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        sb.applyTextButtonPressEffect()
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setUI()
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = tabBarController as? MainTabViewController {
            tabBarVC.tabBar.isHidden = false
        }
    }
    
    private func setUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        startButton.addTarget(self, action: #selector(randomTapped), for: .touchUpInside)
    }
    
    @objc private func randomTapped() {
        let randomVC = RandomCourseViewController()
        navigationController?.pushViewController(randomVC, animated: true)
    }
    
    private func setupViews() {
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        contentView.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(60)
        }
        
        currentImageView.image = UIImage(named: images[0])
        currentImageView.contentMode = .scaleAspectFit
        
        nextImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(currentImageView)
        contentView.addSubview(nextImageView)
        
        currentImageView.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(503)
        }
        
        nextImageView.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(503)
        }
        
        contentView.addSubview(slideImageView)
        slideImageView.isHidden = false
        slideImageView.snp.makeConstraints {
            $0.top.equalTo(currentImageView.snp.bottom).offset(-16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(29)
        }
        
        contentView.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.top.equalTo(currentImageView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(51)
            $0.bottom.equalToSuperview().offset(-80)
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
                return
            }
            newIndex += 1
            animateTransition(to: newIndex, direction: .left)
        } else if gesture.direction == .right {
            guard currentIndex > 0 else { return }
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
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: {
            self.currentImageView.transform = CGAffineTransform(translationX: -offset, y: 0)
            self.nextImageView.transform = .identity
        }, completion: { _ in
            self.currentImageView.image = self.nextImageView.image
            self.currentImageView.transform = .identity
            self.currentIndex = newIndex
            self.pageControl.currentPage = newIndex
            self.updateSlideImageViewVisibility()
        })
    }
    
    private func updateSlideImageViewVisibility() {
        slideImageView.isHidden = currentIndex >= 1
    }
}
