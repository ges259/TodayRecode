//
//  Recode.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/31.
//
import Foundation
import FirebaseDatabase
import FirebaseFirestore


struct Record {
    let context: String
    var date: Date
    let imageUrl: String
    
    let documentID: String
    
    
    init(documentID: String, dictionary: [String: Any]) {
        self.documentID = documentID
        
        self.context = dictionary[API_String.context] as? String ?? ""
        self.imageUrl = dictionary[API_String.image_url] as? String ?? ""
        
        // 타임스탬프로 받음
        let timeStamp = dictionary[API_String.created_at] as? Timestamp
        // 타임스탬프를 timeInterval로 바꾸기
        let timeInterval = TimeInterval(integerLiteral: timeStamp?.seconds ?? 0)
        // date로 저장
        self.date = Date(timeIntervalSince1970: timeInterval)
    }
    
    
    
    /// 시간
    var recodeTime: String {
        let timeFormat: TodayFormatEnum = timeFormat_Static == 0
        ? .a_hmm // PM 2:00
        : .HHmm // 14: 00
        return Date.dateReturn_Custom(
            todayFormat: timeFormat,
            UTC_Plus9: false,
            date: self.date)
    }
    /// ex) 10일
    var recodeDay: String {
        return Date.dateReturn_Custom(todayFormat: .d,
                                      UTC_Plus9: true,
                                      date: self.date)
    }
    /// ex) 9월 10일
    var recodeMonthAndDay: String {
        return Date.dateReturn_Custom(todayFormat: .M월d일,
                                      UTC_Plus9: true,
                                      date: self.date)
    }
    
    
    
    
}
