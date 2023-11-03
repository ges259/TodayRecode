//
//  Recode_API.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/31.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


struct Record_API {
    static let shared: Record_API = Record_API()
    init() {}
    
    // MARK: - 한 달 기록 가져오기
    
    
    
    
    
    
    
    
    
    
    
    

    
    // MARK: - 오늘 기록 가져오기
    func fetchRecode(date: Date,
                     completion: @escaping ([Record]) -> Void) {
        // uid가져오기
        // 오늘 날짜 구하기 (+ 시간 / 분 / 초 0으로 만들기)
        // 내일 날짜 구하기
        guard let uid = Auth.auth().currentUser?.uid,
              let today = date.reset_h_m_s(),
              let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
        else { return }
        
        // 데이터 가져오기
        API_String
            .recodeDB
            .whereField(API_String.user, isEqualTo: uid) // uid
            .whereField(API_String.created_at, isGreaterThanOrEqualTo: today) // ?일0시
            .whereField(API_String.created_at, isLessThan: tomorrow) // ?일24시
            .order(by: API_String.created_at, descending: true) // 내림차순
            .getDocuments { snapshot, error in
                // 일치하는 문서 바인딩
                guard let datas = snapshot?.documents else { return }
                // 리턴할 Recode 배열 만들기
                var recordArray: [Record] = []
                // 가져온 문서[배열] .forEach을 통해 하나씩 Recode 모델로 만듦
                datas.forEach { snapshot in
                    // 데이터 가져오기
                    let dictionary = snapshot.data()
                    // Recode 모델 만들기
                    let record = Record(dictionary: dictionary)
                    // 배열에 추가
                    recordArray.append(record)
                }
                // 컴플리션
                completion(recordArray)
            }
    }
    
    
    
    
    
    
    
    
    
    // MARK: - 오늘 기록 쓰기
    func createRecode(date: Date?,
                      context: String,
                      image: [UIImage]? = nil,
                      completion: @escaping (Record) -> Void) {
        // uid가져오기
        guard let uid = Auth.auth().currentUser?.uid,
              let current = Date.UTC_Plus9(date: date ?? Date()) else { return }
        
        
        
        // DB에 저장할 딕셔너리 만들기
        var value: [String: Any] = [
            API_String.context: context,
            API_String.created_at: current,
            API_String.user: uid]
        
        // DB에 저장
        API_String
            .recodeDB
            .addDocument(data: value) { error in
                // 에러가 있다면
                if let error = error {
                    print("\(#function) --- \(error)")
                    print("실패")
                    return
                }
                // 성공
                print("성공")
                // Recode 모델에는 created_at이 TimeStamp로 받기 때문에
                    // -> TimeStamp로 타입캐스팅
                value[API_String.created_at] = Timestamp(date: current)
                
                // 컴플리션
                completion(Record(dictionary: value))
            }
    }
}
