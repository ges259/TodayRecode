//
//  UIButton+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//

import UIKit

extension UIButton {
    /// 이미지가 들어간 버튼 설정
    static func buttonWithImage(image: UIImage?,
                                tintColor: UIColor = .black,
                                backgroundColor: UIColor? = UIColor.clear)
    -> UIButton {
        let btn = UIButton(type: .system)
            btn.setImage(image, for: .normal)
            btn.tintColor = tintColor
        
            btn.backgroundColor = backgroundColor

        return btn
    }
    
    /// 글자가 들어간 버튼 설정
    static func buttonWithTitle(title: String,
                                      titleColor: UIColor = UIColor.black,
                                      font: UIFont,
                                      backgroundColor: UIColor)
    -> UIButton {
        let btn = UIButton(type: .system)
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = font
            btn.backgroundColor = backgroundColor
        
            btn.setTitleColor(titleColor, for: .normal)
        return btn
    }
}
