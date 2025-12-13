
import UIKit
import SnapKit

class MypageView: UIView {
    
    private let titleLabel = UILabel()
    private let infoSectionView: SectionView
    let collectionSectionView: CollectionSectionView
    let etcSectionView: EtcSectionView
    private let withdrawButton = UIButton(type: .system)
    
    var editMbtiView: EditMbtiView?
    
    override init(frame: CGRect) {
        // 1) 내 정보 섹션
        let infoRows: [SectionView.RowType] = [
            .info(icon: "talkpick_nickname", title: "닉네임",   value: "닉네임"),
            .info(icon: "talkpick_mbti",     title: "MBTI",    value: "INTP")
        ]
        infoSectionView = SectionView(title: "내 정보", rows: infoRows)
        
        // 2) 컬렉션 섹션
        collectionSectionView = CollectionSectionView(
            title: "컬렉션",
            itemTitle: "좋아요 누른 대화 주제",
            moreText: "더보기"
        )
        
        // 3) 기타 섹션
        etcSectionView = EtcSectionView(rows: [
            .arrowRow(icon: "talkpick_notice", title: "공지사항"),
            .arrowRow(icon: "talkpick_ask", title: "문의")
        ])
        
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        // 상단 "My Page"
        titleLabel.text = "My Page"
        titleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        // 하단 "회원탈퇴"
        withdrawButton.setTitle("회원탈퇴", for: .normal)
        withdrawButton.setTitleColor(.gray100, for: .normal)
        withdrawButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        
        addSubview(titleLabel)
        addSubview(infoSectionView)
        addSubview(collectionSectionView)
        addSubview(etcSectionView)
        addSubview(withdrawButton)
    }
    
    private func setupLayout() {
        // 상단 타이틀
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(69)
            $0.centerX.equalToSuperview()
        }
        
        // 내 정보
        infoSectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        infoSectionView.actionButton.addTarget(self, action: #selector(edit_Tapped), for: .touchUpInside)
        
        // 컬렉션
        collectionSectionView.snp.makeConstraints {
            $0.top.equalTo(infoSectionView.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(infoSectionView)
        }
        
        // 기타
        etcSectionView.snp.makeConstraints {
            $0.top.equalTo(collectionSectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(infoSectionView)
        }
        
        // 회원탈퇴
        withdrawButton.snp.makeConstraints {
            $0.top.equalTo(etcSectionView.snp.bottom).offset(10)
            $0.trailing.equalTo(etcSectionView)
            $0.bottom.lessThanOrEqualTo(safeAreaLayoutGuide.snp.bottom).inset(16)
        }
    }
    
    // 값 바꾸고 싶을 때
    func updateProfile(_ newName: String, _ newMbti: String) {
        infoSectionView.updateValue(for: "닉네임", to: newName)
        infoSectionView.updateValue(for: "MBTI", to: newMbti)
    }
    
    @objc func edit_Tapped() {
        guard let editMbtiView = editMbtiView else {
            print("editMbtiView 가 아직 주입되지 않았습니다.")
            return
        }
        
        if editMbtiView.superview == nil {
            addSubview(editMbtiView)
            editMbtiView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        editMbtiView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            editMbtiView.alpha = 1
        }
    }
}
