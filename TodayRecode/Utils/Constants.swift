//
//  Constants.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import FirebaseFirestore

// MARK: - 형식
/// 날짜 및 시간의 형식을 결정하는 전역 변수들을 관리
enum Format {
    // ********** 현재 형식을 알려주는 전역 변수 **********
    /// 시간 형식
    static var timeFormat_Static: Int = 0
    /// 날짜 형식
    static var dateFormat_Static: Int = 0

    // ********** 데이터 형식이 변했다는 것을 알려주는 전역 변수 **********
    /// 기록 화면, 달력의 형식이 바뀌었다는 것을 알려주는 전역 변수
    static var dateFormat_Record_Date: Bool = false
    /// 기록 화면, 시간의 형식이 바뀌었다는 것을 알려주는 전역 변수
    static var dateFormat_Record_Time: Bool = false
    /// 일기 목록 화면, 달력의 형식이 바뀌었다는 것을 알려주는 전역 변수
    static var dateFormat_Diary_Date: Bool = false
}



// MARK: - 유저 데이터
/// 유저의 정보 및 이미지를 관리
enum UserData {
    static var loginMethod: String = ""
    static var userName: String = ""
    /// 유저 데이터
    static var user: User?
    /// 이미지 캐시 전역 변수
    static var imageCache = [String: UIImage]()
    
    static var deleteAccount: Bool = false
}



enum DataUpdate {
    // ********** 로그인 **********
    /// 로그아웃 후 다시 다른 아이디로 로그인했을 때 fetch가 되지 않는 버그 (임시 해결)
    static var login: Bool = true
    // ********** 데이터 업데이트 **********
    /// 이미지 데이터를 생성 or 업데이트를 할 때 -> 시간이 오래걸리기 때문에 로딩뷰를 띄움
    static var imageDataUpdate: Bool = false
    /// 상세 작성 화면에서 기록 화면으로 (pop)할 때만 데이터를 업데이트할 수 있도록 해주는 전역 변수
    static var dataUpdateStart: Bool = false
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
    static let loginMethod: String = "loginMethod"
    
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


enum UserDefault_Apple {
    static let client_secret: String = "AppleClientSecret"
    static let bundleID: String  = "ges.TodayRecord"
    static let authCodeString: String = "theAuthorizationCode"
    
    static let apple_Key_ID: String = "79R8A2F3JK"
    static let apple_Team_ID: String = "63D86GVH6K"
    static let aud: String = "https://appleid.apple.com"
    static let keyPath: String = "AuthKey_79R8A2F3JK"
    static let p8: String = "p8"
}
