
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RandomView: UIView {
    
    let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    var calendarDate = Date()
    private var calendarMonth = Date()
    private let now = Date()
    var days = BehaviorRelay<[String]>(value: [])
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "캘린더"
        lb.font = .systemFont(ofSize: 20, weight: .heavy)
        lb.textColor = .black
        return lb
    }()
    
    let calendarBackground: UIView = {
        let uv = UIView()
        uv.backgroundColor = .white
        uv.layer.cornerRadius = 10
        uv.layer.shadowColor = UIColor.black.cgColor
        uv.layer.shadowOpacity = 0.2
        uv.layer.shadowRadius = 6
        uv.layer.shadowOffset = .zero
        return uv
    }()
    
    private let leftButton: UIButton = {
        let bb = UIButton()
        bb.setImage(UIImage(named: "talkpick_left")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return bb
    }()
    
    let rightButton: UIButton = {
        let bb = UIButton()
        bb.setImage(UIImage(named: "talkpick_right")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return bb
    }()
    
    private let dateImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "talkpick_calendar")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let dateLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 14, weight: .bold)
        lb.textColor = .black
        return lb
    }()
    
    private lazy var dateStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(dateImageView)
        sv.addArrangedSubview(dateLabel)
        sv.axis = .horizontal
        sv.spacing = 10
        sv.distribution = .fill
        return sv
    }()
    
    lazy var weekStackView = UIStackView()
    
    lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        cv.allowsSelection = true
        cv.allowsMultipleSelection = false
        cv.backgroundColor = .clear
        
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
        configureCalendar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        
        addSubview(calendarBackground)
        calendarBackground.addSubview(leftButton)
        calendarBackground.addSubview(rightButton)
        calendarBackground.addSubview(dateStackView)
        calendarBackground.addSubview(weekStackView)
        calendarBackground.addSubview(calendarCollectionView)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(69)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        calendarBackground.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        leftButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(24)
        }
        leftButton.addTarget(self, action: #selector(goToPreviousMonth), for: .touchUpInside)
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalTo(leftButton)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(24)
        }
        
        dateStackView.snp.makeConstraints {
            $0.centerY.equalTo(leftButton)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(18)
        }
        
        weekStackView.distribution = .fillEqually
        weekStackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(7)
            $0.height.equalTo(30)
        }

        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(7)
            $0.bottom.equalToSuperview().inset(5)
        }
    }
    
    private func configureCalendar() {
        self.configureWeekLabel()
        self.configureDate()
        self.updateButtonStates()
    }
    
    private func configureWeekLabel() {
        let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
        
        for i in 0..<7 {
            let label = UILabel()
            label.text = dayOfTheWeek[i]
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 10, weight: .bold)
            label.textColor = .gray200
            self.weekStackView.addArrangedSubview(label)
        }
    }
    
    private func configureDate() {
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.dateFormatter.locale = Locale(identifier: "en_US")
        self.dateFormatter.dateFormat = "MMMM yyyy"
        self.updateCalendar()
    }
    
    private func updateCalendar() {
        self.updateTitle()
        self.updateDays()
    }
    
    func startDayOfTheWeek() -> Int {
        return self.calendar.component(.weekday, from: self.calendarDate) - 1
    }
    
    func endDate() -> Int {
        return self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? Int()
    }
    
    private func updateTitle(){
        let date = self.dateFormatter.string(from: self.calendarDate)
        self.dateLabel.text = date
    }
    
    private func updateDays() {
        let startDayOfTheWeek = self.startDayOfTheWeek()
        let numberOfDaysInMonth = self.endDate()
        
        // 이전 달 날짜 계산
        let prevMonthDate = calendar.date(byAdding: .month, value: -1, to: calendarDate)!
        let daysInPrevMonth = calendar.range(of: .day, in: .month, for: prevMonthDate)?.count ?? 30
        
        let leadingStart = daysInPrevMonth - startDayOfTheWeek + 1
        let leadingDays: [Int] = (leadingStart <= daysInPrevMonth && leadingStart >= 1)
        ? Array(leadingStart...daysInPrevMonth)
        : []
        
        let currentMonthDays = Array(1...numberOfDaysInMonth)
        
        // 전체 셀 수를 맞춰서 다음 달 날짜 생성
        let totalGridCount = ((startDayOfTheWeek + numberOfDaysInMonth) % 7 == 0)
        ? startDayOfTheWeek + numberOfDaysInMonth
        : ((startDayOfTheWeek + numberOfDaysInMonth) / 7 + 1) * 7
        let trailingDaysCount = totalGridCount - (startDayOfTheWeek + numberOfDaysInMonth)
        let trailingDays: [Int] = (trailingDaysCount > 0)
        ? Array(1...trailingDaysCount)
        : []
        
        // 오늘 날짜 구성
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let calendarComponents = calendar.dateComponents([.year, .month], from: calendarDate)
        
        var fullDays: [CalendarDay] = []
        
        leadingDays.forEach {
            fullDays.append(CalendarDay(day: "\($0)", isToday: false, isCurrentMonth: false))
        }
        
        currentMonthDays.forEach {
            let isToday = (
                todayComponents.year == calendarComponents.year &&
                todayComponents.month == calendarComponents.month &&
                todayComponents.day == $0
            )
            fullDays.append(CalendarDay(day: "\($0)", isToday: isToday, isCurrentMonth: true))
        }
        
        trailingDays.forEach {
            fullDays.append(CalendarDay(day: "\($0)", isToday: false, isCurrentMonth: false))
        }
        
        self.days.accept(fullDays.map { $0.day })
        self.calendarCollectionView.reloadData()
    }
    
    private func updateButtonStates() {
        let isPrevDisabled = calendar.component(.year, from: calendarDate) == calendar.component(.year, from: now)
            && calendar.component(.month, from: calendarDate) <= calendar.component(.month, from: now)
        leftButton.isEnabled = !isPrevDisabled

        let isNextDisabled = calendar.component(.year, from: calendarDate) >= calendar.component(.year, from: now)
            && calendar.component(.month, from: calendarDate) >= 12
        rightButton.isEnabled = !isNextDisabled
    }
    
    @objc private func goToPreviousMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: -1, to: calendarDate) else { return }

        if calendar.isDate(newDate, equalTo: now, toGranularity: .year),
           calendar.component(.month, from: newDate) < calendar.component(.month, from: now) {
            return
        }

        calendarDate = newDate
        calendarMonth = newDate
        updateCalendar()
        updateButtonStates()
    }
    
    @objc private func goToNextMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: 1, to: calendarDate) else { return }

        if calendar.component(.year, from: newDate) > calendar.component(.year, from: now) {
            return
        }

        calendarDate = newDate
        calendarMonth = newDate
        updateCalendar()
        updateButtonStates()
    }
}

struct CalendarDay {
    let day: String
    let isToday: Bool
    let isCurrentMonth: Bool
}
