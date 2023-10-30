//
//  Date+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/28.
//

import Foundation

extension Date {
    /// 원하는 날짜를 문자열로 리턴하는 메서드
    /// - Parameters:
    ///   - todayFormat: TodayFormatEnum
    ///   - date: 날짜가 없을 경우 오늘 날짜 리턴
    /// - Returns: String 타입
    static func todayReturnString(todayFormat: TodayFormatEnum,
                     date: Date = Date()) -> String {
        let formatter = DateFormatter()
            formatter.dateFormat = todayFormat.today
        return formatter.string(from: date)
    }
    
    
    /// Date배열 타입을 리턴하는 함수
    /// - Parameter date: [Date] --- Date배열 타입
    /// - Returns: [Date] --- Date배열 타입
    static func todayReturnDateType(dates: [Date]) -> [Date] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"

        var dateArray = [Date]()
        
        dates.forEach { date in
            dateArray.append(formatter.date(from: self.todayReturnString(
                todayFormat: .yyyy_MM_dd,
                date: date))!)
        }
        return dateArray
    }
    
    
    /// 원하는 날짜가 몇 년도 몇 월인지를 리턴하는 메서드
    /// - Parameter date: 원하는 날짜
    /// - Returns: [String] --- 문자열 배열로 리턴]
    static func yearAndMonthReturn(date: Date = Date()) -> [String] {
        
        let formatter = DateFormatter()
        // 몇 년도인지
            formatter.dateFormat = TodayFormatEnum.yyyy.today
        let year = formatter.string(from: date)
        // 몇 월인지
            formatter.dateFormat = TodayFormatEnum.M.today
        let month = formatter.string(from: date)
        // 문자열 배열 리턴
        return [year, month]
    }
}
