//
//  ViewController+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit

enum TodayFormatEnum {
    case today
    case detaildayAndTime
    
    var today: String {
        switch self {
        case .today: return "d"
        case .detaildayAndTime: return "M/d a h:m"
        }
    }
}

extension UIViewController {
    func todayReturn(todayFormat: TodayFormatEnum) -> String {
        let formatter = DateFormatter()
            formatter.dateFormat = todayFormat.today
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



extension UITextView {
    static func configureTV(fontSize: CGFloat) -> UITextView {
        let tv = UITextView()
        
        // 기본 설정
        tv.autocorrectionType = .no
        tv.autocorrectionType = .no
        tv.smartDashesType = .no
        tv.smartQuotesType =  .no
        tv.smartInsertDeleteType = .no
        tv.keyboardType = .default
        tv.returnKeyType = .done
        
        tv.sizeToFit()
        
        // 폰트 크기
        tv.font = UIFont.systemFont(ofSize: fontSize)
        return tv
    }
}


enum imageEnum {
    case expansion
    case camera
    case album
    case send
    
    var imageString: String {
        switch self {
        case .expansion: return "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left"
        case .camera: return "camera"
        case .album: return "photo"
        case .send: return "checkmark"
        }
        
    }
}


extension UIButton {
    static func configureBtn(image: imageEnum,
                             tintColor: UIColor,
                             backgroundColor: UIColor? = UIColor.clear)
    -> UIButton {
        let btn = UIButton(type: .system)
            btn.setImage(UIImage(systemName: image.imageString), for: .normal)
            btn.tintColor = tintColor
        
            btn.backgroundColor = backgroundColor

        return btn
    }
}



extension UILabel {
    static func configureLbl(text: String? = nil,
                             font: UIFont,
                             textColor: UIColor)
    -> UILabel {
        
        let lbl = UILabel()
            lbl.text = text
            lbl.font = font
            lbl.textColor = textColor
        return lbl
    }
    
    
}
