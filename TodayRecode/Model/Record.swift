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
    let imageUrl: [String]
    
    let documentID: String
    
    
    init(documentID: String, dictionary: [String: Any]) {
        self.documentID = documentID
        
        self.context = dictionary[API_String.context] as? String ?? ""
        self.imageUrl = dictionary[API_String.image_url] as? [String] ?? [""]
        
        
        // 타임스탬프로 받음
        let timeStamp = dictionary[API_String.created_at] as? Timestamp
        // 타임스탬프를 timeInterval로 바꾸기
        let timeInterval = TimeInterval(integerLiteral: timeStamp?.seconds ?? 0)
        // date로 저장
        self.date = Date(timeIntervalSince1970: timeInterval)
    }
}
