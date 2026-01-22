
import UIKit
import SnapKit
import RxSwift

class RandomCourseView: UIView {
    
    private let randomViewModel = RandomViewModel()
    private let topicViewModel = TopicViewModel()
    private let myPageViewModel = MyPageViewModel()
    private let randomId = UserDefaults.standard.integer(forKey: "randomId")
    private let disposeBag = DisposeBag()
    
    private var currentTopicId: Int?
    private var isLiked: Bool = false
    
    private let totalSteps: Int = 8
    private var currentStepNumber: Int = 1
    
    private var selectedTopics: [TopicModel] = []
    
    private var currentStep: Step = .situation
    private var history: [Step] = []
    
    private var situationText: String?
    
    private var topicData: [[TopicModel]] = Array(repeating: [], count: 3)
    private var topicRecords: [TotalRecord] = []
    
    var onExitRequested: (() -> Void)?
    
    enum Step {
        case situation
        case topicSelect(step: Int)
        case topicDetail(step: Int)
        case finish
    }
    
    let navigationbarView = RandomNavigationBarView(title: "뒤로 가기")
    private let situationView = SituationView()
    private let topicView = TopicView()
    let detailView = TopicDetailView()
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
            $0.height.equalTo(40)
            $0.width.equalTo(100)
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

        // backButton 표시/숨김 제어
        updateBackButtonVisibility(for: step)
        // progress 이미지 및 표시/숨김 제어
        updateProgressVisibility(for: step)

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
    
    private func updateBackButtonVisibility(for step: Step) {
        switch step {
        case .situation:
            navigationbarView.backButton.isHidden = false
            navigationbarView.titleLabel.isHidden = false
        case .topicSelect, .topicDetail, .finish:
            navigationbarView.backButton.isHidden = true
            navigationbarView.titleLabel.isHidden = true
        }
    }
    
    private func updateProgressVisibility(for step: Step) {
        switch step {
        case .situation, .finish:
            navigationbarView.progress.isHidden = true
        case .topicSelect(let index), .topicDetail(let index):
            navigationbarView.progress.isHidden = false
            let imageName: String
            switch index {
            case 0:
                imageName = "talkpick_progress1"
            case 1:
                imageName = "talkpick_progress2"
            case 2:
                imageName = "talkpick_progress3"
            default:
                imageName = "talkpick_progress1"
            }
            navigationbarView.progress.image = UIImage(named: imageName)
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
        situationView.onSituationSelected = { [weak self] categoryTitle in
            guard let self = self else { return }
            self.situationText = categoryTitle
            self.show(step: .topicSelect(step: 0))
        }
        
        finishView.onFinished = { [weak self] in
            guard let self = self else { return }
            self.onExitRequested?()
        }
        
        myPageViewModel.likeTopicList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] likedTopics in
                guard let self = self, let topicId = self.currentTopicId else { return }
                self.isLiked = likedTopics.contains(where: { $0.topicId == topicId })
                self.updateLikeButton()
            })
            .disposed(by: disposeBag)
    }

    private func configureTopicView(for stepIndex: Int) {
        fetchTopicsIfNeeded(for: stepIndex)
        
        topicView.configure(stepIndex: stepIndex,
                            topics: topicData[stepIndex])

        topicView.onTopicSelected = { [weak self] topic in
            guard let self else { return }
            
            if self.selectedTopics.count > stepIndex {
                self.selectedTopics[stepIndex] = topic
            } else {
                self.selectedTopics.append(topic)
            }
            
            guard let topicId = Int(topic.id) else { return }
            let record = TotalRecord(
                topicId: topicId,
                order: stepIndex + 1,
                startAt: Date().toISO8601String(),
                endAt: nil
            )
            
            if self.topicRecords.count > stepIndex {
                self.topicRecords[stepIndex] = record
            } else {
                self.topicRecords.append(record)
            }
            
            self.show(step: .topicDetail(step: stepIndex))
        }
    }
    
    private func configureDetailView(for stepIndex: Int) {
        guard selectedTopics.indices.contains(stepIndex) else { return }
        let topic = selectedTopics[stepIndex]
        
        detailView.configure(stepIndex: stepIndex)
        
        if let topicId = Int(topic.id) {
            currentTopicId = topicId
            fetchTopicDetail(topicId: topicId)
            myPageViewModel.getLikedTopics(cursor: nil, size: "10")
        }

        detailView.onNext = { [weak self] in
            guard let self else { return }
            
            if self.topicRecords.indices.contains(stepIndex) {
                self.topicRecords[stepIndex].endAt = Date().toISO8601String()
            }
            
            if stepIndex < 2 {
                self.show(step: .topicSelect(step: stepIndex + 1))
            } else {
                self.submitTopicRecords()
                self.show(step: .finish)
            }
        }
        
        detailView.onLikeToggled = { [weak self] in
            guard let self = self, let topicId = self.currentTopicId else { return }
            // 현재 좋아요 상태를 토글
            self.isLiked.toggle()
            self.updateLikeButton()
            self.topicViewModel.postTopicLike(topicId: topicId)
        }
    }
    
    func handleBack() {
        switch currentStep {
        case .situation:
            onExitRequested?()
            
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
        guard topicData[stepIndex].isEmpty else { return }
        
        guard let situation = situationText else { return }
        
        randomViewModel.getRandomTopics(
            id: randomId,
            order: currentStepNumber,
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
        guard topicRecords.count == 3 else {
            return
        }
        
        randomViewModel.postRandomTotalRecord(id: randomId, totalRecords: topicRecords)
    }
    
    private func updateLikeButton() {
        if isLiked {
            let image = UIImage(named: "talkpick_like2")?.withRenderingMode(.alwaysOriginal)
            detailView.likeButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "talkpick_like3")?.withRenderingMode(.alwaysOriginal)
            detailView.likeButton.setImage(image, for: .normal)
        }
        // 버튼은 항상 활성화 상태로 유지 (토글 가능하도록)
        detailView.likeButton.isEnabled = true
    }
}
