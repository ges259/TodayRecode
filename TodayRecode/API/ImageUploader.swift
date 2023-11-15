//
//  ImageUploader.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/11/10.
//

import UIKit
import FirebaseStorage

struct ImageUploader {
    
    static let shared: ImageUploader = ImageUploader()
    init() {}
    
    
    
    // MARK: - 이미지 업로드
    func uploadImage(image: [UIImage],
                     completion: @escaping ([String: String]) -> Void) {
        // 리턴할 imageDictionary배열
        var imageDictionary: [String: String] = [:]
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
                // imageDictionary가져오기
                storageRef.downloadURL { url, error in
                    // 에러가 있다면
                    if let _ = error {
                        return
                    }
                    // url 옵셔널 바인딩
                    guard let imageUrl = url?.absoluteString else { return }
                    // imageDictionary에 추가
                    imageDictionary["\(filePath)_\(n)"] = imageUrl
                    
                    // 가져온 이미지의 개수와 - 리턴할 딕셔너리의 개수가 같다면 -> 리턴
                    if count == imageDictionary.count {
                        DispatchQueue.main.async {
                            completion(imageDictionary)
                        }
                    }
                }
            }
        }
    }
    
    
    
    // MARK: - 이미지 로드
    // URL을 통해 이미지를 불러오는 API함수
    func loadImageView(with urlStrings: [String],
                       completion: @escaping ([UIImage]?) -> Void) {
        
        var returnImg: [UIImage] = []
        
        urlStrings.forEach { url_String in
            // 만약 이미지가 캐시에 있다면
            if let cachedImage = UserData.imageCache[url_String] {
                returnImg.append(cachedImage)
                
                if returnImg.count == urlStrings.count {
                    completion(returnImg)
                }
                return
            }
            // url_String을 URL로 바꿈
            guard let url = URL(string: url_String) else { return }
            // url을 통해 이미지를 가져오기
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                // 에러가 생겼다면
                if let error = error {
                    print("Failed to load image with error", error.localizedDescription)
                    return
                }
                // image url 데이터가 있는 지 확인
                guard let imageData = data else { return }
                // 이미지 데이터를 이미지로 바꿈 + 옵셔널 바인딩
                guard let phothoImage = UIImage(data: imageData) else { return }
                
                // 캐시에 저장 [이미지Url : 이미지]
                UserData.imageCache[url.absoluteString] = phothoImage
                // 리턴할 변수에 이미지 넣기
                returnImg.append(phothoImage)
                
                // 가져온 이미지의 url의 개수와 리턴할 이미지의 개수가 같다면 -> completion
                if returnImg.count == urlStrings.count {
                    DispatchQueue.main.async {
                        completion(returnImg)
                    }
                }
            }.resume()
        }
    }
    
    
    
    // MARK: - 이미지 삭제
    func deleteImage(imageDictionary: [String: String]?) {
        // 이미지 딕셔너리의 key값(이미지가 저장된 경로) 옵셔널 바인딩
        if let imagePath = imageDictionary?.keys {
            // forEach를 통해 이미지 경로의 모든 이미지를 삭제
            imagePath.forEach({ url_String in
                let ref = Storage.storage().reference().child(url_String)
                // 이미지 삭제
                ref.delete { error in
                    // 에러가 있다면
                    if let _ = error {
                        return
                    }
                }
            })
        }
    }
}
