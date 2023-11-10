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
    
    
    
    
    
    // typealias
    typealias RecordCompletion = (Result<Record, Error>) -> Void
    typealias RecordArrayCompletion = (Result<[Record], Error>) -> Void
    
    
    
    
    
    // MARK: - 오늘 기록 가져오기
    func fetchRecode(writing_Type: DetailViewMode,
                     date: Date,
                     completion: @escaping RecordArrayCompletion) {
        // 날짜 설정
        var dateRangeFirst: Date? // 오늘 or 1일
        var dateRangeLast: Date? // 내일 or 달의 마지막 날
        
        
        if writing_Type == .diary {
            // 해당 달의 첫 날 날짜 구하기
            dateRangeFirst = date.reset_time(currentMonth_1: true)
            // 해당 달의 마지막 날 날짜 구하기
            dateRangeLast = date.reset_time(nextMonth_1: true)
        } else {
            // 오늘 날짜 구하기 (+ 시간 / 분 / 초 0으로 설정)
            dateRangeFirst = date.reset_time()
            // 다음 날 날짜 구하기 (+ 시간 / 분 / 초 0으로 설정)
            dateRangeLast = Calendar.current.date(byAdding: .day,
                                             value: 1,
                                             to: dateRangeFirst ?? Date())
        }
        
        // uid가져오기
        guard let uid = Auth.auth().currentUser?.uid,
              let today = dateRangeFirst,
              let tomorrow = dateRangeLast else { return }
        
        // 데이터 가져오기
        API_String
            .recodeDB
            .whereField(API_String.writing_Type, isEqualTo: writing_Type.api) // record/diary
            .whereField(API_String.user, isEqualTo: uid) // uid
            .whereField(API_String.created_at, isGreaterThanOrEqualTo: today) // ?일0시
            .whereField(API_String.created_at, isLessThan: tomorrow) // ?일24시
            .order(by: API_String.created_at, descending: true) // 내림차순
            .getDocuments { snapshot, error in
                
                // 에러가 생기면 -> error를 컴플리션
                if let error = error {
                    completion(.failure(error))
                    return
                }
                // 가져온 문서 데이터들 옵셔널 바인딩
                guard let datas = snapshot?.documents else { return }
                
                // 리턴할 Recode 배열 만들기
                var recordArray: [Record] = []
                // 가져온 문서[배열] .forEach을 통해 하나씩 Recode 모델로 만듦
                datas.forEach { snapshot in
                    // 데이터 가져오기
                    let dictionary = snapshot.data()
                    // Recode 모델 만들기
                    let record = Record(documentID: snapshot.documentID,
                                        dictionary: dictionary)
                    // 배열에 추가
                    recordArray.append(record)
                }
                
                // 일기 목록 화면에서는 오름차순으로 설정
                if writing_Type == .diary {
                    recordArray.sort { record1, record2 in
                        return record1.date < record2.date
                    }
                }
                
                // 컴플리션
                completion(.success(recordArray))
            }
    }
    
    
    
    
    
    
    
    
    
    // MARK: - 오늘 기록 쓰기
    func createRecord(writing_Type: DetailViewMode,
                      date: Date?,
                      context: String,
                      image: [String]?,
                      completion: @escaping RecordCompletion) {
        // uid가져오기
        guard let uid = Auth.auth().currentUser?.uid,
              let current = date else { return }
        
        // 문서 ID만들기
        let documentID = NSUUID().uuidString
        
        // DB에 저장할 딕셔너리 만들기
        var value: [String: Any] = [
            API_String.writing_Type: writing_Type.api,
            API_String.context: context,
            API_String.created_at: current,
            API_String.user: uid]
        
        // 이미지 배열 옵셔널 바인딩
        if let image = image {
            // 딕셔너리에 추가
            value[API_String.image_url] = image       // 이미지_url
        }
        print(value)
        // DB에 저장
        API_String
            .recodeDB
            .document(documentID)
            .setData(value, completion: { error in
                // 에러가 있다면
                if let error = error {
                    completion(.failure(error))
                    return
                }
                // Recode 모델에는 created_at이 TimeStamp로 받기 때문에
                    // -> TimeStamp로 타입캐스팅
                value[API_String.created_at] = Timestamp(date: current)
                
                // Record 모델 만들기
                let record = Record(documentID: documentID, dictionary: value)
                
                // 컴플리션
                completion(.success(record))
            })
    }
    
    
    
    
    
    
    
    // MARK: - 기록 업데이트
    func updateRecord(writing_Type: DetailViewMode,
                      record: Record,
                      context: String,
                      image: [String]?,
                      completion: @escaping RecordCompletion) {
        
        // uid가져오기
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // 시간 가져오기
        let current = record.date
        
        // DB에 저장할 딕셔너리 만들기
        var value: [String: Any] = [
            API_String.writing_Type: writing_Type.api,  // writing_Type
            API_String.context: context,                // context
            API_String.created_at: current,             // record의 날짜
            API_String.user: uid]                       // uid
                            
        
        // 이미지 배열 옵셔널 바인딩
        if let image = image {
            // 딕셔너리에 추가
            value[API_String.image_url] = image       // 이미지_url
        }
        
        // DB에 저장
        API_String
            .recodeDB
            .document(record.documentID)
            .updateData(value, completion: { error in
                
                // 에러가 있다면
                if let error = error {
                    completion(.failure(error))
                    return
                }
                // Recode 모델에는 created_at이 TimeStamp로 받기 때문에
                    // -> TimeStamp로 타입캐스팅
                value[API_String.created_at] = Timestamp(date: current)
                // Record 모델 만들기
                let record = Record(documentID: record.documentID, dictionary: value)
                // 컴플리션
                completion(.success(record))
            })
    }
    
    
    
    
    // MARK: - 기록 삭제
    func deleteRecord(documentID: String?,
                      completion: @escaping (Result<Void, Error>) -> Void) {
        // 문서ID 옵셔널 바인딩
        guard let documentID = documentID else { return }
        // DB에서 삭제
        API_String.recodeDB.document(documentID).delete { error in
            // 에러가 있다면
            if let error = error {
                completion(.failure(error))
                return
            }
            // 삭제에 성공한다면
            completion(.success(()))
        }
    }
}
