//
//  Diary.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/31.
//

import Foundation

struct Diary {
    let context: String
    let date: Date
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.context = dictionary[API_String.context] as? String ?? ""
        self.date = dictionary[API_String.created_at] as? Date ?? Date()
        
        self.imageUrl = dictionary[API_String.image_url] as? String ?? ""
    }
    
    
    
    /// 시간
    var diaryTime: String {
        let timeFormat: TodayFormatEnum = timeFormat_Static == 0
        ? .a_hmm // PM 2:00
        : .Hmm // 14: 00
        return Date.dateReturn_Custom(todayFormat: timeFormat,
                                      UTC_Plus9: true,
                                      date: self.date)
    }
    
    // 날짜
    /// ex) 10일
    var diary_d: String {
        return Date.dateReturn_Custom(todayFormat: .d,
                                      UTC_Plus9: true,
                                      date: self.date)
    }
    /// ex) 9월 10일
    var diary_M_d: String {
        return Date.dateReturn_Custom(todayFormat: .M월d일,
                                      UTC_Plus9: true,
                                      date: self.date)
    }
}
