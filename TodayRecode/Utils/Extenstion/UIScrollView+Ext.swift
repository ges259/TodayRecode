//
//  UIScrollView+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/19.
//

import UIKit

extension UIScrollView {
//    func scrollToBottom() {
//        let offset = CGPoint(
//            x: 0,
//            y: contentSize.height - bounds.height
//        )
//        setContentOffset(offset, animated: false)
//    }
    
    /// 스크롤뷰 내부의 원하는 레이아웃 위치로 이동
    func scrollToView(view: UIView,
                      keyboardSize: CGFloat,
                      animated: Bool = false) {
        
        if let origin = view.superview {
            // scrollView로 부터 원하는 레이아웃(textField)의 거리를 구함
            let childStartPoint = origin.convert(view.frame.origin,
                                                 to: self)
            // (현재 높이) - (키보드 크기) - (텍스트뷰의 크기)
            let height: CGFloat = (self.frame.size.height - keyboardSize) - view.frame.height
            
            let offset: CGFloat = height > 0
            ? childStartPoint.y - height // textView의 크기가 작음
            : childStartPoint.y + height // textView의 크기가 큼
            
            // 스크롤뷰 이동
            self.scrollRectToVisible(
                CGRect(x: 0,
                       y: offset,
                       width: 1,
                       height: self.frame.height),
                animated: animated)
        }
    }
}
