//
//  UILabel+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//

import UIKit

extension UILabel {
    static func configureLbl(text: String? = nil,
                             font: UIFont,
                             textColor: UIColor = UIColor.black)
    -> UILabel {
        
        let lbl = UILabel()
            lbl.text = text
            lbl.font = font
            lbl.textColor = textColor
        return lbl
    }
}
