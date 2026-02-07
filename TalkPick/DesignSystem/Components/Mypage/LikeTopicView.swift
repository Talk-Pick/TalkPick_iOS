
import UIKit
import SnapKit
import SkeletonView

class LikeTopicView: UIView {
    
    let navigationbarView = NavigationBarView(title: "좋아요 누른 대화 주제")
    
    let likeTopicTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        tv.register(LikeTopicTableViewCell.self, forCellReuseIdentifier: LikeTopicTableViewCell.identifier)
        return tv
    }()
    
    let noLikeView = NoLikeView()
    
    private let listSkeletonView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.isHidden = true
        return v
    }()
    
    private let skeletonRow1: UIView = {
        let v = UIView()
        v.backgroundColor = .gray50
        v.layer.cornerRadius = 10
        return v
    }()
    
    private let skeletonRow2: UIView = {
        let v = UIView()
        v.backgroundColor = .gray50
        v.layer.cornerRadius = 10
        return v
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(navigationbarView)
        addSubview(likeTopicTableView)
        addSubview(noLikeView)
        addSubview(listSkeletonView)
        listSkeletonView.addSubview(skeletonRow1)
        listSkeletonView.addSubview(skeletonRow2)
    }
    
    private func setupConstraints() {
        navigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        likeTopicTableView.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        noLikeView.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom).offset(100)
            $0.leading.trailing.equalToSuperview().inset(53)
            $0.height.equalTo(601)
            $0.bottom.equalToSuperview()
        }
        
        listSkeletonView.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        skeletonRow1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(121)
        }
        
        skeletonRow2.snp.makeConstraints {
            $0.top.equalTo(skeletonRow1.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(121)
        }
        
        listSkeletonView.isSkeletonable = true
        skeletonRow1.isSkeletonable = true
        skeletonRow2.isSkeletonable = true
    }
    
    func showListSkeleton() {
        listSkeletonView.isHidden = false
        listSkeletonView.showAnimatedSkeleton()
    }
    
    func hideListSkeleton() {
        listSkeletonView.hideSkeleton()
        listSkeletonView.isHidden = true
    }
}
