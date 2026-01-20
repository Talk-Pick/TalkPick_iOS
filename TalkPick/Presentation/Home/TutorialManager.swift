
import UIKit
import SnapKit

enum TutorialStep {
    case welcome
    case todayTopic
    case randomCourse
    case tabBar
    case finalTodayTopic
    
    var imageName: String? {
        switch self {
        case .welcome:
            return nil
        case .todayTopic:
            return "talkpick_tutorial2"
        case .randomCourse:
            return "talkpick_tutorial3"
        case .tabBar:
            return nil
        case .finalTodayTopic:
            return "talkpick_tutorial6"
        }
    }
    
    var tabBarImageNames: [String]? {
        switch self {
        case .tabBar:
            return ["talkpick_tutorial4", "talkpick_tutorial5"]
        default:
            return nil
        }
    }
    
    var imageSize: CGSize {
        switch self {
        case .welcome:
            return CGSize(width: 200, height: 200)
        case .todayTopic:
            return CGSize(width: 279, height: 50)
        case .randomCourse:
            return CGSize(width: 279, height: 50)
        case .tabBar:
            return CGSize(width: 200, height: 200)
        case .finalTodayTopic:
            return CGSize(width: 295, height: 35)
        }
    }
    
    var tabBarImageSizes: [CGSize]? {
        switch self {
        case .tabBar:
            return [CGSize(width: 227, height: 90), CGSize(width: 260, height: 215)] // 사용자가 설정할 크기들
        default:
            return nil
        }
    }
}

class TutorialManager {
    
    weak var homeViewController: HomeViewController?
    weak var tabBarController: MainTabViewController?
    
    private var currentStep: TutorialStep = .welcome
    private var overlayView: UIView?
    private var highlightView: UIView?
    private var highlightViews: [UIView] = []
    private var tutorialImageView: UIImageView?
    private var tutorialImageViews: [UIImageView] = []
    private var tutorialView: TutorialView?
    
    private let highlightColor = UIColor.clear
    private let borderColor = UIColor.purple100
    
    static let shared = TutorialManager()
    
    private init() {}
    
    /// 테스트를 위한 튜토리얼 완료 상태 초기화 함수
//    static func resetTutorial() {
//        UserDefaults.standard.set(false, forKey: AppStorageKey.hasCompletedTutorial)
//    }
    
    func startTutorial(homeViewController: HomeViewController, tabBarController: MainTabViewController) {
        self.homeViewController = homeViewController
        self.tabBarController = tabBarController
        
        if UserDefaults.standard.bool(forKey: AppStorageKey.hasCompletedTutorial) {
            return
        }
        
        showWelcomePopup()
    }
    
    private func showWelcomePopup() {
        guard let homeVC = homeViewController,
              let tabBarVC = tabBarController else { return }
        
        let tutorialView = TutorialView()
        tutorialView.delegate = self
        
        tabBarVC.view.addSubview(tutorialView)
        tutorialView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.tutorialView = tutorialView
    }
    
    func startTutorialSteps() {
        tutorialView?.removeFromSuperview()
        tutorialView = nil
        
        currentStep = .todayTopic
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showCurrentStep()
        }
    }
    
    func skipTutorial() {
        completeTutorial()
    }
    
    func nextStep() {
        switch currentStep {
        case .welcome:
            currentStep = .todayTopic
        case .todayTopic:
            currentStep = .randomCourse
        case .randomCourse:
            currentStep = .tabBar
        case .tabBar:
            currentStep = .finalTodayTopic
        case .finalTodayTopic:
            completeTutorial()
            return
        }
        showCurrentStep()
    }
    
    private func showCurrentStep() {
        removeCurrentOverlay()
        
        guard let tabBarVC = tabBarController else { return }
        
        let overlay = createOverlayView()
        
        // 항상 MainTabViewController의 view에 추가
        tabBarVC.view.addSubview(overlay)
        overlay.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // overlay를 탭바 위로 가져오기 (z-order 조정)
        tabBarVC.view.bringSubviewToFront(overlay)
        
        self.overlayView = overlay
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        overlay.addGestureRecognizer(tapGesture)
        
        // 레이아웃이 완료될 때까지 대기
        homeViewController?.view.layoutIfNeeded()
        tabBarVC.view.layoutIfNeeded()
        
        switch currentStep {
        case .todayTopic:
            if let homeVC = homeViewController, let homeView = homeVC.view as? HomeView {
                highlightTodayTopicSection(in: overlay, homeView: homeView)
            }
        case .randomCourse:
            if let homeVC = homeViewController, let homeView = homeVC.view as? HomeView {
                highlightRandomCourseSection(in: overlay, homeView: homeView)
            }
        case .tabBar:
            highlightTabBar(in: overlay)
        case .finalTodayTopic:
            showFinalMessage(in: overlay)
        default:
            break
        }
    }
    
    private func createOverlayView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }
    
    private func highlightTodayTopicSection(in overlay: UIView, homeView: HomeView) {
        let labelFrame = homeView.convert(homeView.todayLabel.frame, to: overlay)
        let collectionFrame = homeView.convert(homeView.todayTopicCollectionView.frame, to: overlay)
        
        let combinedFrame = labelFrame.union(collectionFrame)
        let highlightFrame = CGRect(
            x: 0,
            y: combinedFrame.minY - 12,
            width: overlay.frame.width,
            height: combinedFrame.maxY - combinedFrame.minY - 20
        )
        
        let excludeArea = highlightFrame.insetBy(dx: 3, dy: 3)
        
        createHighlightView(in: overlay, frame: highlightFrame, isSpecialLayout: true, excludeArea: excludeArea)
    }
    
    private func highlightRandomCourseSection(in overlay: UIView, homeView: HomeView) {
        guard let tabBarVC = tabBarController else { return }
        
        let labelFrame = homeView.convert(homeView.randomLabel.frame, to: overlay)
        let viewFrame = homeView.convert(homeView.randomView.frame, to: overlay)
        
        let combinedFrame = labelFrame.union(viewFrame)
        let tabBarTop = overlay.frame.height - 78
        let bottomY = min(combinedFrame.maxY + 12, tabBarTop)
        
        let highlightFrame = CGRect(
            x: 0,
            y: combinedFrame.minY - 12,
            width: overlay.frame.width,
            height: bottomY - (combinedFrame.minY - 12)
        )
        
        let excludeArea = highlightFrame.insetBy(dx: 3, dy: 3)
        
        createHighlightView(in: overlay, frame: highlightFrame, isSpecialLayout: true, excludeArea: excludeArea)
    }
    
    private func highlightTabBar(in overlay: UIView) {
        guard let tabBarVC = tabBarController as? MainTabViewController else { return }
        
        let tabBarHeight: CGFloat = 78
        let tabBarFrame = CGRect(
            x: 0,
            y: overlay.frame.height - tabBarHeight,
            width: overlay.frame.width,
            height: tabBarHeight
        )
        
        var excludeAreas: [CGRect] = []
        
        for item in tabBarVC.items {
            let itemFrameInTabBar = item.frame
            let itemFrameInOverlay = tabBarVC.customTabBarView.convert(itemFrameInTabBar, to: overlay)
            
            let padding: CGFloat = 4
            let paddedFrame = itemFrameInOverlay.insetBy(dx: -padding, dy: -padding)
            
            let baseSize = max(paddedFrame.width, paddedFrame.height)
            let squareSize = baseSize * 0.75
            
            let highlightFrame = CGRect(
                x: paddedFrame.midX - squareSize / 2,
                y: paddedFrame.midY - squareSize / 2 - 3,
                width: squareSize,
                height: squareSize
            )
            
            let excludeArea = highlightFrame.insetBy(dx: 3, dy: 3)
            excludeAreas.append(excludeArea)
            
            createTabBarItemHighlightView(in: tabBarVC.view, frame: highlightFrame, overlay: overlay)
        }
        
        if !excludeAreas.isEmpty {
            applyMultipleMasksToOverlay(overlay, excluding: excludeAreas)
        }
        if let imageNames = currentStep.tabBarImageNames,
           let imageSizes = currentStep.tabBarImageSizes,
           imageNames.count == imageSizes.count && imageNames.count == 2 {
            
            let images = imageNames.compactMap { UIImage(named: $0) }
            
            for (index, image) in images.enumerated() {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                
                overlay.addSubview(imageView)
                tutorialImageViews.append(imageView)
                
                // 이미지 크기 설정
                let imageSize = imageSizes[index]
                
                let imageX: CGFloat
                let imageY: CGFloat
                
                if index == 0 {
                    // 첫 번째 이미지: 화면 중앙보다 위에 배치
                    imageX = overlay.frame.midX - imageSize.width / 2
                    imageY = overlay.frame.midY - imageSize.height / 2 - 80
                } else {
                    // 두 번째 이미지: 탭바 바로 위에 배치 (중앙 정렬)
                    imageX = overlay.frame.midX - imageSize.width / 2
                    imageY = tabBarFrame.minY - imageSize.height
                }
                
                imageView.frame = CGRect(
                    x: imageX,
                    y: imageY,
                    width: imageSize.width,
                    height: imageSize.height
                )
            }
        }
    }
    
    private func showFinalMessage(in overlay: UIView) {
        highlightView = nil
        
        if let imageName = currentStep.imageName, let image = UIImage(named: imageName) {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            
            overlay.addSubview(imageView)
            self.tutorialImageView = imageView
            
            let imageSize = currentStep.imageSize
            let imageX = overlay.frame.midX - imageSize.width / 2
            let imageY = overlay.frame.midY - imageSize.height / 2
            
            imageView.frame = CGRect(
                x: imageX,
                y: imageY,
                width: imageSize.width,
                height: imageSize.height
            )
        }
    }
    
    private func createTabBarItemHighlightView(in containerView: UIView, frame: CGRect, overlay: UIView) {
        let highlight = UIView()
        highlight.backgroundColor = UIColor.clear
        
        // highlight view를 containerView(tabBarVC.view)에 직접 추가하여 overlay 마스크의 영향을 받지 않도록 함
        containerView.addSubview(highlight)
        highlight.frame = frame
        
        // 테두리가 탭바 위에 보이도록 zPosition 설정
        highlight.layer.zPosition = 1000
        
        // 각 탭바 아이템을 둥근 모서리 정사각형으로 감싸기
        let borderLayer = CAShapeLayer()
        let path = UIBezierPath()
        let cornerRadius: CGFloat = 12 // 둥근 모서리 반경
        let lineWidth: CGFloat = 3
        let halfLineWidth = lineWidth / 2
        
        // 테두리 경로: frame 경계에서 lineWidth/2만큼 안쪽으로 (테두리 중심선)
        let borderRect = CGRect(
            x: halfLineWidth,
            y: halfLineWidth,
            width: frame.width - lineWidth,
            height: frame.height - lineWidth
        )
        
        // 둥근 모서리 정사각형 경로 그리기
        path.move(to: CGPoint(x: borderRect.minX + cornerRadius, y: borderRect.minY))
        path.addLine(to: CGPoint(x: borderRect.maxX - cornerRadius, y: borderRect.minY))
        path.addArc(withCenter: CGPoint(x: borderRect.maxX - cornerRadius, y: borderRect.minY + cornerRadius),
                   radius: cornerRadius,
                   startAngle: -.pi / 2,
                   endAngle: 0,
                   clockwise: true)
        path.addLine(to: CGPoint(x: borderRect.maxX, y: borderRect.maxY - cornerRadius))
        path.addArc(withCenter: CGPoint(x: borderRect.maxX - cornerRadius, y: borderRect.maxY - cornerRadius),
                   radius: cornerRadius,
                   startAngle: 0,
                   endAngle: .pi / 2,
                   clockwise: true)
        path.addLine(to: CGPoint(x: borderRect.minX + cornerRadius, y: borderRect.maxY))
        path.addArc(withCenter: CGPoint(x: borderRect.minX + cornerRadius, y: borderRect.maxY - cornerRadius),
                   radius: cornerRadius,
                   startAngle: .pi / 2,
                   endAngle: .pi,
                   clockwise: true)
        path.addLine(to: CGPoint(x: borderRect.minX, y: borderRect.minY + cornerRadius))
        path.addArc(withCenter: CGPoint(x: borderRect.minX + cornerRadius, y: borderRect.minY + cornerRadius),
                   radius: cornerRadius,
                   startAngle: .pi,
                   endAngle: -.pi / 2,
                   clockwise: true)
        path.close()
        
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = UIColor.purple100.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = lineWidth
        borderLayer.frame = highlight.bounds
        
        highlight.layer.addSublayer(borderLayer)
        highlightViews.append(highlight)
        containerView.addSubview(highlight)
    }
    
    private func createHighlightView(in overlay: UIView, frame: CGRect, isSpecialLayout: Bool = false, excludeArea: CGRect? = nil, isTabBar: Bool = false) {
        let highlight = UIView()
        highlight.backgroundColor = highlightColor
        
        overlay.addSubview(highlight)
        highlight.frame = frame
        
        // 탭바의 경우 밑쪽 모서리만 둥글게 처리
        if isTabBar {
            let borderLayer = CAShapeLayer()
            let path = UIBezierPath()
            let cornerRadius: CGFloat = 20
            
            // 경로 그리기: 위쪽은 직선, 밑쪽은 둥글게
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: frame.width, y: 0))
            path.addLine(to: CGPoint(x: frame.width, y: frame.height - cornerRadius))
            path.addQuadCurve(to: CGPoint(x: 0, y: frame.height - cornerRadius), 
                            controlPoint: CGPoint(x: frame.width / 2, y: frame.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.close()
            
            borderLayer.path = path.cgPath
            borderLayer.strokeColor = borderColor.cgColor
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.lineWidth = 3
            borderLayer.frame = highlight.bounds
            
            highlight.layer.addSublayer(borderLayer)
        } else {
            highlight.layer.borderColor = borderColor.cgColor
            highlight.layer.borderWidth = 3
            highlight.layer.cornerRadius = 0
        }
        
        self.highlightView = highlight
        
        if let excludeArea = excludeArea {
            applyMaskToOverlay(overlay, excluding: excludeArea)
        }
        
        if let imageName = currentStep.imageName, let image = UIImage(named: imageName) {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            
            overlay.addSubview(imageView)
            self.tutorialImageView = imageView
            
            let imageSize = currentStep.imageSize
            let imageX: CGFloat
            let imageY: CGFloat
            
            if isSpecialLayout {
                imageX = 25
                imageY = frame.minY - imageSize.height
            } else {
                imageX = overlay.frame.midX - imageSize.width / 2
                imageY = frame.minY - imageSize.height - 16
            }
            
            imageView.frame = CGRect(
                x: imageX,
                y: max(imageY, 20),
                width: imageSize.width,
                height: imageSize.height
            )
        }
    }
    
    private func applyMaskToOverlay(_ overlay: UIView, excluding area: CGRect) {
        // 전체 화면에서 특정 영역을 제외한 마스크 생성
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(rect: overlay.bounds)
        let excludePath = UIBezierPath(rect: area)
        path.append(excludePath.reversing())
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        overlay.layer.mask = maskLayer
    }
    
    private func applyMultipleMasksToOverlay(_ overlay: UIView, excluding areas: [CGRect]) {
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(rect: overlay.bounds)
        let cornerRadius: CGFloat = 9
        
        for area in areas {
            let excludePath = UIBezierPath()
            excludePath.move(to: CGPoint(x: area.minX + cornerRadius, y: area.minY))
            excludePath.addLine(to: CGPoint(x: area.maxX - cornerRadius, y: area.minY))
            excludePath.addArc(withCenter: CGPoint(x: area.maxX - cornerRadius, y: area.minY + cornerRadius),
                             radius: cornerRadius,
                             startAngle: -.pi / 2,
                             endAngle: 0,
                             clockwise: true)
            excludePath.addLine(to: CGPoint(x: area.maxX, y: area.maxY - cornerRadius))
            excludePath.addArc(withCenter: CGPoint(x: area.maxX - cornerRadius, y: area.maxY - cornerRadius),
                             radius: cornerRadius,
                             startAngle: 0,
                             endAngle: .pi / 2,
                             clockwise: true)
            excludePath.addLine(to: CGPoint(x: area.minX + cornerRadius, y: area.maxY))
            excludePath.addArc(withCenter: CGPoint(x: area.minX + cornerRadius, y: area.maxY - cornerRadius),
                             radius: cornerRadius,
                             startAngle: .pi / 2,
                             endAngle: .pi,
                             clockwise: true)
            excludePath.addLine(to: CGPoint(x: area.minX, y: area.minY + cornerRadius))
            excludePath.addArc(withCenter: CGPoint(x: area.minX + cornerRadius, y: area.minY + cornerRadius),
                             radius: cornerRadius,
                             startAngle: .pi,
                             endAngle: -.pi / 2,
                             clockwise: true)
            excludePath.close()
            
            path.append(excludePath.reversing())
        }
        
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        overlay.layer.mask = maskLayer
    }
    
    private func removeCurrentOverlay() {
        overlayView?.layer.mask = nil
        overlayView?.removeFromSuperview()
        overlayView = nil
        
        highlightView?.removeFromSuperview()
        highlightView = nil
        
        highlightViews.forEach { $0.removeFromSuperview() }
        highlightViews.removeAll()
        
        tutorialImageView?.removeFromSuperview()
        tutorialImageView = nil
        
        tutorialImageViews.forEach { $0.removeFromSuperview() }
        tutorialImageViews.removeAll()
    }
    
    @objc private func overlayTapped() {
        nextStep()
    }
    
    private func completeTutorial() {
        removeCurrentOverlay()
        tutorialView?.removeFromSuperview()
        tutorialView = nil
        UserDefaults.standard.set(true, forKey: AppStorageKey.hasCompletedTutorial)
    }
}

extension TutorialManager: TutorialViewDelegate {
    func didTapSkip() {
        completeTutorial()
    }
    
    func didTapStart() {
        startTutorialSteps()
    }
}
