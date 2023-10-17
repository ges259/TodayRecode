//
//  UIButton+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//

import UIKit

extension UIButton {
    static func configureBtn(image: ImageEnum,
                             tintColor: UIColor,
                             backgroundColor: UIColor? = UIColor.clear)
    -> UIButton {
        let btn = UIButton(type: .system)
            btn.setImage(UIImage(systemName: image.imageString), for: .normal)
            btn.tintColor = tintColor
        
            btn.backgroundColor = backgroundColor

        return btn
    }
}
