
import UIKit

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {

    private let tabItems: [(image: String, title: String)] = [
        ("talkpick_tab1", "홈 화면"),
        ("talkpick_tab2", "랜덤코스"),
        ("talkpick_tab3", "좋아요"),
        ("talkpick_tab4", "마이페이지")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarAppearance()
        setupViewControllers()
        selectedIndex = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // iOS 네이티브 Liquid Glass 탭바 appearance 설정
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()  // Liquid Glass: 블러 + 반투명

        // 선택된 탭: 검은색
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.isHidden = false
    }

    private func setupViewControllers() {
        let homeVC = HomeViewController()
        let randomVC = RandomViewController()
        let likeVC = LikeTopicViewController()
        let mypageVC = MypageViewController()

        let viewControllers = [homeVC, randomVC, likeVC, mypageVC]

        let imageSizes: [CGSize] = [
            CGSize(width: 20, height: 20),  // 1번: 홈 화면
            CGSize(width: 24, height: 20),  // 2번: 랜덤코스
            CGSize(width: 20, height: 20),  // 3번: 좋아요
            CGSize(width: 16, height: 20)   // 4번: 마이페이지
        ]

        for (index, vc) in viewControllers.enumerated() {
            let item = tabItems[index]
            let size = imageSizes[index]
            let image = UIImage(named: item.image)?
                .resized(to: size)
                .withRenderingMode(.alwaysTemplate)
            vc.tabBarItem = UITabBarItem(title: item.title, image: image, tag: index)
        }

        let navigationHome = UINavigationController(rootViewController: homeVC)
        let navigationRandom = UINavigationController(rootViewController: randomVC)
        let navigationLike = UINavigationController(rootViewController: likeVC)
        let navigationMypage = UINavigationController(rootViewController: mypageVC)

        self.viewControllers = [navigationHome, navigationRandom, navigationLike, navigationMypage]
    }

    // 프로그래매틱 탭 전환 (외부 호출용)
    func switchToTab(index: Int) {
        guard let count = viewControllers?.count, (0..<count).contains(index) else { return }
        selectedIndex = index
    }
}

private extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
