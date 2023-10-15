//
//  APIService.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import Foundation
import FirebaseFirestore



struct APIService {
    
    static let shared: APIService = APIService()
    init() {}
    

    
    
    
    func createData() {
        
        APIConstants.diaryDB
            .document("vPr2zA8kLuoaKupLzkoB")
            .setData([
                APIConstants.image_url: "iamgeURL_22",
                APIConstants.context: "context_22"
            ])
    }
    
    
    
    
    func readData() {
        APIConstants.diaryDB
            .document("vPr2zA8kLuoaKupLzkoB")
            .collection("231014")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("error ----- \(error)")
                    return
                } else {
                    print("success")
                }
            }
    }
    
    
    
      
    
    
    
    
}
