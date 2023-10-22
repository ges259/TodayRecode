//
//  Protocol.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//

import Foundation



protocol AccessoryViewDelegate: AnyObject {
    func cameraBtnTapped()
    func albumBtnTapped()
    func accessoryRightBtnTapped()
    
}



protocol EasyWritingScreenDelegate: AnyObject {
    func expansionBtnTapped()
}



protocol CalendarDelegate: AnyObject {
    func selectDate(date: Date)
    func heightChanged(height: CGFloat)
}
