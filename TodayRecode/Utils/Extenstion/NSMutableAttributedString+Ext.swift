//
//  NSMutableAttributedString+Ext.swift
//  TodayRecord
//
//  Created by 계은성 on 2023/11/22.
//

import UIKit

extension NSMutableAttributedString {
    // MARK: - 글자 간격 설정
    /// 글자 간격 설정
    static func setSpacing(context: String,
                           attributed_String: NSAttributedString? = nil,
                           setSpacing: CGFloat)
    -> NSMutableAttributedString{
        
        var attrString: NSMutableAttributedString
        
        
        if let attributed_String = attributed_String {
            attrString = NSMutableAttributedString(attributedString: attributed_String)
        } else {
            attrString = NSMutableAttributedString(string: context)
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = setSpacing
            attrString.addAttribute(
                NSAttributedString.Key.paragraphStyle,
                value: paragraphStyle,
                range: NSMakeRange(0, attrString.length))
        return attrString
    }
}
