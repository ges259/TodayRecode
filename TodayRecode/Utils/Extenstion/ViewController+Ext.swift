//
//  ViewController+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit
import Photos
import JGProgressHUD

extension UIViewController {
    
    // MARK: - 로딩뷰
    static let hud = JGProgressHUD(style: .dark)
    /// 테이블뷰 / 콜렉션뷰의 리로드를 기다리는 동안 -> 화면을 터치 못하도록 설정
    func showLoading(_ show: Bool) {
        DispatchQueue.main.async {
            if show {
                UIViewController.hud.show(in: self.view, animated: true)
                self.tabBarIsEnabled(false)
            } else {
                UIViewController.hud.dismiss(animated: true)
                self.tabBarIsEnabled(true)
            }
        }
    }
    
    /// 탭바를 사용할 수 없게 / 있게 만드는 메서드
    private func tabBarIsEnabled(_ isEnabled: Bool) {
        let tabBarItemsArray = self.tabBarController?.tabBar.items
        tabBarItemsArray?.forEach({ item in
            item.isEnabled = isEnabled
        })
    }
    
    
    
    
    
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
        let attributedTitle = self.customAttributedTitle(
            firstTitle: "\(currentController)\n",
            firstFont: UIFont.systemFont(ofSize: 13.5),
            secondTitle: dateString,
            secondFont: UIFont.boldSystemFont(ofSize: 17))
        return attributedTitle
    }
    
    
    
    
    
    // MARK: - Attributed_Title
    func customAttributedTitle(firstTitle: String,
                               firstFont: UIFont,
                               secondTitle: String,
                               secondFont: UIFont,
                               setSpacing: CGFloat? = nil)
    -> NSMutableAttributedString {
        // Mutable_Attributed_String 설정
        let attributedTitle = NSMutableAttributedString(
            string: firstTitle,
            attributes: [NSAttributedString.Key.font: firstFont]
        )
        attributedTitle.append(NSAttributedString(
            string: secondTitle,
            attributes: [NSAttributedString.Key.font : secondFont])
        )
        
        if let height = setSpacing {
            // 글자 간격 설정
            return NSMutableAttributedString.setSpacing(
                context: "",
                attributed_String: attributedTitle,
                setSpacing: height)
        }
        return attributedTitle
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
    // 이메일이 형식에 맞는지 확인
    func isValidEmail(testStr: String?) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    /// 비밀번호가 6자리 이상인지 체크하는 메서드
    func isValidPassword(pw: String?) -> Bool{
        if let hasPassword = pw{
            if hasPassword.count < 6 {
                return false
            }
        }
        return true
    }
    
    
    
    
    
    
    
    // MARK: - 커스텀 얼럿창
    func customAlert(alertStyle: UIAlertController.Style = .alert,
                     alertEnum: AlertEnum,
                     firstBtnColor: UIColor = UIColor.alert_Title,
                     secondBtnColor: UIColor = UIColor.alert_Title,
                     completion: @escaping (Int) -> Void) {
        
        let stringArray: [String] = alertEnum.alert_StringArray
        
        // ********** 얼럿창 만들기 **********
        let alertController = UIAlertController(
            title: "",
            message: nil,
            preferredStyle: alertStyle)
        
        // ********** 취소 버튼 **********
        let cancelBtnTitle = stringArray[2] != ""
        ? "취소"
        : "확인"
        
        let cancelAction = self.customAlertAction(
            style: .cancel,
            title: cancelBtnTitle,
            color: UIColor.alert_Cancel)
        alertController.addAction(cancelAction)
        
        // ********** 첫번째 버튼 **********
        if stringArray[2] != "" {
            let first = self.customAlertAction(
                style: .default,
                title: stringArray[2],
                color: firstBtnColor) { completion(0) }
            alertController.addAction(first)
        }
        
        // ********** 두번째 버튼 **********
        if stringArray[3] != "" {
            let second = self.customAlertAction(
                style: .default,
                title: stringArray[3],
                color: secondBtnColor) { completion(1) }
            alertController.addAction(second)
        }
        
        // ********** 타이틀 **********
        let titleString = self.alertTitleAndFont(
            title: stringArray[0],
            font: .systemFont(ofSize: 15))
        alertController.setValue(titleString, forKey: "attributedTitle")
        
        // ********** 메시지 **********
        if stringArray[1] != "" {
            let messageString = self.alertTitleAndFont(
                title: stringArray[1],
                font: .systemFont(ofSize: 13))
            alertController.setValue(messageString, forKey: "attributedMessage")
        }
        
        // ********** 화면이동 **********
        present(alertController, animated: true) //보여줘
    }
    // MARK: - 얼럿 타이틀 및 폰트 설정
    private func alertTitleAndFont(title: String,
                                   font: UIFont)
    -> NSAttributedString {
        return NSAttributedString(
            string: title,
            attributes: [ //타이틀 폰트사이즈랑 글씨
                NSAttributedString.Key.font : font,
                NSAttributedString.Key.foregroundColor : UIColor.alert_Title])
        
    }
    // MARK: - 커스텀 얼럿 액션 설정
    private func customAlertAction(style: UIAlertAction.Style,
                                   title: String,
                                   color: UIColor,
                                   completion: (() -> Void)? = nil)
    -> UIAlertAction{
        let second = UIAlertAction(
            title: title,
            style: style) { _ in completion?() }
        second.setValue(color, forKey: "titleTextColor")
        return second
    }
}
