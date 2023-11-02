//
//  Recode_API.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/31.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


struct Recode_API {
    static let shared: Recode_API = Recode_API()
    init() {}
    
    // MARK: - 한 달 기록 가져오기
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 오늘 기록 가져오기
    func fetchRecode(date: Date = Date(),
                     completion: @escaping ([Recode]) -> Void) {
        // uid가져오기
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // 날짜 가져오기
//        let date = Date.dateReturnString(todayFormat: .api_yyyy_M)
        
        
        
        
        
        var calendar = Calendar.current
        
        calendar.locale = Locale(identifier: "ko")
        // 기준 시간을 한국으로 변경
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let start = calendar.date(from: components)!
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        
           
        
        
        
        print(uid)
        print(components)
        print(start)
        print(end)
        // 기록 가져오기
//        API_String
//            .recodeDB
//            .whereField(API_String.user, isEqualTo: uid)
//            .whereField(API_String.created_at, isGreaterThan: start)
//            .whereField(API_String.created_at, isLessThan: end)
////            .order(by: API_String.created_at)
//            .getDocuments { snapshot, error in
////                dump(snapshot)
//
//                print(snapshot?.count)
//            }
        
        
//            .getDocument { snapshot, error in
//                // 에러가 있다면
//                if let error = error {
//                    print("\(#function) --- \(error)")
//                    print("실패")
//                    return
//                }
//                // 에러가 없다면
//                // 데이터 옵셔널 바인딩
//                guard let data = snapshot?.data() else { return }
//
//                // 배열 만들고,
//                var recodeArray: [Recode] = []
//
//                // 딕셔너리의 value를 array로 바꾸기
//                data.forEach { (key: String, value: Any) in
//                    // value는 배열
//                    guard let array = value as? Array<Any> else { return }
//
//                    // array를 다시 딕셔너리로 바꾸기
//                    array.forEach { arr in
//                        guard let arr = arr as? Dictionary<String, Any> else { return }
//
//                        // Recode 모델 만들기
//                        let recode = Recode(dictionary: arr)
//                        // 배열에 추가
//                        recodeArray.append(recode)
//                    }
//                }
//                // 기록 정렬
//                recodeArray.sort { recode1, recode2 in
//                    recode1.recodeTime > recode2.recodeTime
//                }
//                // 컴플리션
//                completion(recodeArray)
//            }
//
        
        
    }
            
    
    
    
    // MARK: - 오늘 기록 쓰기
    func createRecode(first: Bool = false,
                      context: String,
//                      image: [UIImage],
                      completion: @escaping (Recode) -> Void) {
        // uid가져오기
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // 날짜 가져오기
        let date = Date.dateReturnString(todayFormat: .api_yyyy_M)
        
        // 딕셔너리 만들기
        let values: [String: Any] = [
            API_String.context: context,
            API_String.created_at: Date()]
        
        // 기록 쓰기
        API_String
            .recodeDB
            .document(uid)
            .updateData([date: FieldValue.arrayUnion([values])]) { error in
                // 에러가 있다면
                if let error = error {
                    print("\(#function) --- \(error)")
                    print("실패")
                    return
                }
                // 성공
                print("성공")
                completion(Recode(dictionary: values))
            }
    }
}
