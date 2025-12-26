
import UIKit
import SnapKit

class AgreeView: UIView {
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = true
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let navigationbarView = NavigationBarView(title: "회원가입")
    
    private let characterImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "talkpick_agree")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let agreementTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "약관동의"
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    private let agreementSubLabel: UILabel = {
        let label = UILabel()
        label.text = "필수항목 및 선택항목 약관에 동의해 주세요."
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray200
        return label
    }()
    
    private let allAgreeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let allAgreeCheck: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "talkpick_noncheck")
        return iv
    }()
    
    private let allAgreeLabel: UILabel = {
        let label = UILabel()
        label.text = "전체동의"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var row1 = makeAgreementRow(title: "서비스 이용약관 동의", type: "필수", rowId: 1, detailHeight: 150)
    lazy var row2 = makeAgreementRow(title: "개인정보 수집 및 이용 동의", type: "필수", rowId: 2, detailHeight: 150)
    lazy var row3 = makeAgreementRow(title: "만 14세 이상입니다", type: "필수", rowId: 3, detailHeight: 80)
    
    let nextButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("다음으로", for: .normal)
        bt.backgroundColor = .white
        bt.setTitleColor(.gray200, for: .normal)
        bt.layer.borderColor = UIColor.gray200.cgColor
        bt.layer.borderWidth = 1
        bt.layer.cornerRadius = 10
        bt.isEnabled = false
        bt.titleLabel?.font = .boldSystemFont(ofSize: 18)
        bt.applyTextButtonPressEffect()
        return bt
    }()
    
    private var allAgree = false
    private var agree1 = false
    private var agree2 = false
    private var agree3 = false
    
    private var isExpanded1 = false
    private var isExpanded2 = false
    private var isExpanded3 = false
    
    private var detailHeights: [Int: CGFloat] = [:] // rowId: detailHeight
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(navigationbarView)
        addSubview(scrollView)
        addSubview(nextButton)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(characterImageView)
        contentView.addSubview(agreementTitleLabel)
        contentView.addSubview(agreementSubLabel)
        contentView.addSubview(allAgreeContainer)
        
        let rows = [row1, row2, row3]
        rows.forEach { contentView.addSubview($0) }
        
        // headerView에만 제스처 추가 (화살표는 별도 처리)
        if let headerView1 = row1.viewWithTag(200) {
            headerView1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRow1)))
        }
        if let headerView2 = row2.viewWithTag(200) {
            headerView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRow2)))
        }
        if let headerView3 = row3.viewWithTag(200) {
            headerView3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRow3)))
        }
        
        allAgreeContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAllAgree)))
    }
    
    private func setupConstraints() {
        navigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-16)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        characterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(40)
        }
        
        agreementTitleLabel.snp.makeConstraints {
            $0.top.equalTo(characterImageView.snp.bottom)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(35)
        }
        
        agreementSubLabel.snp.makeConstraints {
            $0.top.equalTo(agreementTitleLabel.snp.bottom)
            $0.leading.equalTo(agreementTitleLabel)
            $0.height.equalTo(20)
        }
        
        allAgreeContainer.addSubview(allAgreeCheck)
        allAgreeContainer.addSubview(allAgreeLabel)
        
        allAgreeContainer.snp.makeConstraints {
            $0.top.equalTo(agreementSubLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(55)
        }
        
        allAgreeCheck.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(18)
        }
        
        allAgreeLabel.snp.makeConstraints {
            $0.leading.equalTo(allAgreeCheck.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(23)
        }
        
        row1.snp.makeConstraints {
            $0.top.equalTo(allAgreeContainer.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        row2.snp.makeConstraints {
            $0.top.equalTo(row1.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(row1)
        }
        row3.snp.makeConstraints {
            $0.top.equalTo(row2.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(row1)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().offset(-44)
            $0.height.equalTo(51)
        }
    }
    
    private func makeAgreementRow(title: String, type: String, rowId: Int, detailHeight: CGFloat) -> UIView {
        let container = UIView()
        container.isUserInteractionEnabled = true
        container.tag = rowId
        
        // detailHeight 저장
        detailHeights[rowId] = detailHeight
        
        let headerView = UIView()
        headerView.tag = 200
        headerView.isUserInteractionEnabled = true
        
        let checkIcon = UIImageView()
        checkIcon.image = UIImage(named: "talkpick_noncheck")
        checkIcon.tag = 100
        
        let badgeView = UIView()
        badgeView.backgroundColor = .purple50
        badgeView.layer.cornerRadius = 8
        
        let badgeLabel = UILabel()
        badgeLabel.text = type
        badgeLabel.font = .systemFont(ofSize: 10, weight: .semibold)
        badgeLabel.textColor = .purple100
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 14)
        
        let arrowIcon = UIImageView()
        arrowIcon.image = UIImage(named: "talkpick_down")
        arrowIcon.isUserInteractionEnabled = true
        arrowIcon.tag = 300
        
        let detailContainer = UIView()
        detailContainer.tag = 400
        detailContainer.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        detailContainer.layer.cornerRadius = 8
        detailContainer.clipsToBounds = true
        detailContainer.isHidden = true
        detailContainer.alpha = 0
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.tag = 500
        
        let detailLabel = UILabel()
        detailLabel.tag = 600
        detailLabel.numberOfLines = 0
        detailLabel.font = .systemFont(ofSize: 10, weight: .medium)
        detailLabel.textColor = .gray
        
        container.addSubview(headerView)
        container.addSubview(detailContainer)
        
        headerView.addSubview(checkIcon)
        headerView.addSubview(badgeView)
        badgeView.addSubview(badgeLabel)
        headerView.addSubview(titleLabel)
        headerView.addSubview(arrowIcon)
        
        detailContainer.addSubview(scrollView)
        scrollView.addSubview(detailLabel)
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(39)
        }
        
        checkIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(18)
        }
        
        badgeView.snp.makeConstraints {
            $0.leading.equalTo(checkIcon.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(18)
        }
        
        badgeLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(6)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(badgeView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        arrowIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(14)
            $0.height.equalTo(8)
        }
        
        detailContainer.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(0)
            $0.bottom.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
        
        detailLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        // 화살표 아이콘 탭 제스처
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapArrow(_:)))
        arrowIcon.addGestureRecognizer(tapGesture)
        
        return container
    }
    
    private func updateUI() {
        updateCheckIcon(allAgreeCheck, isOn: allAgree)
        updateCheckIcon(checkIcon(in: row1)!, isOn: agree1)
        updateCheckIcon(checkIcon(in: row2)!, isOn: agree2)
        updateCheckIcon(checkIcon(in: row3)!, isOn: agree3)

        allAgree = agree1 && agree2 && agree3
        updateCheckIcon(allAgreeCheck, isOn: allAgree)

        // 필수 3개 + 만14세 모두 체크해야 활성화
        if agree1 && agree2 && agree3 {
            nextButton.isEnabled = true
            nextButton.backgroundColor = .black
            nextButton.setTitleColor(.white, for: .normal)
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .white
            nextButton.setTitleColor(.gray200, for: .normal)
            nextButton.layer.borderColor = UIColor.gray200.cgColor
            nextButton.layer.borderWidth = 1
        }
    }
    
    @objc private func didTapAllAgree() {
        let newState = !allAgree
        allAgree = newState
        agree1 = newState
        agree2 = newState
        agree3 = newState
        updateUI()
    }

    @objc private func didTapRow1() {
        agree1.toggle()
        updateUI()
    }

    @objc private func didTapRow2() {
        agree2.toggle()
        updateUI()
    }

    @objc private func didTapRow3() {
        agree3.toggle()
        updateUI()
    }
    
    @objc private func didTapArrow(_ gesture: UITapGestureRecognizer) {
        guard let arrowIcon = gesture.view as? UIImageView,
              let headerView = arrowIcon.superview,
              let container = headerView.superview,
              let detailContainer = container.viewWithTag(400) else { return }
        
        let rowId = container.tag
        let isCurrentlyExpanded: Bool
        
        switch rowId {
        case 1:
            isExpanded1.toggle()
            isCurrentlyExpanded = isExpanded1
        case 2:
            isExpanded2.toggle()
            isCurrentlyExpanded = isExpanded2
        case 3:
            isExpanded3.toggle()
            isCurrentlyExpanded = isExpanded3
        default:
            return
        }
        
        // 해당 row의 상세 내용 높이 가져오기
        let height = detailHeights[rowId] ?? 150
        
        // 애니메이션과 함께 상세 내용 표시/숨김
        UIView.animate(withDuration: 0.3, animations: {
            if isCurrentlyExpanded {
                detailContainer.isHidden = false
                detailContainer.alpha = 1
                detailContainer.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
                arrowIcon.transform = CGAffineTransform(rotationAngle: .pi) // 180도 회전
            } else {
                detailContainer.alpha = 0
                detailContainer.snp.updateConstraints {
                    $0.height.equalTo(0)
                }
                arrowIcon.transform = .identity
            }
            self.layoutIfNeeded()
        }, completion: { _ in
            if !isCurrentlyExpanded {
                detailContainer.isHidden = true
            }
        })
    }

    private func checkIcon(in row: UIView) -> UIImageView? {
        guard let headerView = row.viewWithTag(200) else { return nil }
        return headerView.viewWithTag(100) as? UIImageView
    }
    
    private func updateCheckIcon(_ icon: UIImageView, isOn: Bool) {
        icon.image = UIImage(named: isOn ? "talkpick_check" : "talkpick_noncheck")
    }
    
    // 상세 내용 설정 함수 (외부에서 호출 가능)
    func setDetailText(for row: Int, text: String) {
        let container: UIView?
        switch row {
        case 1: container = row1
        case 2: container = row2
        case 3: container = row3
        default: return
        }
        
        guard let container = container,
              let detailContainer = container.viewWithTag(400),
              let scrollView = detailContainer.viewWithTag(500) as? UIScrollView,
              let detailLabel = scrollView.viewWithTag(600) as? UILabel else { return }
        
        detailLabel.text = text
    }
    
    func configureTermsContent() {
        setDetailText(for: 1, text: TermsContent.serviceTerms)
        setDetailText(for: 2, text: TermsContent.privacyPolicy)
        setDetailText(for: 3, text: TermsContent.ageConfirmation)
    }
}
