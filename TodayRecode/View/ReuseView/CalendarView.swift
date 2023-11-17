//
//  CalendarView.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/22.
//

import UIKit
import FSCalendar
import SnapKit

final class CalendarView: UIView {
    
    // MARK: - 레이아웃
    /// 달력
    lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        // 배경 색상 설정
        calendar.backgroundColor = .white_Base
        
        // ----- 주(월/화/수/~~) -----
        // 한글로 표시
        calendar.locale = Locale(identifier: "ko_KR")
        // 폰트 크기 설정
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 12)
        // 색상
        calendar.appearance.weekdayTextColor = .black.withAlphaComponent(0.7)
        // 헤더(10월) 없애기
        calendar.headerHeight = 0
        // 주(월,화,수)와 상단의 간격 넓히기
        calendar.weekdayHeight = 40
        
        // ----- 이벤트 -----
        // 이벤트 - 점 위치
        calendar.appearance.eventOffset.y -= 5
        // 이벤트 - 선택되지 않은 날짜 색깔
        calendar.appearance.eventDefaultColor = UIColor.blue_Point
        // 이벤트 - 선택된 날짜 색깔
        calendar.appearance.eventSelectionColor = UIColor.clear
        
        // 찾았다?
        calendar.appearance.borderRadius = .zero
        
        // 선택된 날짜의 색상
        calendar.appearance.selectionColor = UIColor.blue_Point
        // 오늘 날짜 생상
        calendar.appearance.todayColor = UIColor.blue_Lightly
        // 오늘 날짜 타이틀 생상
        calendar.appearance.titleTodayColor = .black
        
        // cornerRadius
        calendar.clipsToBounds = true
        calendar.layer.cornerRadius = 10
        
        return calendar
    }()
    
    /// 달력의 높이 제약
    private var calendarHeight: NSLayoutConstraint?
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    weak var delegate: CalendarDelegate?
    
    var diaryArray: [Date] = [] {
        didSet { self.calendar.reloadData() }
    }
    
    
    /// selectedData는 시간/분/초가 모두 0이기 때문에 현재 시간 + 선택된 날짜 년/월/일
    var returnSelectedDate: Date? {
        // 현재 시간 구하기
        let current = Date().reset_time()
        // 달력에 선택된 시간 가져오기
        let selectedDate = self.calendar.selectedDate?.reset_time()
        // 오늘 날짜 == 선택된 날짜
        return current == selectedDate
        ? Date()        // 만약 서로 같다면 -> 오늘날짜 리턴
        : selectedDate  // 다른 날이라면 -> 달력에 선택된 날짜 리턴
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureAutoLayout() // 오토레이아웃 설정
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
    
 







// MARK: - 화면 설정

extension CalendarView {
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.addSubview(self.calendar)
        // ********** 오토레이아웃 설정 **********
        self.calendar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}










// MARK: - 액션

extension CalendarView {
    
    // MARK: - 스와이프 - 달력 크기 바꾸기
    func swipeAction(up: Bool) {
        // up
        up == true
        ? self.calendar.setScope(.week, animated: true)
        : self.calendar.setScope(.month, animated: true)
    }
    
    // MARK: - 현재 달력의 상태 리턴
    func currentCalendarScope() -> FSCalendarScope {
        return self.calendar.scope
    }
    
    // MARK: - 달력의 형식 설정
    func configureDateFormat() {
        self.calendar.firstWeekday = Format.dateFormat_Static == 0
        ? 1 // 일요일 시작
        : 2 // 월요일 시작
    }
}










// MARK: - 켈린더 델리게이트
extension CalendarView: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    /// 키보드의 크기가 바뀌면 호출 됨
    func calendar(_ calendar: FSCalendar,
                  boundingRectWillChange bounds: CGRect,
                  animated: Bool) {
        // 캘린더 높이 재설정
        self.delegate?.heightChanged(height: bounds.height)
    }
    
    /// 날짜를 선택했을 때
    func calendar(_ calendar: FSCalendar,
                  didSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition) {
        /*
         1. 달력에서 날짜를 선택
         2. delegate를 통해 DiaryListController로 날짜(date) 전달
         
         --- DateView
         3. DiaryListController에서 dateView의 configureDate()로 전달
            -> dateView의 날짜 레이블 바꾸기
         
         --- ImageCollectionView
         4. self.currentDiary.firstIndex(of: Date)로 몇 번째 인덱스인지 찾기
            -> 찾은 인덱스로 이동 ( moveToItem(index:_) )
         */
        // dateLabel에 선택된 날짜 띄우기
         self.delegate?.selectDate(date: date)
    }
    
    /// 달력의 페이지(월)가 바뀌면 호출 됨
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.delegate?.monthChanged(date: calendar.currentPage)
    }
    
    /// 이벤트가 있는 날짜에 점으로 표시
    func calendar(_ calendar: FSCalendar,
                  numberOfEventsFor date: Date) -> Int {
        return self.diaryArray.contains(date)
        ? 1
        : 0
    }
}
