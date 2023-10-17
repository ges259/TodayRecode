//
//  UITextView+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//

import UIKit

extension UITextView {
    static func configureTV(fontSize: CGFloat) -> UITextView {
        let tv = UITextView()
        
        // 기본 설정
        tv.autocorrectionType = .no
        tv.autocorrectionType = .no
        tv.smartDashesType = .no
        tv.smartQuotesType =  .no
        tv.smartInsertDeleteType = .no
        tv.keyboardType = .default
        tv.returnKeyType = .done
        
        tv.sizeToFit()
        
        
        
        // 폰트 크기
        tv.font = UIFont.systemFont(ofSize: fontSize)
        return tv
    }
}
