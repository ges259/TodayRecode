//
//  Recode.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/31.
//
import Foundation
import FirebaseDatabase
import FirebaseFirestore


struct Recode {
    let context: String
    var date: Date
    let imageUrl: String
    
//    let recodeID: String
    
    
    init(dictionary: [String: Any]) {
        self.context = dictionary[API_String.context] as? String ?? ""
        self.imageUrl = dictionary[API_String.image_url] as? String ?? ""
        
        // dictionary[API_String.created_at]
        // Optional(<FIRTimestamp: seconds=1698822248 nanoseconds=223397000>)
        let timeStamp = dictionary[API_String.created_at] as? Timestamp
        let timeInterval = TimeInterval(integerLiteral: timeStamp?.seconds ?? 0)
        
        self.date = Date(timeIntervalSince1970: timeInterval)
    }
    
    
    
    /// 시간
    var recodeTime: String {
        let timeFormat: TodayFormatEnum = timeFormat_Static == 0
        ? .a_hmm // PM 2:00
        : .Hmm // 14: 00
        return Date.dateReturnString(todayFormat: timeFormat, date: self.date)
    }
    /// ex) 10일
    var recodeDay: String {
        return Date.dateReturnString(todayFormat: .d, date: self.date)
    }
    /// ex) 9월 10일
    var recodeMonthAndDay: String {
        return Date.dateReturnString(todayFormat: .M_d, date: self.date)
    }
}
