//
//  APIService.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import Foundation
import FirebaseFirestore



struct Diary_API {
    static let shared: Diary_API = Diary_API()
    init() {}
    
    func createData() {
        
        API_String.diaryDB
            .document("vPr2zA8kLuoaKupLzkoB")
            .setData([
                API_String.image_url: "iamgeURL_22",
                API_String.context: "context_22"
            ])
    }
    
    
    
    
    func readData() {
        API_String.diaryDB
            .document("vPr2zA8kLuoaKupLzkoB")
            .collection("231014")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("error ----- \(error)")
                    return
                } else {
                    print("success")
                }
            }
    }
    
    
    // MARK: - 한 달 치 일기 가져오기
    // 파라미터: 날짜(년, 월)
    // 날짜 순으로 설정
    
    
    
    
    
    // MARK: - 오늘 일기 저장
    
    
    

    
    
    
    
    
}
