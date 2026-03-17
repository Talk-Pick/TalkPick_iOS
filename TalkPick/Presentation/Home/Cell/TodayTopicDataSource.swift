import UIKit
import RxSwift
import RxCocoa

final class TodayTopicDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let disposeBag = DisposeBag()
    
    var topics: [Topic] = []
    var onItemSelected: ((Topic) -> Void)?
    
    func bind(topics: BehaviorRelay<[Topic]>, to collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        topics
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] newTopics in
                guard let self else { return }
                self.topics = newTopics
                collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayTopicCollectionViewCell.identifier, for: indexPath) as! TodayTopicCollectionViewCell
        cell.prepare(topic: topics[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < topics.count else { return }
        onItemSelected?(topics[indexPath.item])
    }
}
