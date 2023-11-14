//
//  Constants.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import FirebaseFirestore




// MARK: - Format
enum Format {
    // ********** 현재 형식을 알려주는 전역 변수 **********
    static var timeFormat_Static: Int = 0
    static var dateFormat_Static: Int = 0

    // ********** 데이터 형식이 변했다는 것을 알려주는 전역 변수 **********
    /// 기록 화면, 달력의 형식이 바뀌었다는 것을 알려주는 전역 변수
    static var dateFormat_Record_Date: Bool = false
    /// 기록 화면, 시간의 형식이 바뀌었다는 것을 알려주는 전역 변수
    static var dateFormat_Record_Time: Bool = false
    /// 일기 목록 화면, 달력의 형식이 바뀌었다는 것을 알려주는 전역 변수
    static var dateFormat_Diary_Date: Bool = false
}

enum UserData {
    static var user: User?
    
    // ********** 이미지 캐시 전역 변수 **********
    static var imageCache = [String: UIImage]()
}






// MARK: - API
/// API관련 문자열
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
    static let writing_Type: String = "writing_type"
}



// MARK: - Identifier
/// 테이블뷰/콜렉션뷰 사용시 필요한 문자열
enum Identifier {
    static let recodeTableCell: String = "RecodeTableViewCell"
    static let imageListCollectionViewCell: String = "DiaryListCollectionViewCell"
    static let settingTableCell: String = "SettingTableCell"
}
