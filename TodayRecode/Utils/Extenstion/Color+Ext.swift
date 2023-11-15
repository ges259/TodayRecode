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
    static let blue_base: UIColor = UIColor.rgb(red: 204, green: 224, blue: 255)
    // 포인트 색상
    static let blue_Point: UIColor = UIColor.rgb(red: 135, green: 196, blue: 255)
    
    
    
    
    static let customWhite5: UIColor = UIColor.white.withAlphaComponent(0.6)
    static let customblue1: UIColor = UIColor.systemBlue.withAlphaComponent(0.2)
    
    
    
    static let customblue6: UIColor = UIColor.systemBlue.withAlphaComponent(0.6)
    static let btnGrayColor: UIColor = UIColor.systemGray3
    static let customBlack5: UIColor = UIColor.black.withAlphaComponent(0.5)
    
    static let alertCancelBlack: UIColor = UIColor.black.withAlphaComponent(0.7)
    static let alertTitleGray: UIColor = UIColor(displayP3Red: 69/255, green: 65/255, blue: 65/255, alpha: 1)
}
