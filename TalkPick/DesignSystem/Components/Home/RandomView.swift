//
//  RandomView.swift
//  TalkPick
//
//  Created by jaegu park on 10/8/25.
//

import UIKit
import SnapKit
import RxSwift

class RandomView: UIView {
    
    private let randomViewModel = RandomViewModel()
    private let randomId = UserDefaults.standard.integer(forKey: "randomId")
    private let disposeBag = DisposeBag()
    
    private let totalSteps: Int = 11
    private var currentStepNumber: Int = 1 {
        didSet {
            print("현재 단계: \(currentStepNumber)/\(totalSteps)")
        }
    }
    
    private var isCloseRelationship: Bool?
    private var selectedSituation: SituationView.SituationKind?
    private var selectedTopics: [TopicModel] = []
    
    private var currentStep: Step = .situation
    private var history: [Step] = []
    
    private var relationshipText: String?
    private var situationText: String?
    
    private var topicData: [[TopicModel]] = Array(repeating: [], count: 4)

    
    var onExitRequested: (() -> Void)?
    
    enum Step {
        case situation                  // 1,2번째 화면(현재 SituationView 안에서 상태 전환)
        case topicSelect(step: Int)     // 3,5,7,9번째 화면
        case topicDetail(step: Int)     // 각 주제 상세 화면
        case finish                     // 마지막 별점
    }
    
    let navigationbarView = RandomNavigationBarView(title: "뒤로 가기")
    private let situationView = SituationView()
    private let topicView = TopicView()
    private let detailView = TopicDetailView()
    private let finishView = FinishView()
    private var currentView: UIView?
    private let smallLogo: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "talkpick_smallLogo"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setupConstraints()
        bindViews()
        show(step: .situation, pushHistory: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(navigationbarView)
        addSubview(smallLogo)
    }
    
    private func setupConstraints() {
        navigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        smallLogo.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(25)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(33)
            $0.width.equalTo(111)
        }
    }
    
    private func show(step: Step, pushHistory: Bool = true) {
        if pushHistory {
            history.append(currentStep)
            increaseStep()
        } else {
            decreaseStep()
        }
        currentStep = step

        switch step {
        case .situation:
            setCurrentView(situationView)

        case .topicSelect(let index):
            configureTopicView(for: index)
            setCurrentView(topicView)

        case .topicDetail(let index):
            configureDetailView(for: index)
            setCurrentView(detailView)

        case .finish:
            setCurrentView(finishView)
        }
    }

    private func setCurrentView(_ newView: UIView) {
        let oldView = currentView
        currentView = newView
        
        addSubview(newView)
        newView.alpha = 0
        
        newView.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(smallLogo.snp.top)
        }
        layoutIfNeeded()  // 레이아웃 먼저 확정
        
        UIView.animate(withDuration: 0.25, animations: {
            newView.alpha = 1
            oldView?.alpha = 0
        }, completion: { _ in
            oldView?.removeFromSuperview()
        })
    }
    
    private func bindViews() {
        // 1) 가까운 사이 / 처음 본 사이 선택
        situationView.onRelationshipPicked = { [weak self] isClose in
            guard let self = self else { return }
            self.isCloseRelationship = isClose
            self.relationshipText = isClose ? "CLOSE" : "STRANGER"
        }

        // 2) 소개팅/과팅, 그룹 첫 모임 등 상황 선택 완료
        situationView.onSituationSelected = { [weak self] kind in
            guard let self = self else { return }
            self.selectedSituation = kind
            self.situationText = kind.koreanTitle
            self.show(step: .topicSelect(step: 0))
            guard let relationship = self.relationshipText,
                  let situation = self.situationText else { return }
            
            print("\(relationship) \(situation) \(randomId) \(currentStepNumber)")
            
            self.randomViewModel.getRandomTopics(
                id: self.randomId,
                order: self.currentStepNumber,
                categoryGroup: relationship,
                category: situation
            )
            
            self.randomViewModel.randomTopics
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] details in
                    guard let self = self else { return }
                    let topics = self.mapToTopicModels(details)
                    self.topicData[0] = topics
                    self.topicView.configure(stepIndex: 0, topics: topics)
                })
                .disposed(by: self.disposeBag)
        }
        
        situationView.onForwardStep = { [weak self] in
            guard let self = self else { return }
            self.increaseStep()
        }

        situationView.onBackwardStep = { [weak self] in
            guard let self = self else { return }
            self.decreaseStep()
        }
    }

    private func configureTopicView(for stepIndex: Int) {
        topicView.configure(stepIndex: stepIndex,
                            topics: topicData[stepIndex])

        topicView.onTopicSelected = { [weak self] topic in
            guard let self else { return }
            if self.selectedTopics.count > stepIndex {
                self.selectedTopics[stepIndex] = topic
            } else {
                self.selectedTopics.append(topic)
            }
            self.show(step: .topicDetail(step: stepIndex))
        }
    }
    
    private func configureDetailView(for stepIndex: Int) {
        guard selectedTopics.indices.contains(stepIndex) else { return }
        let topic = selectedTopics[stepIndex]
        detailView.configure(stepIndex: stepIndex, topic: topic)

        detailView.onNext = { [weak self] in
            guard let self else { return }
            if stepIndex < 3 {
                self.show(step: .topicSelect(step: stepIndex + 1))
            } else {
                self.show(step: .finish)
            }
        }
    }
    
    func handleBack() {
        switch currentStep {
        case .situation:
            if situationView.canGoBack {
                situationView.goBack()
            } else {
                onExitRequested?()
            }
            
        default:
            if let prev = history.popLast() {
                show(step: prev, pushHistory: false)
            } else {
                onExitRequested?()
            }
        }
    }
    
    func increaseStep() {
        currentStepNumber = min(totalSteps, currentStepNumber + 1)
    }
    
    func decreaseStep() {
        currentStepNumber = max(1, currentStepNumber - 1)
    }
    
    private func mapToTopicModels(_ details: [RandomTopicDetail]) -> [TopicModel] {
        return details.map { detail in
            let style = categoryStyles[detail.category]
            return TopicModel(
                id: String(detail.topicId),
                keyword: detail.keywordName,
                category: detail.category,
                keywordColor: .purple50,
                categoryColor: .purple100,
                imageName: detail.keywordIconUrl
            )
        }
    }
}
