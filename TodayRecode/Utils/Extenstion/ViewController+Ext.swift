//
//  ViewController+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit
import Photos

extension UIViewController {
    
    // MARK: - 네비게이션 타이틀 설정
    func configureNavTitle(_ currentController: String,
                           year: String,
                           month: String)
    -> NSMutableAttributedString {
        // 올해 년도 가져오기
        let currentYear = Date.todayReturnString(todayFormat: .yyyy)
        // 달력의 현재 년도와 올해 년도가
            // 같으면 -> 몇 월인지만 표시
            // 다르면 -> 몇 년도 몇 월인지 까지 표시
        let first = currentYear == "\(year)"
        ? month
        : "\(year) \(month)"
        
        // Mutable_Attributed_String 설정
        let attributedTitle = NSMutableAttributedString(
            string: "\(currentController)\n",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        )
        attributedTitle.append(NSAttributedString(
            string: "\(first)",
            attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)])
        )
        
        return attributedTitle
    }
    
    
    // MARK: - 커스텀 얼럿창
    func customAlert(withTitle title: String,
                     message: String? = nil,
                     
                     firstBtnName: String,
                     firstBtnColor: UIColor = UIColor.black,
                     
                     secondBtnName: String? = nil,
                     secondBtnColor: UIColor = UIColor.black,
                     
                     completion: @escaping (Int) -> Void) {
        // ********** 얼럿창 만들기 **********
        let alertController = UIAlertController(
            title: "",
            message: message,
            preferredStyle: .actionSheet)
        
        // ********** 취소 버튼 **********
        let cancelAction = self.customAlertAction(
            style: .cancel,
            title: "취소",
            color: UIColor.cancelGray)
        alertController.addAction(cancelAction)
        
        // ********** 첫번째 버튼 **********
        let first = self.customAlertAction(
            style: .default,
            title: firstBtnName,
            color: firstBtnColor) { completion(0) }
        alertController.addAction(first)
        
        // ********** (두번째 버튼)? **********
        if let secondBtnName = secondBtnName {
            let second = self.customAlertAction(
                style: .default,
                title: secondBtnName,
                color: secondBtnColor) { completion(1) }
            alertController.addAction(second)
        }
        
        // ********** 설명 창 **********
        let attributedString = NSAttributedString(
            string: title,
            attributes: [ //타이틀 폰트사이즈랑 글씨
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                NSAttributedString.Key.foregroundColor : UIColor.cancelGray2222222])
        alertController.setValue(attributedString, forKey: "attributedTitle")
        
        // ********** present **********
        present(alertController, animated: true) //보여줘
    }
    
    // MARK: - 커스텀 얼럿 액션 설정
    private func customAlertAction(style: UIAlertAction.Style,
                           title: String,
                           color: UIColor,
                           completion: (() -> Void)? = nil) -> UIAlertAction{
        let second = UIAlertAction(
            title: title,
            style: style) { _ in completion?() }
        second.setValue(color, forKey: "titleTextColor")
        return second
    }
    
    
    
    
    
    
    // MARK: - PHAsset -> UIImage
    /// PHAsset Type 이었던 사진을 UIImage Type 으로 변환하는 함수
    func convertAssetToImage(selectedAssets: [PHAsset]) -> [UIImage] {
        var selectedImages: [UIImage] = []
        
        for i in 0 ..< selectedAssets.count {
            let imageManager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            var thumbnail = UIImage()
            imageManager.requestImage(
                for: selectedAssets[i],
                targetSize: CGSize(
                    width: selectedAssets[i].pixelWidth,
                    height: selectedAssets[i].pixelHeight),
                contentMode: .aspectFill,
                options: option) {
                (result, info) in
                thumbnail = result!
            }
            
            let data = thumbnail.jpegData(compressionQuality: 1)
            let newImage = UIImage(data: data!)
            selectedImages.append(newImage! as UIImage)
        }
        
        return selectedImages
    }
    
}
