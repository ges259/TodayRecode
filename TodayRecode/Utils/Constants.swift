//
//  Constants.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import FirebaseFirestore

struct APIConstants {
    init() {}
    
    static let userDB = Firestore.firestore().collection("users")
    static let diaryDB = Firestore.firestore().collection("diaries")
    static let recodeDB = Firestore.firestore().collection("recodes")
    
    
    // 설정 화면
    static let name: String = "name"
    static let email: String = "email"
    static let timeFormat: String = "timeFormat"
    //    static let sound: String = "sound"
    
    
    // 다이어리 / 기록 화면
    static let created_at: String = "created_at"
    static let image_url: String = "image_url"
    static let context: String = "context"
}


enum Identifier {
    static let recodeTableCell: String = "RecodeTableViewCell"
}



