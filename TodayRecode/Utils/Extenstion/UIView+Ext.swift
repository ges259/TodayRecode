//
//  UIView+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//

import UIKit

extension UIView {
    static func backgroundView(color: UIColor) -> UIView {
        let view = UIView()
            view.backgroundColor = color
        return view
    }
    
    func todayReturn(todayFormat: TodayFormatEnum, date: Date = Date()) -> String {
        let formatter = DateFormatter()
            formatter.dateFormat = todayFormat.today
        return formatter.string(from: date)
    }
    
//    func getYPosition(scrollView : UIScrollView, upSize: CGFloat) -> CGFloat{
//        if let origin = self.superview {
//            print(origin)
//            // Get the Y position of your child view
//            let childStartPoint = origin.convert(self.frame.origin, to: scrollView)
//            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
//
//            let childYPosition = childStartPoint.y - upSize
//            return childYPosition
//        }
//        return 0.0
//    }
}
