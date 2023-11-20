//
//  User.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/31.
//

struct User {
    let email: String
    let userName: String
    let loginMethod: String
    
    init(dictionary: [String: Any]) {
        self.email = dictionary[API_String.email] as? String ?? ""
        self.userName = dictionary[API_String.userName] as? String ?? ""
        self.loginMethod = dictionary[API_String.loginMethod] as? String ?? ""
        
        Format.timeFormat_Static = dictionary[API_String.timeFormat] as? Int ?? 0
        Format.dateFormat_Static = dictionary[API_String.dateFomat] as? Int ?? 0
    }
}
