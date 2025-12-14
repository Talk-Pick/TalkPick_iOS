
import UIKit
import SnapKit

class CustomTabBarItemView: UIView {

    let imageView = UIImageView()
    let titleLabel = UILabel()

    init(image: UIImage?, title: String) {
        super.init(frame: .zero)
        setUI(image: image, title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI(image: UIImage?, title: String) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 11, weight: .heavy)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 3

        addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
    }

    func setSelected(_ selected: Bool) {
        imageView.tintColor = selected ? .black : .systemGray2
        titleLabel.textColor = selected ? .black : .systemGray2
    }
}

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    let customTabBarView = UIView()
    
    private let items: [CustomTabBarItemView] = [
        CustomTabBarItemView(image: UIImage(named: "talkpick_tab1")?.withRenderingMode(.alwaysTemplate), title: "홈 화면"),
        CustomTabBarItemView(image: UIImage(named: "talkpick_tab2")?.withRenderingMode(.alwaysTemplate), title: "캘린더"),
        CustomTabBarItemView(image: UIImage(named: "talkpick_tab3")?.withRenderingMode(.alwaysTemplate), title: "마이 페이지")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupCustomTabBar()
        selectedIndex = 0
        updateSelectedState(index: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupCustomTabBar() {
        tabBar.isHidden = true
        customTabBarView.backgroundColor = .white
        
        customTabBarView.layer.shadowColor = UIColor.black.cgColor
        customTabBarView.layer.shadowOpacity = 0.1
        customTabBarView.layer.shadowOffset = CGSize(width: 0, height: -4)
        customTabBarView.layer.shadowRadius = 8
        customTabBarView.layer.masksToBounds = false
        
        view.addSubview(customTabBarView)
        customTabBarView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        let stackView = UIStackView(arrangedSubviews: items)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        customTabBarView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        for (index, item) in items.enumerated() {
            item.tag = index
            item.isUserInteractionEnabled = true
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabItemTapped(_:))))
        }
    }
    
    @objc private func tabItemTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        
        selectedIndex = index
        updateSelectedState(index: index)
    }
    
    private func updateSelectedState(index: Int) {
        for (i, item) in items.enumerated() {
            item.setSelected(i == index)
        }
    }
    
    private func setupViewControllers() {
        let homeVC = HomeViewController()
        let calendarVC = CalendarViewController()
        let mypageVC = MypageViewController()
        
        let navigationHome = UINavigationController(rootViewController: homeVC)
        let navigationCalendar = UINavigationController(rootViewController: calendarVC)
        let navigationMypage = UINavigationController(rootViewController: mypageVC)

        self.viewControllers = [navigationHome, navigationCalendar, navigationMypage]
    }
}
