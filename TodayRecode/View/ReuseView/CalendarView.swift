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
            // 처음에는 일주일만 보이도록 설정
//            calendar.scope = .week
            // (월/화/수~~)한글로 표시
            calendar.locale = Locale(identifier: "ko_KR")
                // 폰트 크기 설정
            calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 12)
                // 색상
            calendar.appearance.weekdayTextColor = .black.withAlphaComponent(0.7)
            // 헤더 높이 설정
            calendar.appearance.headerDateFormat = "M월"
            calendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 17)
            calendar.appearance.headerTitleColor = .black
            calendar.appearance.headerMinimumDissolvedAlpha = 0
            // 이벤트 - 선택되지 않은 날짜 색깔
            calendar.appearance.eventDefaultColor = UIColor.green
            // 이벤트 - 선택된 날짜 색깔
            calendar.appearance.eventSelectionColor = .clear
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
}
