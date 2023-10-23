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
    
    
    
    /// 텍스트뷰의 상단으로 스크롤
    func getYPosition(scrollView : UIScrollView, view: UIView, upSize: CGFloat) -> CGFloat{
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: scrollView)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            
            let childYPosition = childStartPoint.y - upSize
            return childYPosition
        }
        return 0.0
    }
}
