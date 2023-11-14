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
        // 리턴할 urlString배열
        var urlStringArray: [String: String] = [:]
//        var urlStringArray: [String] = []
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
            
//            print("\(filePath)_\(n)")
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
//                    urlStringArray.append(imageUrl)
                    urlStringArray["\(filePath)_\(n)"] = imageUrl
                    
                    
                    // 가져온 이미지의 개수와 - 배열의 개수가 같다면 -> 리턴
                    if count == urlStringArray.count {
                        completion(urlStringArray)
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
            // if image does not exists in cache
            guard let url = URL(string: url_String) else { return }
            // fetch contents of URL
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                // handle error
                if let error = error {
                    print("Failed to load image with error", error.localizedDescription)
                    return
                }
                // image url 데이터가 있는 지 확인
                guard let imageData = data else { return }
                
                // set image using image datas
                let phothoImage = UIImage(data: imageData)
                
                // set key and value for iamge cache
                UserData.imageCache[url.absoluteString] = phothoImage
                
                guard let phothoImage = phothoImage else { return }
                returnImg.append(phothoImage)
                
                // set image
                DispatchQueue.main.async {
                    if returnImg.count == urlStrings.count {
                        completion(returnImg)
                    }
                }
            }.resume()
        }
    }
    
    
    
    // MARK: - 이미지 삭제
    func deleteImage(imageUrl: [String: String]?) {
        print("1")
        if let imageUrl = imageUrl?.keys {
            print("2")
            
            imageUrl.forEach({ url_String in
                let ref = Storage.storage().reference().child(url_String)
                print("3")
                print(url_String)
                ref.delete { error in
                    print("4")
                    // 에러가 있다면
                    if let _ = error {
                        print("000000")
                        return
                    }
                    print("5")
                    print("이미지 삭제 성공")
                }
            })
        }
    }
    
}
