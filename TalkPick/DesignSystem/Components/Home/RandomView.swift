//
//  RandomView.swift
//  TalkPick
//
//  Created by jaegu park on 10/8/25.
//

import UIKit
import SnapKit

class RandomView: UIView {
    
    let navigationbarView = RandomNavigationBarView(title: "뒤로 가기")
    
    private let situationView = SituationView()
    private let topicView = TopicView()
    private let detailView = TopicDetailView()
    private let finishView = FinishView()
    
    private var currentView: UIView?
    
    private var isCloseRelationship: Bool?
    private var selectedSituation: SituationView.SituationKind?
    private var selectedTopics: [TopicModel] = []
    
    private var currentStep: Step = .situation
    private var history: [Step] = []
    
    private let topicData: [[TopicModel]] = [
        [TopicModel(id: "", tagTitle: "#만약에", title: "MBTI 야구 게임", color: .pink50, textColor: .pink100, imageName: "talkpick_topic1"), TopicModel(id: "", tagTitle: "가족", title: "MBTI 야구 게임", color: .purple50, textColor: .purple100, imageName: "talkpick_topic2"), TopicModel(id: "", tagTitle: "그룹 첫 모임", title: "MBTI 야구 게임", color: .yellow50, textColor: .yellow100, imageName: "talkpick_topic3"), TopicModel(id: "", tagTitle: "친구", title: "MBTI 야구 게임", color: .orange50, textColor: .orange100, imageName: "talkpick_topic4")],
        [TopicModel(id: "", tagTitle: "#만약에", title: "MBTI 야구 게임", color: .pink50, textColor: .pink100, imageName: "talkpick_topic1"), TopicModel(id: "", tagTitle: "가족", title: "MBTI 야구 게임", color: .purple50, textColor: .purple100, imageName: "talkpick_topic2"), TopicModel(id: "", tagTitle: "그룹 첫 모임", title: "MBTI 야구 게임", color: .yellow50, textColor: .yellow100, imageName: "talkpick_topic3"), TopicModel(id: "", tagTitle: "친구", title: "MBTI 야구 게임", color: .orange50, textColor: .orange100, imageName: "talkpick_topic4")],
        [TopicModel(id: "", tagTitle: "#만약에", title: "MBTI 야구 게임", color: .pink50, textColor: .pink100, imageName: "talkpick_topic1"), TopicModel(id: "", tagTitle: "가족", title: "MBTI 야구 게임", color: .purple50, textColor: .purple100, imageName: "talkpick_topic2"), TopicModel(id: "", tagTitle: "그룹 첫 모임", title: "MBTI 야구 게임", color: .yellow50, textColor: .yellow100, imageName: "talkpick_topic3"), TopicModel(id: "", tagTitle: "친구", title: "MBTI 야구 게임", color: .orange50, textColor: .orange100, imageName: "talkpick_topic4")],
        [TopicModel(id: "", tagTitle: "#만약에", title: "MBTI 야구 게임", color: .pink50, textColor: .pink100, imageName: "talkpick_topic1"), TopicModel(id: "", tagTitle: "가족", title: "MBTI 야구 게임", color: .purple50, textColor: .purple100, imageName: "talkpick_topic2"), TopicModel(id: "", tagTitle: "그룹 첫 모임", title: "MBTI 야구 게임", color: .yellow50, textColor: .yellow100, imageName: "talkpick_topic3"), TopicModel(id: "", tagTitle: "친구", title: "MBTI 야구 게임", color: .orange50, textColor: .orange100, imageName: "talkpick_topic4")]
    ]
    
    var onExitRequested: (() -> Void)?
    
    enum Step {
        case situation                  // 1,2번째 화면(현재 SituationView 안에서 상태 전환)
        case topicSelect(step: Int)     // 3,5,7,9번째 화면
        case topicDetail(step: Int)     // 각 주제 상세 화면
        case finish                     // 마지막 별점
    }
    
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
        if pushHistory { history.append(currentStep) }
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
            self?.isCloseRelationship = isClose
            // SituationView 안에서 이미 state를 pickSituation으로 넘기고 있으니
            // 여기서는 따로 화면 교체 안해도 됨
        }

        // 2) 소개팅/과팅, 그룹 첫 모임 등 상황 선택 완료
        situationView.onSituationSelected = { [weak self] kind in
            self?.selectedSituation = kind
            self?.show(step: .topicSelect(step: 0))   // 첫 번째 주제 선택 화면으로
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
}
