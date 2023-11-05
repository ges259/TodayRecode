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
        tv.autocapitalizationType = .none
        tv.autocorrectionType = .no
        tv.smartDashesType = .no
        tv.smartInsertDeleteType = .no
        tv.smartQuotesType =  .no
        tv.spellCheckingType = .no
        
        tv.keyboardType = .default
        tv.returnKeyType = .done
        
        tv.sizeToFit()
        
        // 폰트 크기
        tv.font = UIFont.systemFont(ofSize: fontSize)
        return tv
    }
    
    func numberOfLine() -> CGFloat {
        let size = CGSize(width: self.frame.width, height: .infinity)
        let estimatedSize = sizeThatFits(size)
        return (estimatedSize.height - 36) / (self.font!.lineHeight)
    }
}
