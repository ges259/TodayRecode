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
                                  UTC_Plus9: Bool,
                                  date: Date = Date()) -> String {
        let formatter = DateFormatter()
            formatter.dateFormat = todayFormat.today
            formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - C
    /// 원하는 날짜가 몇 년도 몇 월인지를 리턴하는 메서드
    /// - Parameter date: 원하는 날짜
    /// - Returns: [String] --- 문자열 배열로 리턴]
    static func dateArray_yyyy_M_d(
        date: Date? = Date(), // .UTC_Plus9()
        firstFormat: TodayFormatEnum = .yyyy년,
        secondFormat: TodayFormatEnum = .M월,
        thirdFormat: TodayFormatEnum = .d일) -> [String] {
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
//    static func UTC_Plus9(date: Date = Date()) -> Date? {
//        // 현재 시간
//        let calendar = Calendar.current
//        // 표현할? 정보들 선택하기
//        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//        // 9시간 더하기
//            components.hour! += 9
//        // Date로 변환하여 반환
//        return calendar.date(from: components)
//    }
    
    
    
    ///
    func reset_time(currentMonth_1: Bool = false,
                    nextMonth_1: Bool = false) -> Date? {
        // 현재 시간
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        // 표현할? 정보들 선택하기
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        // 시간, 분, 초를 0으로 만듦
        components.hour = 0
        components.minute = 0
        components.second = 0
        // 현재 달 1일로 맞춤
        if currentMonth_1 {
            components.day = 1
        // 다음달 1일로 맞춤
        } else if nextMonth_1 {
            components.day = 1
            components.month! += 1
        }
        return calendar.date(from: components)
    }
}
