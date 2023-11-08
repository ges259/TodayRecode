//
//  Auth_API.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/31.
//

import UIKit
import FirebaseAuth

struct Auth_API {
    static let shared: Auth_API = Auth_API()
    init() {}
    
    typealias AuthCompletion = (Result<Void, Error>) -> Void
    
    // MARK: - 회원가입
    func signUp(userName: String,
                email: String,
                password: String,
                completion: @escaping AuthCompletion) {
        // 회원가입
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("\(#function)---createUser---\(error)")
                print("회원가입 실패")
                return
            }
            // 딕셔너리 만들기
            let userDatas = [API_String.userName: userName,
                             API_String.email: email]
            // uid 가져오기
            guard let uid = result?.user.uid else { return }
            // DB에 저장
            API_String
                .userDB
                .document(uid)
                .setData(userDatas) { error in
                    // 회원가입에 실패했다면
                    if let error = error {
                        print("\(#function)---userDB_AddDocument---\(error)")
                        print("회원가입 - 데이터 저장 실패")
                        completion(.failure(error))
                        return
                    }
                    // 회원가입 성공
                    print("회원가입 성공")
                    completion(.success(()))
                }
        }
    }
    
    
    
    // MARK: - 로그인
    func login(email: String,
               password: String,
               completion: @escaping AuthCompletion) {
        // 로그인
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            // 로그인에 실패했다면
            if let error = error {
                print("\(#function)---login---\(error)")
                print("로그인 실패")
                completion(.failure(error))
                return
            }
            
            // 로그인 성공
            print("로그인 성공")
            completion(.success(()))
        }
    }
    
    
    
    // MARK: - 로그아웃
    func logout(completion: @escaping AuthCompletion) {
        do {
            // 로그아웃
            try Auth.auth().signOut()
            print("로그아웃 성공")
            completion(.success(()))
        } catch {
            print("로그아웃 실패")
            completion(.failure(error))
        }
    }
}
