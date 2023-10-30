//
//  UILabel+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//

import UIKit

extension UILabel {
    /// 일반적인 레이블을 설정하는 메서드
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
    /// 네비게이션 타이틀을 설정하는 메서드
    static func navTitleLbl() -> UILabel {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }
}
