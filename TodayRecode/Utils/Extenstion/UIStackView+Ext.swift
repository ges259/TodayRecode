//
//  UIStackView+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/19.
//

import UIKit

extension UIStackView {
    static func configureStackView(arrangedSubviews: [UIView],
                            axis: NSLayoutConstraint.Axis,
                            spacing: CGFloat,
                            alignment: UIStackView.Alignment,
                            distribution: UIStackView.Distribution)
    -> UIStackView {
        let stv = UIStackView(arrangedSubviews: arrangedSubviews)
            stv.axis = axis
            stv.distribution = distribution
            stv.spacing = spacing
            stv.alignment = alignment
        return stv
    }
}
