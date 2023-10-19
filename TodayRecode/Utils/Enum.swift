//
//  Enum.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//

/// 시간의 형식을 리턴하는 열거형
enum TodayFormatEnum {
    case day_d
    case detaildayAndTime_Mdahm
    case monthAndDay_Mdd
    
    var today: String {
        switch self {
        case .day_d: return "d"
        case .detaildayAndTime_Mdahm: return "M/d a h:m"
        case .monthAndDay_Mdd: return "M월 dd일"
        }
    }
}
/// 이미지의 String값을 리턴하는 열거형
enum ImageEnum {
    case expansion
    case camera
    case album
    case send
    case blueSky
    case plus
    case keyboardDown
    case recodeShow
    
    var imageString: String {
        switch self {
        case .expansion: return "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left"
        case .camera: return "camera"
        case .album: return "photo"
        case .send: return "checkmark"
        case .blueSky: return "blueSky"
        case .plus: return "plus"
        case .keyboardDown: return "chevron.down"
        case .recodeShow: return "doc.plaintext"
        }
    }
}


enum WritingScreenEnum {
    case easyWritingScreen
    case detailWritingScreen
}
