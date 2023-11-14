//
//  Color+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit

extension UIColor {
    
    static let customWhite7: UIColor = UIColor.white.withAlphaComponent(0.7)
    
    
    static let customblue6: UIColor = UIColor.systemBlue.withAlphaComponent(0.6)
    static let btnGrayColor: UIColor = UIColor.systemGray3
    static let customBlack5: UIColor = UIColor.black.withAlphaComponent(0.5)
    
    
    static let customgray5: UIColor = UIColor.systemGray6.withAlphaComponent(0.5)
    
    
    static let cancelGray: UIColor = UIColor(displayP3Red: 174/255, green: 174/255, blue: 174/255, alpha: 1)
    static let alertCancelGray: UIColor = UIColor(displayP3Red: 69/255, green: 65/255, blue: 65/255, alpha: 1)
    
    
    
    
    
    
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    // light_Mode
    // UIColor.systemGray6
    static let customWhite5: UIColor = UIColor.white.withAlphaComponent(0.75)
    static let customblue1: UIColor = UIColor.systemBlue.withAlphaComponent(0.2)
    static let customblue3: UIColor = UIColor.systemBlue.withAlphaComponent(0.3)
    
    
    
    static let blue_base: UIColor = UIColor.rgb(red: 204, green: 224, blue: 255)
    static let blue_tab: UIColor = UIColor.rgb(red: 135, green: 196, blue: 255)
}
