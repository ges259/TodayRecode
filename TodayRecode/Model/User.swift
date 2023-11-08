//
//  User.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/31.
//

struct User {
    let email: String
    let userName: String
    
//    let timeFormat: Int
//    let dateFormat: Int
    
    init(dictionary: [String: Any]) {
        self.email = dictionary[API_String.email] as? String ?? ""
        self.userName = dictionary[API_String.userName] as? String ?? ""
        
        timeFormat_Static = dictionary[API_String.timeFormat] as? Int ?? 0
        dateFormat_Static = dictionary[API_String.dateFomat] as? Int ?? 0
        print(dictionary[API_String.timeFormat] as? Int ?? 0)
        
        print(dictionary[API_String.dateFomat] as? Int ?? 0)
//        self.timeFormat = dictionary[API_String.timeFormat] as? Int ?? 0
//        self.dateFormat = dictionary[API_String.dateFomat] as? Int ?? 0
    }
}
