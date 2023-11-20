//
//  UIButton+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//

import UIKit

extension UIButton {
    /// 이미지가 들어간 버튼 설정
    static func buttonWithImage(image: UIImage?,
                                tintColor: UIColor = .black,
                                backgroundColor: UIColor? = UIColor.clear)
    -> UIButton {
        let btn = UIButton(type: .system)
            btn.setImage(image, for: .normal)
            btn.tintColor = tintColor
        
            btn.backgroundColor = backgroundColor

        return btn
    }
    /// 글자가 들어간 버튼 설정
    static func buttonWithTitle(title: String,
                                titleColor: UIColor = UIColor.black,
                                font: UIFont,
                                backgroundColor: UIColor)
    -> UIButton {
        let btn = UIButton(type: .system)
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = font
            btn.backgroundColor = backgroundColor
            btn.setTitleColor(titleColor, for: .normal)
        return btn
    }
    
    static func buttonWithImgAndTitle(_ buttonEnum: ConfigurationBtnEnum) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        
        // 타이틀 설정
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 13)
        configuration.attributedTitle = AttributedString(
            buttonEnum.btnTitle,
            attributes: titleContainer)
        
        // 이미지 설정
        configuration.image = buttonEnum.btnImage
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        configuration.imagePadding = 10
        // 이미지가 상단에 위치한 버튼
        configuration.imagePlacement = .top
        
        // 버튼 설정
        let btn = UIButton(configuration: configuration)
        btn.tintColor = UIColor.black
        btn.backgroundColor = UIColor.white_Base
        
        // 리턴
        return btn
    }
}
