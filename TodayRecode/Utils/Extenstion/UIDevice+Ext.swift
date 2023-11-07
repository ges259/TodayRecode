//
//  UIDevice+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/11/06.
//

import UIKit

extension UIDevice {
    
    // 아이폰 분기처리
    public var isiPhoneSE: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            // iPhone 6, 6s, 7, 8, SE2, SE3
            && ((UIScreen.main.bounds.size.height == 667
                 && UIScreen.main.bounds.size.width == 375))
            // iPhone 6+, 6s+, 7+, 8+
            || ((UIScreen.main.bounds.size.height == 736
                 && UIScreen.main.bounds.size.width == 414)) {
            return true
        }
        // 나머지 false
        return false
    }
}
