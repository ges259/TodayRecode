//
//  UIButton+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//

import UIKit

extension UIButton {
    static func configureBtnWithImg(image: UIImage?,
                             tintColor: UIColor,
                             backgroundColor: UIColor? = UIColor.clear)
    -> UIButton {
        let btn = UIButton(type: .system)
            btn.setImage(image, for: .normal)
            btn.tintColor = tintColor
        
            btn.backgroundColor = backgroundColor

        return btn
    }
    
    static func configureBtnWithTitle(title: String,
                                      font: UIFont,
                                      backgroundColor: UIColor)
    -> UIButton {
        let btn = UIButton(type: .system)
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = font
            btn.backgroundColor = backgroundColor
        
            btn.titleLabel?.textColor = UIColor.black
        return btn
    }
}
