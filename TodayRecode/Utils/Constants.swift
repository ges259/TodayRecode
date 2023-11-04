//
//  Constants.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import FirebaseFirestore


// MARK: - Format
let timeFormat_Static: Int = 0
let dateFormat_Static: Int = 0
var calendarIsHidden_Static: Bool = true 




// MARK: - API
enum API_String {
    // 데이터베이스
    static let userDB = Firestore.firestore().collection("users")
    static let diaryDB = Firestore.firestore().collection("diaries")
    static let recodeDB = Firestore.firestore().collection("records")
    
    // 개인 설정
    static let userName: String = "userName"
    static let email: String = "email"
    static let timeFormat: String = "timeFormat"
    static let dateFomat: String = "dateFormat"
    
    // 다이어리 / 기록 화면
    static let created_at: String = "created_at"
    static let image_url: String = "image_url"
    static let context: String = "context"
    
    // 쿼리를 통해 user를 판별할 때 사용
    static let user: String = "user"
}



// MARK: - Identifier
enum Identifier {
    static let recodeTableCell: String = "RecodeTableViewCell"
    static let imageListCollectionViewCell: String = "DiaryListCollectionViewCell"
    static let settingTableCell: String = "SettingTableCell"
}
