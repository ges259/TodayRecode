//
//  Color+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    // 기본 색상
    static let blue_Base: UIColor = UIColor.rgb(red: 204, green: 224, blue: 255)
    // 포인트 색상
    static let blue_Point: UIColor = UIColor.rgb(red: 135, green: 196, blue: 255)
    static let blue_setting: UIColor = UIColor.rgb(red: 57, green: 167, blue: 255)
    
    
    // 캘린더 오늘 표시 and 로그인버튼 비활성화 상태
    static let blue_Lightly: UIColor = UIColor.systemBlue.withAlphaComponent(0.15)
    
    
    // 라이트모드/다크모드
    static let alert_Title: UIColor = UIColor(named: "alertTextColor") ?? UIColor.black
    static let alert_Cancel: UIColor = UIColor(named: "alertCancelColor") ?? UIColor.black
    
    
    // 하얀색이 들어가는 모든 뷰의 기본 생상
    static let white_Base: UIColor = UIColor.white.withAlphaComponent(0.6)
    // 디테일뷰의 악세서리뷰 레이아웃들의 색상
    static let gray_Accessoroy: UIColor = UIColor.systemGray3
}
