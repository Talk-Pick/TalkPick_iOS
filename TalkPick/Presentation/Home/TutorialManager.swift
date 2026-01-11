
import UIKit
import SnapKit

enum TutorialStep {
    case welcome
    case todayTopic
    case randomCourse
    case finalTodayTopic
    
    var description: String {
        switch self {
        case .welcome:
            return ""
        case .todayTopic:
            return "오늘의 추천 주제로 대화를 시작할 수 있어요."
        case .randomCourse:
            return "랜덤으로 주어지는 주제로 대화를 시작할 수 있어요."
        case .finalTodayTopic:
            return "화면을 터치하여 시작해보세요!"
        }
    }
}

class TutorialManager {
    
    weak var homeViewController: HomeViewController?
    weak var tabBarController: MainTabViewController?
    
    private var currentStep: TutorialStep = .welcome
    private var overlayView: UIView?
    private var highlightView: UIView?
    private var descriptionLabel: UILabel?
    private var tutorialView: TutorialView?
    
    private let highlightColor = UIColor.clear
    private let borderColor = UIColor.purple100
    
    static let shared = TutorialManager()
    
    private init() {}
    
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
        
        // MainTabViewController의 view에 추가하여 탭바까지 포함
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
            currentStep = .finalTodayTopic
        case .finalTodayTopic:
            completeTutorial()
            return
        }
        showCurrentStep()
    }
    
    private func showCurrentStep() {
        removeCurrentOverlay()
        
        guard let homeVC = homeViewController,
              let tabBarVC = tabBarController,
              let homeView = homeVC.view as? HomeView else { return }
        
        let overlay = createOverlayView()
        
        // 항상 MainTabViewController의 view에 추가
        tabBarVC.view.addSubview(overlay)
        overlay.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.overlayView = overlay
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        overlay.addGestureRecognizer(tapGesture)
        
        // 레이아웃이 완료될 때까지 대기
        homeVC.view.layoutIfNeeded()
        tabBarVC.view.layoutIfNeeded()
        
        switch currentStep {
        case .todayTopic:
            highlightTodayTopicSection(in: overlay, homeView: homeView)
        case .randomCourse:
            highlightRandomCourseSection(in: overlay, homeView: homeView)
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
        // 양쪽 끝에 붙이고, 밑 테두리는 조금 올리기
        let highlightFrame = CGRect(
            x: 0,
            y: combinedFrame.minY - 12,
            width: overlay.frame.width,
            height: combinedFrame.maxY - combinedFrame.minY + 12 - 20 // 밑 테두리 20pt 올림
        )
        
        // 테두리 안쪽 영역 (테두리 두께 3pt 제외)
        let excludeArea = highlightFrame.insetBy(dx: 3, dy: 3)
        
        createHighlightView(in: overlay, frame: highlightFrame, description: currentStep.description, position: .top, isSpecialLayout: true, excludeArea: excludeArea)
    }
    
    private func highlightRandomCourseSection(in overlay: UIView, homeView: HomeView) {
        guard let tabBarVC = tabBarController else { return }
        
        let labelFrame = homeView.convert(homeView.randomLabel.frame, to: overlay)
        let viewFrame = homeView.convert(homeView.randomView.frame, to: overlay)
        
        let combinedFrame = labelFrame.union(viewFrame)
        // 탭바 전까지만 (탭바 높이 78)
        let tabBarTop = overlay.frame.height - 78
        let bottomY = min(combinedFrame.maxY + 12, tabBarTop)
        
        // 양쪽 끝에 붙이고, 밑 테두리는 탭바 전까지
        let highlightFrame = CGRect(
            x: 0,
            y: combinedFrame.minY - 12,
            width: overlay.frame.width,
            height: bottomY - (combinedFrame.minY - 12)
        )
        
        // 테두리 안쪽 영역 (테두리 두께 3pt 제외)
        let excludeArea = highlightFrame.insetBy(dx: 3, dy: 3)
        
        createHighlightView(in: overlay, frame: highlightFrame, description: currentStep.description, position: .top, isSpecialLayout: true, excludeArea: excludeArea)
    }
    
    private func showFinalMessage(in overlay: UIView) {
        // 보라색 테두리 없이 텍스트만 화면 가운데에 표시
        let descriptionLabel = UILabel()
        descriptionLabel.text = currentStep.description
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        overlay.addSubview(descriptionLabel)
        self.descriptionLabel = descriptionLabel
        
        // 설명 레이블 크기 계산
        let maxWidth = overlay.frame.width - 48
        let labelSize = currentStep.description.size(
            withAttributes: [NSAttributedString.Key.font: descriptionLabel.font!]
        )
        let labelWidth = min(max(labelSize.width, 200), maxWidth)
        let labelHeight = currentStep.description.height(
            withConstrainedWidth: labelWidth,
            font: descriptionLabel.font
        )
        
        // 화면 가운데에 배치
        let labelX = overlay.frame.midX - labelWidth / 2
        let labelY = overlay.frame.midY - labelHeight / 2
        
        descriptionLabel.frame = CGRect(
            x: labelX,
            y: labelY,
            width: labelWidth,
            height: labelHeight
        )
    }
    
    private enum DescriptionPosition {
        case top
        case bottom
    }
    
    private func createHighlightView(in overlay: UIView, frame: CGRect, description: String, position: DescriptionPosition, isSpecialLayout: Bool = false, excludeArea: CGRect? = nil, isTabBar: Bool = false) {
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
            highlight.layer.cornerRadius = 0 // 둥근 모서리 제거
        }
        
        self.highlightView = highlight
        
        // 테두리 안 영역을 overlay에서 제외 (어둡게 처리되지 않도록)
        if let excludeArea = excludeArea {
            applyMaskToOverlay(overlay, excluding: excludeArea)
        }
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = isSpecialLayout ? .left : .center
        descriptionLabel.numberOfLines = 0
        
        overlay.addSubview(descriptionLabel)
        self.descriptionLabel = descriptionLabel
        
        // 설명 레이블 크기 계산
        let maxWidth = min(frame.width + 40, overlay.frame.width - 48)
        let labelSize = description.size(
            withAttributes: [NSAttributedString.Key.font: descriptionLabel.font!]
        )
        let labelWidth = min(max(labelSize.width, 200), maxWidth)
        let labelHeight = description.height(
            withConstrainedWidth: labelWidth,
            font: descriptionLabel.font
        )
        
        // 설명 레이블 위치 설정
        let labelX: CGFloat
        let labelY: CGFloat
        
        if isSpecialLayout {
            // todayTopic, randomCourse: 왼쪽에서 25만큼, 테두리 위로 10만큼
            labelX = 25
            labelY = frame.minY - labelHeight - 10
        } else {
            // 기존 로직: 중앙 정렬
            labelX = overlay.frame.midX - labelWidth / 2
            if position == .top {
                labelY = frame.minY - labelHeight - 16
            } else {
                labelY = frame.maxY + 16
            }
        }
        
        descriptionLabel.frame = CGRect(
            x: labelX,
            y: max(labelY, 20),
            width: labelWidth,
            height: labelHeight
        )
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
    
    private func removeCurrentOverlay() {
        overlayView?.layer.mask = nil // 마스크 제거
        overlayView?.removeFromSuperview()
        overlayView = nil
        highlightView = nil
        descriptionLabel = nil
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

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        return ceil(boundingBox.height)
    }
}
