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
    
    func yearAndMonthReturn(date: Date) -> [String] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = TodayFormatEnum.year_yyyy.today
        let year = formatter.string(from: date)
        
        formatter.dateFormat = TodayFormatEnum.month_M.today
        let month = formatter.string(from: date)
        
        return [year, month]
    }
}
