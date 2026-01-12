
import UIKit
import SnapKit
import Kingfisher

class TopicDetailView: UIView {
    var onNext: (() -> Void)?
    var onLikeToggled: ((Bool) -> Void)?

    private let labelView1: UIView = {
        let uv = UIView()
        uv.backgroundColor = .yellow50
        uv.layer.cornerRadius = 15
        return uv
    }()
    
    let labelLabel1: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 12, weight: .semibold)
        lb.textColor = .yellow100
        return lb
    }()
    
    private let labelView2: UIView = {
        let uv = UIView()
        uv.backgroundColor = .pink50
        uv.layer.cornerRadius = 15
        return uv
    }()
    
    let stepLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 12, weight: .semibold)
        lb.textColor = .pink100
        return lb
    }()
    
    let cardView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let flipButton: UIButton = {
        let fb = UIButton(type: .custom)
        fb.setImage(UIImage(named: "talkpick_flip")?.withRenderingMode(.alwaysOriginal), for: .normal)
        fb.setTitle("카드 뒤집기 ", for: .normal)
        fb.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        fb.setTitleColor(.gray100, for: .normal)
        fb.semanticContentAttribute = .forceRightToLeft
        return fb
    }()

    private let likeButton: UIButton = {
        let cb = UIButton(type: .custom)
        cb.clipsToBounds = true
        cb.layer.cornerRadius = 10
        cb.layer.borderWidth = 1
        cb.layer.borderColor = UIColor.gray200.cgColor
        cb.backgroundColor = .white
        cb.setTitleColor(.gray200, for: .normal)
        cb.setTitle(" 좋아요", for: .normal)
        cb.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return cb
    }()
    
    private lazy var nextButton: UIButton = {
        let cb = UIButton(type: .custom)
        cb.backgroundColor = .black
        cb.setTitleColor(.white, for: .normal)
        cb.setTitle("다음으로", for: .normal)
        cb.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        cb.layer.cornerRadius = 10
        cb.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return cb
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(likeButton)
        sv.addArrangedSubview(nextButton)
        sv.axis = .horizontal
        sv.spacing = 17
        sv.distribution = .fillEqually
        return sv
    }()

    var isFront: Bool = true
    private var isLiked = false
    
    private var frontURL: URL?
    private var backURL: URL?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        backgroundColor = .white

        addSubview(labelView1)
        labelView1.addSubview(labelLabel1)
        addSubview(labelView2)
        labelView2.addSubview(stepLabel)
        
        addSubview(cardView)
        addSubview(flipButton)
        addSubview(buttonsStack)
    }

    private func setupLayout() {
        
        labelView1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(35)
            $0.height.equalTo(31)
        }
        
        labelLabel1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(14)
        }
        
        labelView2.snp.makeConstraints {
            $0.centerY.equalTo(labelView1)
            $0.leading.equalTo(labelView1.snp.trailing).offset(8)
            $0.height.equalTo(31)
        }
        
        stepLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(14)
        }

        cardView.snp.makeConstraints {
            $0.top.equalTo(labelView1.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(450)
        }
        let cardTapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        cardView.addGestureRecognizer(cardTapGesture)

        flipButton.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22)
            $0.width.equalTo(90)
        }
        flipButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        buttonsStack.snp.makeConstraints {
            $0.top.equalTo(flipButton.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(51)
        }
    }

    func configure(stepIndex: Int) {
        let stepTitles = ["첫 번째", "두 번째", "세 번째"]
        stepLabel.text = stepTitles.indices.contains(stepIndex) ? stepTitles[stepIndex] : ""
    }
    
    func updateDetail(category: String, categoryBgColor: UIColor, categoryTextColor: UIColor, frontImageUrl: String, backImageUrl: String) {
        // 카테고리 업데이트
        labelLabel1.text = category
        labelView1.backgroundColor = categoryBgColor
        labelLabel1.textColor = categoryTextColor
        
        // 이미지 URL 저장
        frontURL = URL(string: frontImageUrl)
        backURL = URL(string: backImageUrl)
        
        // 앞뒷면 이미지 프리페칭
        prefetchImages()
        
        // 현재 상태에 맞는 이미지 로드
        updateCardImage()
    }
    
    private func prefetchImages() {
        let urls = [frontURL, backURL].compactMap { $0 }
        guard !urls.isEmpty else { return }
        
        // 실제 표시될 이미지 크기 계산 (더 정확한 다운샘플링을 위해)
        let targetSize = calculateTargetImageSize()
        
        // 다운샘플링 프로세서로 프리페칭하여 메모리 사용 최적화
        let processor = DownsamplingImageProcessor(size: targetSize)
        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage,
            .backgroundDecode, // 백그라운드 스레드에서 디코딩
            .loadDiskFileSynchronously // 디스크 캐시 동기 로드로 더 빠른 응답
        ]
        
        ImagePrefetcher(urls: urls, options: options).start()
    }
    
    private func calculateTargetImageSize() -> CGSize {
        // 실제 표시될 이미지 크기 계산
        // 화면 너비에서 좌우 inset(18*2)을 뺀 값과 높이(460) 사용
        let screenWidth = UIScreen.main.bounds.width
        let imageWidth = screenWidth - (18 * 2)
        let imageHeight: CGFloat = 460
        
        // 레티나 디스플레이를 고려한 실제 픽셀 크기
        let scale = UIScreen.main.scale
        return CGSize(width: imageWidth * scale, height: imageHeight * scale)
    }
    
    private func updateCardImage() {
        let url = isFront ? frontURL : backURL
        guard let url = url else { return }
        
        // 실제 표시될 크기로 다운샘플링하여 메모리 사용 최적화
        let targetSize = calculateTargetImageSize()
        let processor = DownsamplingImageProcessor(size: targetSize)
        
        // 캐시 우선 확인 및 최적화된 옵션
        cardView.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.none),
                .cacheOriginalImage, // 원본 이미지도 캐시하여 나중에 다른 크기로 사용 가능
                .fromMemoryCacheOrRefresh, // 메모리 캐시 우선 확인
                .backgroundDecode, // 백그라운드 스레드에서 디코딩하여 UI 블로킹 방지
                .loadDiskFileSynchronously // 디스크 캐시 동기 로드로 더 빠른 응답
            ],
            progressBlock: nil,
            completionHandler: nil
        )
    }

    @objc private func toggleLike() {
        isLiked.toggle()
        onLikeToggled?(isLiked)
    }

    @objc private func nextTapped() {
        onNext?()
    }
    
    @objc func buttonTapped() {
        // 이미지 전환 방향 결정
        let options: UIView.AnimationOptions = isFront ? .transitionFlipFromRight : .transitionFlipFromLeft
        
        // 상태 전환
        isFront.toggle()
        
        // 자연스러운 카드 뒤집기 애니메이션
        UIView.transition(with: cardView,
                          duration: 0.6,
                          options: [options, .curveEaseInOut],
                          animations: { [weak self] in
                              self?.updateCardImage()
                          },
                          completion: nil)
    }
}
