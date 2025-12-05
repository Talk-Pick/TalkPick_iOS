//
//  CalendarViewController.swift
//  TalkPick
//
//  Created by jaegu park on 11/13/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CalendarViewController: UIViewController {
    
    private let calendarView = CalendarView()
    private let disposeBag = DisposeBag()
    private var calendarHeightConstraint: Constraint?
    
    override func loadView() {
        self.view = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindCollectionView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
    }
}

extension CalendarViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        calendarView.calendarBackground.snp.makeConstraints {
            calendarHeightConstraint = $0.height.equalTo(300).constraint
        }
    }
    
    private func bindCollectionView() {
        self.calendarView.calendarCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        calendarView.days
            .bind(to:
                    calendarView.calendarCollectionView.rx.items(cellIdentifier: CalendarCollectionViewCell.identifier, cellType: CalendarCollectionViewCell.self)) { index, day, cell in
                
                let currentMonthStartIndex = self.calendarView.startDayOfTheWeek()
                let isCurrentMonth = index >= currentMonthStartIndex &&
                index < currentMonthStartIndex + self.calendarView.endDate()
                
                let today = Date()
                let todayComponents = Calendar.current.dateComponents([.day, .month, .year], from: today)
                let calendarComponents = Calendar.current.dateComponents([.month, .year], from: self.calendarView.calendarDate)
                let isToday = day == "\(todayComponents.day!)" &&
                todayComponents.month == calendarComponents.month &&
                todayComponents.year == calendarComponents.year
                cell.updateDay(day: day, isToday: isToday, isCurrentMonth: isCurrentMonth)
            }
                    .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        calendarView.calendarCollectionView.rx.observe(CGSize.self, "contentSize")
            .compactMap { $0?.height }
            .map { $0 + 100 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] h in
                self?.calendarHeightConstraint?.update(offset: h)
                self?.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == calendarView.calendarCollectionView {
            let width = collectionView.bounds.width / 7
            return CGSize(width: width, height: 35)
        } else {
            return CGSize(width: 200, height: 108)
        }
    }
}
