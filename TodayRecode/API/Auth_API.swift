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
//            UserDefaults.standard.set("email", forKey: UserData.loginMethod)
            
            // 로그아웃 성공
            completion(.success(()))
        } catch {
            // 로그아웃 실패
            completion(.failure(error))
        }
    }
    
    
    
    
    
    
    
    
    
    // MARK: - 회원가입
    func emailSignUp(userName: String,
                     email: String,
                     password: String,
                     completion: @escaping AuthCompletion) {
        // 회원가입
        Auth.auth().createUser(withEmail: email,
                               password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            // 딕셔너리 만들기
            let userDatas = [API_String.userName: userName,
                             API_String.email: email,
                             API_String.loginMethod: LoginMethod.email.description]
            // uid 가져오기
            guard let uid = result?.user.uid else { return }
            // DB에 저장
            self.saveUserData(uid: uid,
                              userDatas: userDatas) { result in
                switch result {
                case .success(): completion(.success(()))
                case .failure(_): completion(result)
                }
            }
        }
    }
    
    func saveUserData(uid: String,
                      userDatas: [String: String],
                      completion: @escaping AuthCompletion) {
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
    
    
    
    // MARK: - 로그인
    func emailLogin(email: String,
                    password: String,
                    completion: @escaping AuthCompletion) {
        
        // 로그인
        Auth.auth().signIn(withEmail: email,
                           password: password) { result, error in
            // 로그인에 실패했다면
            if let error = error {
                completion(.failure(error))
                return
            }
            // 로그인 성공
            completion(.success(()))
        }
    }
    
    
    
    
    
    
    // MARK: - 이메일 사용자 재인증
    // 애플 로그인의 경우 ViewController+Ext에 재인증이 있음
    func deleteEmailAccount(password: String?,
                            completion: @escaping AuthCompletion) {
        

        guard let user = Auth.auth().currentUser,
              let email = UserData.user?.email,
              let password = password
        else { return }
        
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: email, password: password)

        // re authenticate the user
        user.reauthenticate(with: credential) { (authDataResult, error) in
            if let error = error {
                // An error happened.
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    
    // MARK: - 회원 탈퇴
    func deleteFirebaseAccount(completion: @escaping AuthCompletion) {
        // 유저가 있는지 확인
        if let user = Auth.auth().currentUser {
            // 유저 데이터 삭제
            User_API.shared.deleteUserData()
            // 유저 계정 삭제
            user.delete { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
        }
    }
}
