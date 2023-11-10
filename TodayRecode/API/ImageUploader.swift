//
//  ImageUploader.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/11/10.
//

import UIKit
import FirebaseStorage

struct ImageUploader {
    
    // MARK: - Upload_Image
    static func uploadImage(image: [UIImage],
                            completion: @escaping ([String]) -> Void) {
        
        // 리턴할 urlString배열
        var urlStringArray: [String] = []
        // 저장할 이미지의 개수
        let count = image.count
        
        // 이미지의 개수만큼 루프
        for (n, img) in image.enumerated() {
            // 이미지 데이터로 만들기
            guard let data = img.jpegData(compressionQuality: 0.8) else { return }
            // 파일 이름 생성
            let fileName = NSUUID().uuidString
            let filePath = "\(fileName)/images"
            
            // 경로 생성
            let storageRef = Storage.storage().reference().child("\(filePath)_\(n)")
            // 데이터 저장
            storageRef.putData(data) { (_, error) in
                // url_String가져오기
                storageRef.downloadURL { url, error in
                    // 에러가 있다면
                    if let error = error {
                        print("downloadUrl error ----- \(error.localizedDescription)")
                        return
                    }
                    // url 옵셔널 바인딩
                    guard let imageUrl = url?.absoluteString else { return }
                    // url_String배열에 추가
                    urlStringArray.append(imageUrl)
                    
                    // 가져온 이미지의 개수와 - 배열의 개수가 같다면 -> 리턴
                    if count == urlStringArray.count {
                        completion(urlStringArray)
                    }
                }
            }
        }
    }
}
