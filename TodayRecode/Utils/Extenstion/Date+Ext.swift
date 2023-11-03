//
//  Date+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/28.
//

import Foundation

// MARK: - 날짜

extension Date {
    
    // MARK: - A
    /// 원하는 날짜를 문자열로 리턴하는 메서드
    /// - Parameters:
    ///   - todayFormat: TodayFormatEnum
    ///   - date: 날짜가 없을 경우 오늘 날짜 리턴
    /// - Returns: String 타입
    static func dateReturn_Custom(todayFormat: TodayFormatEnum,
                                  UTC_Plus9: Bool = true,
                                  date: Date = Date()) -> String {
        
        var current = date
        // 9시간 더하기 UTC+9
        if UTC_Plus9 {
            guard let date = Date.UTC_Plus9(date: date) else { return "" }
            current = date
        }
        
        let formatter = DateFormatter()
            formatter.dateFormat = todayFormat.today
            formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: current)
    }
    
    
    
    
    
    
    
    
    
    
    /*
     9시간을 추가해야한다면 -> 아래 메서드 (startOfHout)
     9시간을 추가해야할 필요가 없다면 -> 이 메서드
     */
    
    // MARK: - Fix
    /// Date배열 타입을 리턴하는 함수
    /// - Parameter date: [Date] --- Date배열 타입
    /// - Returns: [Date] --- Date배열 타입
    static func todayReturnDateType(dates: [Date]) -> [Date] {
        let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy-MM-dd"
        var dateArray = [Date]()
        
        dates.forEach { date in
            // 9시간 더하기 UTC+9
            guard let current = Date.UTC_Plus9(date: date) else { return }
            dateArray.append(formatter.date(from: self.dateReturn_Custom(
                todayFormat: .yyyy_MM_dd,
                date: current))!)
        }
        return dateArray
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - C
    /// 원하는 날짜가 몇 년도 몇 월인지를 리턴하는 메서드
    /// - Parameter date: 원하는 날짜
    /// - Returns: [String] --- 문자열 배열로 리턴]
    static func dateArray_yyyy_M_d(
        date: Date? = Date.UTC_Plus9(),
        firstFormat: TodayFormatEnum = .yyyy,
        secondFormat: TodayFormatEnum = .M,
        thirdFormat: TodayFormatEnum = .d) -> [String] {
            // 옵셔널 바인딩
            guard let date = date else { return [""] }
            
            let formatter = DateFormatter()
            // 몇 년도인지
            formatter.dateFormat = firstFormat.today
            let year = formatter.string(from: date)
            // 몇 월인지
            formatter.dateFormat = secondFormat.today
            let month = formatter.string(from: date)
            // 며칠인지
            formatter.dateFormat = thirdFormat.today
            let day = formatter.string(from: date)
            // 문자열 배열 리턴
            return [year, month, day]
        }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 9시간 더하기 (UTC+9)
    /// 9시간 더하기
    /// isAPI라면 -> 시간 / 분 / 초 0으로 만들기
    static func UTC_Plus9(date: Date = Date()) -> Date? {
        // 현재 시간
        let calendar = Calendar.current
        // 표현할? 정보들 선택하기
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        // isAPI가 true라면
            // 분, 초를 0으로 만듦
//        if isAPI == true {
////            print("true")
//            components.hour = 0
//            components.minute = 0
//            components.second = 0
//
//        // false라면
//        } else {
        // 현재 시간 + 9 (UTC의 영향)
            components.hour! += 9
//        }
        // Date로 변환하여 반환
        return calendar.date(from: components)
    }
    
    
    
    
    func reset_h_m_s(day_set0: Bool = false,
                     month_plus1: Bool = false) -> Date? {
        // 현재 시간
        let calendar = Calendar.current
        // 표현할? 정보들 선택하기
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        // isAPI가 true라면
            // 시간, 분, 초를 0으로 만듦
        // 현재 시간 + 9 (UTC의 영향)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        // 현재 달 1일로 맞춤
        if day_set0 {
            components.day = 1
            // 다음달 1일로 맞춤
        } else if month_plus1 {
            components.day = 1
            components.month! += 1
        }
        // Date로 변환하여 반환
        return calendar.date(from: components)
    }
}
