//
//  ViewController+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit

extension UIViewController {
    func todayReturn(todayFormat: TodayFormatEnum, date: Date = Date()) -> String {
        let formatter = DateFormatter()
            formatter.dateFormat = todayFormat.today
        return formatter.string(from: date)
    }
    
    
    
    
    
    func configureNavTitle(_ currentController: String, month: String) -> NSMutableAttributedString {
        // Mutable_Attributed_String 설정
        let attributedTitle = NSMutableAttributedString(
            string: currentController,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        )
        attributedTitle.append(NSAttributedString(
            string: "\n\(month)",
            attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
        )
        return attributedTitle
    }
}
