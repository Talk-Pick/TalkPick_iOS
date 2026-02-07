
import UIKit
import SnapKit

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
    }
}
