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
    
    // MARK: - 로그아웃
    func logout(completion: @escaping AuthCompletion) {
        do {
            // 로그아웃
            try Auth.auth().signOut()
            // 로그아웃 성공
            completion(.success(()))
        } catch {
            // 로그아웃 실패
            completion(.failure(error))
        }
    }
    
    
    
    
    
    // MARK: - 이메일
    
    
    
    // MARK: - 회원가입
    func emailSignUp(userName: String,
                email: String,
                password: String,
                completion: @escaping AuthCompletion) {
        // 회원가입
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
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
                        completion(.failure(error))
                        return
                    }
                    // 회원가입 성공
                    completion(.success(()))
                }
        }
    }
    
    
    
    // MARK: - 로그인
    func emailLogin(email: String,
               password: String,
               completion: @escaping AuthCompletion) {
        // 로그인
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            // 로그인에 실패했다면
            if let error = error {
                completion(.failure(error))
                return
            }
            // 로그인 성공
            completion(.success(()))
        }
    }
    
    
    

    
    
    // MARK: - 애플 로그인

    
    
}
