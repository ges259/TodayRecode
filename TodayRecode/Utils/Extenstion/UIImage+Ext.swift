//
//  UIImage+Ext.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/21.
//

import UIKit

extension UIImage {
    /// 탭바 이미지
    static let recode: UIImage? = UIImage(systemName: "pencil.circle")
    static let recode_fill: UIImage? = UIImage(systemName: "pencil.circle.fill")
    static let setup: UIImage? = UIImage(systemName: "gearshape")
    static let setup_fill: UIImage? = UIImage(systemName: "gearshape.fill")
    
    
    /// 배경 이미지
    static let blueSky: UIImage? = UIImage(named: "blueSky")
    
    
    /// 버튼
    /// 확장 이미지 (간편 작성 화면 확장 버튼)
    static let expansion: UIImage? = UIImage(systemName: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left")
    /// 카메라 이미지
    static let camera: UIImage? = UIImage(systemName: "camera")
    /// 앨범 이미지
    static let album: UIImage? = UIImage(systemName: "photo")
    /// 체크 이미지 (간편 작성 화면 완료 버튼)
    static let check: UIImage? = UIImage(systemName: "checkmark")
    /// 더하기 이미지
    static let plus: UIImage? = UIImage(systemName: "plus")
    //
    static let circle_plus: UIImage? = UIImage(systemName: "plus.circle.fill")
    /// 키보드 내리기 이미지
    static let keyboardDown: UIImage? = UIImage(systemName: "chevron.down")
    /// 문서 확인 이미지 (오늘 기록 확인 버튼)
    static let recodeShow: UIImage? = UIImage(systemName: "doc.plaintext")
    /// 옵션 이미지
    static let option: UIImage? = UIImage(systemName: "ellipsis")
    /// x 이미지
    static let deleteBtn: UIImage? = UIImage(systemName: "xmark.circle.fill")
    /// 쓰레기통 이미지
    static let trash: UIImage? = UIImage(systemName: "trash")
    /// 시계 이미지
    static let clock: UIImage? = UIImage(systemName: "clock.fill")
    /// 달력 이미지
    static let calendar: UIImage? = UIImage(systemName: "calendar")
    /// 뒤로가기 이미지
    static let back: UIImage? = UIImage(systemName: "chevron.backward")
}
