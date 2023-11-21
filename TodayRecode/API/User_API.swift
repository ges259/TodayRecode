//
//  User_API.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/31.
//

import UIKit
import FirebaseAuth

struct User_API {
    static let shared: User_API = User_API()
    init() {}
    
    
    
    // MARK: - 유저가 있는지 확인
    var checkUser: Bool {
        // user가 있는지 없는지 체크
        return Auth.auth().currentUser?.uid == nil
        ? false // 없다면
        : true // 있다면
    }
    
    
    
    
    
    
    
    // MARK: - 유저 정보 가져오기
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        API_String
            .userDB.document(uid)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                // 데이터 옵셔널바인딩
                guard let data = snapshot?.data() else { return }
                // User 모델 만들기
                let user = User(dictionary: data)
                // 컴플리션
                completion(.success(user))
            }
    }
    
    
    
    // MARK: - 날짜 및 시간 형식 바꾸기
    func updateDateFormat(_ settingTableEnum: SettingTableEnum,
                          selectedIndex: Int,
                          completion: @escaping (Result<Void, Error>) -> Void) {
        // uid 가져오기
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // 어떤 형식인지 가져오기
        let route: String = settingTableEnum.rawValue == 0
        ? API_String.dateFomat
        : API_String.timeFormat
        
        // DB에 저장
        API_String
            .userDB
            .document(uid)
            .updateData([route: selectedIndex]) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
    }
    
    
    
    // MARK: - 유저 데이터 삭제
    func deleteUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        API_String.userDB.document(uid).delete()
    }
}
