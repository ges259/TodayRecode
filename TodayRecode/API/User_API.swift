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
    
    
    // MARK: - 유저 정보 가져오기
    func fetchUser(completion: @escaping (User?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        API_String.userDB.document(uid).getDocument { snapshot, error in
            if let _ = error {
                print("\(#function)---Error")
                completion(nil)
                return
            }
            
            guard let dictionary: [String: Any] = snapshot?.data() as? [String: Any] else {
                completion(nil)
                return
            }
            
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    
    
    
    // MARK: - 날짜 형식 바꾸기
    
    
    
    

    // MARK: - 시간 형식 바꾸기
    
    
    
    
    
    
}
