//
//  UITextField+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/26.
//

import UIKit

extension UITextField {
    
    static func configureAuthTextField(withPlaceholder placeholder: String,
                   
                   keyboardType: UIKeyboardType,
                   isSecureTextEntry: Bool = false)
    // 당연히
//                   paddingLeftView: Bool? = false,
    -> UITextField {
        
        let tf = UITextField()
        
        // set keyboardType
        tf.keyboardType = keyboardType
        
        // set text color
        tf.textColor = UIColor.black
        
        // set font size
        tf.font = UIFont.systemFont(ofSize: 14)
        
        // set background color
        tf.backgroundColor = UIColor.customWhite5
        
        // set placeholder
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        // padding Left View
        tf.addPadding()
        
        // secureTextEntry
        tf.isSecureTextEntry = isSecureTextEntry
        
        tf.borderStyle = .none
        
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        
        tf.textContentType = .oneTimeCode
        
        return tf
    }
    
    func addPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
        
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
}
