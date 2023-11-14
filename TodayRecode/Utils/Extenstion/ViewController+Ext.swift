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
                           navTitleSetEnum: NavTitleSetEnum,
                           date: Date = Date())
    -> NSMutableAttributedString {
        // 달력의 날짜 가져오기 (년,월,일)
        let selectedDate = Date.dateArray_yyyy_M_d(date: date)
        // 올해 년도 가져오기
        let currentYear = Date.dateReturn_Custom(todayFormat: .yyyy년)
        // 날짜 문자열 (ex - 11월 / 2023년 11월 / 2023년 11월 5일)
        var dateString: String = ""
        
        if navTitleSetEnum == .yyyy년M월 {
            // 달력의 현재 년도와 올해 년도가
                // 같으면 -> 몇 월인지만 표시
                // 다르면 -> 몇 년도 몇 월인지 까지 표시
            dateString = selectedDate[0] == currentYear
            ? selectedDate[1]
            : "\(selectedDate[0]) \(selectedDate[1])"
            
        } else {
            // 달력의 현재 년도와 올해 년도가
                // 같으면 -> 몇 월인지만 표시
                // 다르면 -> 몇 년도 몇 월인지 까지 표시
            dateString = selectedDate[0] == currentYear
            ? "\(selectedDate[1]) \(selectedDate[2])"
            : "\(selectedDate[0]) \(selectedDate[1]) \(selectedDate[2])"
        }
        // Mutable_Attributed_String 설정
        let attributedTitle = NSMutableAttributedString(
            string: "\(currentController)\n",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        )
        attributedTitle.append(NSAttributedString(
            string: "\(dateString)",
            attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)])
        )
        return attributedTitle
    }
    
    
    
    
    
    // MARK: - 커스텀 얼럿창
    func customAlert(alertStyle: UIAlertController.Style = .actionSheet,
                     withTitle title: String,
                     message: String? = nil,
                     cancelBtnColor: UIColor = UIColor.cancelGray,
                     
                     firstBtnName: String? = nil,
                     firstBtnColor: UIColor = UIColor.black,
                     
                     secondBtnName: String? = nil,
                     secondBtnColor: UIColor = UIColor.black,
                     
                     completion: @escaping (Int) -> Void) {
        // ********** 얼럿창 만들기 **********
        let alertController = UIAlertController(
            title: "",
            message: message,
            preferredStyle: alertStyle)
        
        // ********** 취소 버튼 **********
        let cancelAction = self.customAlertAction(
            style: .cancel,
            title: "취소",
            color: UIColor.black.withAlphaComponent(0.7))
        alertController.addAction(cancelAction)
        
        // ********** 첫번째 버튼 **********
        if let firstBtnName = firstBtnName {
            let first = self.customAlertAction(
                style: .default,
                title: firstBtnName,
                color: firstBtnColor) { completion(0) }
            alertController.addAction(first)
        }
        
        // ********** 두번째 버튼 **********
        if let secondBtnName = secondBtnName {
            let second = self.customAlertAction(
                style: .default,
                title: secondBtnName,
                color: secondBtnColor) { completion(1) }
            alertController.addAction(second)
        }
        
        // ********** 타이틀 **********
        let titleString = self.alertTitleAndFont(
            title: title,
            font: .systemFont(ofSize: 14))
        alertController.setValue(titleString, forKey: "attributedTitle")
        
        // ********** 메시지 **********
        if let message = message {
            let messageString = self.alertTitleAndFont(title: message,
                                                       font: .systemFont(ofSize: 10))
            alertController.setValue(messageString, forKey: "attributedMessage")
        }
        
        // ********** 화면이동 **********
        present(alertController, animated: true) //보여줘
    }
    
    
    // MARK: - API 실패 시 얼럿창 띄우기
    func apiFail_Alert() {
        self.customAlert(
            alertStyle: .alert,
            withTitle: "오류",
            message: "다시 시도해 주세요.") { _ in }
    }
    
    
    
    
    
    
    // MARK: - 얼럿 타이틀 및 폰트 설정
    private func alertTitleAndFont(title: String, font: UIFont) -> NSAttributedString {
        return NSAttributedString(
            string: title,
            attributes: [ //타이틀 폰트사이즈랑 글씨
                NSAttributedString.Key.font : font,
                NSAttributedString.Key.foregroundColor : UIColor.alertCancelGray])
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
    
    
    
    
    
    
    
    // MARK: - 이메일 및 비밀번호 형식
    func isValidEmail(testStr: String?) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isValidPassword(pw: String?) -> Bool{
        if let hasPassword = pw{
            if hasPassword.count < 6 {
                return false
            }
        }
        return true
    }
}
