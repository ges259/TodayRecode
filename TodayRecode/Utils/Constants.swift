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
    static let imageCollectionViewCell: String = "ImageCollectionViewCell"
    static let diaryListCollectionViewCell: String = "DiaryListCollectionViewCell"
    static let diaryListHeader: String = "DiaryListHeader"
}







// MARK: - Fix
var array: [String] = ["3safdlhdasl;h;lsdkjs;dflajfsd;akj;lsdafsdafasdfsadsdffasfdsafdasdfsda2333safdlhdasl;h;lsdkjs;dflajfsd;akj;lsdafsdafasdfsadsdffasfdsafdasdfsda2333safdlhdasl;h;lsdkjs;dflajfsd;akj;lsdafsdafasdfsadsdffasfdsafdasdfsda",
"12345",
"10월24일",
"3safdlhdasl;h;lsdkjs;dflajfsd;akj;lsdafsdaf",
"하루 기록",
"하루 일기",
"설정",
"11월;ㅁㄴ럼너ㅣ;ㅏ런ㅁ아ㅣ;럼ㄴ이;ㅏ러이나;ㅓㄹ;ㅣㅏㅓㄴ미;라ㅓㅁ니;럼나ㅣ;ㅓㄹㄴ;미ㅓㄹ;ㄴ미어리;ㅏㅁ널;ㅣㅁ너;ㅣㄹㅁ너;ㅏ런ㅁ;ㅣ럼ㄴ;ㅣ",
"플러스 버튼",
"달력",
"날짜 뷰",
"테이블뷰",
                       "스크롤뷰ㅓㄹㅁㅇ니;ㅏㅇㄹㄴ머;ㅏㅣㄹㄴㅇ머ㅣㅏ;ㄹㄴㅁ어ㅣ;ㄴㅇㄹ머ㅣㅏㄹㄴ어머ㅏㄹㅁㄴ아ㅣㅓ;ㄹㄴㅇ머ㅏㅣ;ㄹㅇㄴ머ㅏ;ㄹㄴ어ㅏㅣㅓㅏㅣㄴㅇ러ㅏㅣ;ㄹㄴㅇ머ㅏㅣ;ㄴㅇㄹ머ㅏㅣ;ㄹㄴㅇ머ㅏㄹㄴ어ㅏㅣㅓㅏㅣ;ㅁ너ㅏㅣ;ㄹㄴㅇ머ㅏㅣ;ㅁㄴㅇ러ㅏㅣ;ㄹㄴㅇ머ㅏㄴㅇ러ㅏㅣㅓㅏㅣ;ㄹㄴㅇ머ㅏㅣ;ㄹㅇ너ㅏㅣ;ㄴㅇㄹ머ㅏㅣ;ㄹㅇㄴ머ㅏㄹㄴ어ㅏㅣ",
                       "3safdlhdasl;h;lsdkjs;dflajfsd;akj;lsdafsdafasdfsadsdffasfdsafdasdfsda2333safdlhdasl;h;lsdkjs;dflajfsd;akj;lsdafsdafasdfsadsdffasfdsafdasdfsda2333safdlhdasl;h;lsdkjs;dflajfsd;akj;lsdafsdafasdfsadsdffasfdsafdasdfsda",
                       "12345",
                       "10월24일",
                       "3safdlhdasl;h;lsdkjs;dflajfsd;akj;lsdafsdaf",
                       "하루 기록",
                       "하루 일기",
                       "설정",
                       "11월;ㅁㄴ럼너ㅣ;ㅏ런ㅁ아ㅣ;럼ㄴ이;ㅏ러이나;ㅓㄹ;ㅣㅏㅓㄴ미;라ㅓㅁ니;럼나ㅣ;ㅓㄹㄴ;미ㅓㄹ;ㄴ미어리;ㅏㅁ널;ㅣㅁ너;ㅣㄹㅁ너;ㅏ런ㅁ;ㅣ럼ㄴ;ㅣ",
                       "플러스 버튼",
                       "달력",
                       "날짜 뷰",
                       "테이블뷰",
                       "스크롤뷰ㅓㄹㅁㅇ니;ㅏㅇㄹㄴ머;ㅏㅣㄹㄴㅇ머ㅣㅏ;ㄹㄴㅁ어ㅣ;ㄴㅇㄹ머ㅣㅏㄹㄴ어머ㅏㄹㅁㄴ아ㅣㅓ;ㄹㄴㅇ머ㅏㅣ;ㄹㅇㄴ머ㅏ;ㄹㄴ어ㅏㅣㅓㅏㅣㄴㅇ러ㅏㅣ;ㄹㄴㅇ머ㅏㅣ;ㄴㅇㄹ머ㅏㅣ;ㄹㄴㅇ머ㅏㄹㄴ어ㅏㅣㅓㅏㅣ;ㅁ너ㅏㅣ;ㄹㄴㅇ머ㅏㅣ;ㅁㄴㅇ러ㅏㅣ;ㄹㄴㅇ머ㅏㄴㅇ러ㅏㅣㅓㅏㅣ;ㄹㄴㅇ머ㅏㅣ;ㄹㅇ너ㅏㅣ;ㄴㅇㄹ머ㅏㅣ;ㄹㅇㄴ머ㅏㄹㄴ어ㅏㅣ",
                       "3safdlhdasl;h;lsdkjs;dflajfsd;akj;lsdafsdafasdfsadsdffasfdsafdasdfsda2333safdlhdasl;h;lsdkjs;dflajfsd;akj;lsdafsdafasdfsadsdffasfdsafdasdfsda2333safdlhdasl;h;lsdkjs;dflajfsd;akj;lsdafsdafasdfsadsdffasfdsafdasdfsda"]
