
import UIKit
import SnapKit
import RxSwift

class RandomView: UIView {
    
    private let randomViewModel = RandomViewModel()
    private let topicViewModel = TopicViewModel()
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
    private var topicRecords: [TotalRecord] = []
    
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
        layoutIfNeeded()
        
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
        }
        
        situationView.onForwardStep = { [weak self] in
            guard let self = self else { return }
            self.increaseStep()
        }

        situationView.onBackwardStep = { [weak self] in
            guard let self = self else { return }
            self.decreaseStep()
        }
        
        // FinishView 콜백 설정
        finishView.onFinished = { [weak self] in
            guard let self = self else { return }
            // 한줄평 작성 완료 후 화면 종료
            self.onExitRequested?()
        }
    }

    private func configureTopicView(for stepIndex: Int) {
        // 데이터가 없으면 API 호출
        fetchTopicsIfNeeded(for: stepIndex)
        
        topicView.configure(stepIndex: stepIndex,
                            topics: topicData[stepIndex])

        topicView.onTopicSelected = { [weak self] topic in
            guard let self else { return }
            
            // 선택한 토픽 저장
            if self.selectedTopics.count > stepIndex {
                self.selectedTopics[stepIndex] = topic
            } else {
                self.selectedTopics.append(topic)
            }
            
            // TopicRecord 생성 및 저장 (토픽 선택 시간 기록)
            guard let topicId = Int(topic.id) else { return }
            let record = TotalRecord(
                topicId: topicId,
                order: stepIndex + 1, // 1-based index (1, 2, 3, 4)
                startAt: Date().toISO8601String(),
                endAt: nil
            )
            
            if self.topicRecords.count > stepIndex {
                self.topicRecords[stepIndex] = record
            } else {
                self.topicRecords.append(record)
            }
            
            print("토픽 선택 기록: step \(stepIndex + 1), topicId: \(topicId), time: \(Date())")
            
            self.show(step: .topicDetail(step: stepIndex))
        }
    }
    
    private func configureDetailView(for stepIndex: Int) {
        guard selectedTopics.indices.contains(stepIndex) else { return }
        let topic = selectedTopics[stepIndex]
        detailView.configure(stepIndex: stepIndex)
        
        // topicId로 상세 정보 가져오기
        if let topicId = Int(topic.id) {
            fetchTopicDetail(topicId: topicId)
        }

        detailView.onNext = { [weak self] in
            guard let self else { return }
            
            // endAt 업데이트 (다음으로 넘어간 시간 기록)
            if self.topicRecords.indices.contains(stepIndex) {
                self.topicRecords[stepIndex].endAt = Date().toISO8601String()
                print("다음 버튼 클릭 기록: step \(stepIndex + 1), time: \(Date().toISO8601String())")
            }
            
            if stepIndex < 3 {
                // 다음 토픽 선택 화면으로
                self.show(step: .topicSelect(step: stepIndex + 1))
            } else {
                // 마지막 단계 - API 호출 후 완료 화면으로
                self.submitTopicRecords()
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
    
    private func fetchTopicsIfNeeded(for stepIndex: Int) {
        // 이미 데이터가 있으면 API 호출하지 않음
        guard topicData[stepIndex].isEmpty else { return }
        
        guard let relationship = relationshipText,
              let situation = situationText else { return }
        
        randomViewModel.getRandomTopics(
            id: randomId,
            order: currentStepNumber,
            categoryGroup: relationship,
            category: situation
        )
        
        randomViewModel.randomTopics
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] details in
                guard let self = self else { return }
                let topics = self.mapToTopicModels(details)
                self.topicData[stepIndex] = topics
                self.topicView.configure(stepIndex: stepIndex, topics: topics)
            })
            .disposed(by: disposeBag)
    }
    
    private func mapToTopicModels(_ details: [RandomTopicDetail]) -> [TopicModel] {
        return details.map { detail in
            let style = categoryStyles[detail.category]
            return TopicModel(
                id: String(detail.topicId),
                keyword: detail.keywordName,
                category: detail.category,
                keywordColor: style?.bgColor ?? .purple50,
                categoryColor: style?.textColor ?? .purple100,
                imageName: detail.keywordIconUrl
            )
        }
    }
    
    private func fetchTopicDetail(topicId: Int) {
        topicViewModel.getTopicDetail(topicId: topicId)
        
        topicViewModel.topicDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                guard let self = self else { return }
                let style = categoryStyles[detail.category]
                
                self.detailView.updateDetail(
                    category: detail.category,
                    categoryBgColor: style?.bgColor ?? .yellow50,
                    categoryTextColor: style?.textColor ?? .yellow100,
                    frontImageUrl: detail.keywordImageUrl,
                    backImageUrl: detail.topicImageUrl
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func submitTopicRecords() {
        guard topicRecords.count == 4 else {
            print("경고: TopicRecord가 4개가 아닙니다. 현재: \(topicRecords.count)개")
            return
        }
        
        print("=== TopicRecords 제출 ===")
        print("\(topicRecords)")
        
        // API 호출
        randomViewModel.postRandomTotalRecord(id: randomId, totalRecords: topicRecords)
    }
}
