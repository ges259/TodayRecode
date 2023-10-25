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
            calendar.backgroundColor = .customWhite5
            // (월/화/수~~)한글로 표시
            calendar.locale = Locale(identifier: "ko_KR")
                // 폰트 크기 설정
            calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 12)
                // 색상
            calendar.appearance.weekdayTextColor = .black.withAlphaComponent(0.7)
            // 이벤트 - 선택되지 않은 날짜 색깔
            calendar.appearance.eventDefaultColor = UIColor.green
            // 이벤트 - 선택된 날짜 색깔
            calendar.appearance.eventSelectionColor = .clear
            // 헤더(10월) 없애기
            calendar.headerHeight = 0
            // 주(월,화,수)와 상단의 간격 넓히기
            calendar.weekdayHeight = 40
            // 달력의 평일 날짜 색깔s
            calendar.appearance.titleDefaultColor = .black
            // 달력의 토,일 날짜 색깔
            calendar.appearance.titleWeekendColor = .red
        // 월요일 시작
//        calendar.firstWeekday = 2
        // 일요일 시작
        calendar.firstWeekday = 1
        
        
        return calendar
    }()
    
    /// 달력의 높이 제약
    private var calendarHeight: NSLayoutConstraint?
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    var delegate: CalendarDelegate?
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.configureAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        
    }
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.addSubview(self.calendar)
        // ********** 오토레이아웃 설정 **********
        self.calendar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    
    
    
    
    
    
    
    // MARK: - 액션
    func swipeAction(up: Bool) {
        // up
        up == true
        ? self.calendar.setScope(.week, animated: true)
        : self.calendar.setScope(.month, animated: true)
    }
    
    
    
    
    func currentCalendarScope() -> FSCalendarScope {
        return self.calendar.scope
    }
}
















// MARK: - 켈린더 델리게이트
extension CalendarView: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        // 캘린더 높이 재설정
        self.delegate?.heightChanged(height: bounds.height)
    }
    /// 날짜를 선택했을 때
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // dateLabel에 선택된 날짜 띄우기
        self.delegate?.selectDate(date: date)
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentMonth = self.todayReturn(
            todayFormat: .month_M,
            date: calendar.currentPage)
        self.delegate?.monthChanged(month: currentMonth)
    }
}
