//
//  ViewController+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit

extension UIViewController {
    func todayReturn() -> String {
        let formatter = DateFormatter()
            formatter.dateFormat = "d"
        return formatter.string(from: Date())
    }
}

extension UIView {
    func backgroundView(color: UIColor) -> UIView {
        let view = UIView()
            view.backgroundColor = color
        return view
    }
}
