//
//  Enum.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//
import UIKit

/// 시간의 형식을 리턴하는 열거형
enum TodayFormatEnum {
    case d
    case M_d
    case M
    
    case yyyy_M
    case h
    case yyyy_MM_dd_HH_dd_ss
    
    case yyyy
    case yyyy_MM_dd
    // PM 2:00
    case a_hmm
    // 14:00
    case Hmm
    
    case api_yyyy_M
    
    var today: String {
        switch self {
            // 날짜
        case .d: return "d"
        case .M_d: return "M월 d일"
        case .M: return "M월"
        case .yyyy: return "yyyy년"
        case .yyyy_M: return "yyyy년 M월"
        case .yyyy_MM_dd: return "yyyy-MM-dd"
        case .h: return "h"
        case .yyyy_MM_dd_HH_dd_ss: return "yyyy-MM-dd 00:00:00 +0000"
            
            // 시간
        case .a_hmm: return "a h:mm"
        case .Hmm: return "H:mm"
            
        case .api_yyyy_M: return "yyyyM"
        }
    }
}



/// 상세 작성 화면 및 간편 작성 화면,
/// 오른쪽 버튼을 설정하기 위한 열겨형
enum AccessoryViewMode {
    case easyWritingScreen // 간편 작성 화면
    case detailWritingScreen // 상세 작성 화면
}






/// 상세 작성 화면 쓰기모드 / 저장모드 설정 열거형
enum DetailEditMode {
    case writingMode // 쓰기 모드
    case saveMode // 저장 모드
}
/// 상세 작성 화면 일기모드 / 기록모드 설정 열거형
enum DetailViewMode {
    case record_plusBtn
    case record // 기록
    case diary // 일기
}






enum CollectionViewEnum {
    case diaryList
    case photoList
}





enum SettingTableEnum: Int {
    case dateFormat = 0
    case timeFormat = 1
    
    var image: UIImage? {
        switch self {
        case .dateFormat: return UIImage.calendar
        case .timeFormat: return UIImage.clock
        }
    }
    
    var alertTitle: String {
        switch self {
        case .dateFormat: return "일주일 시작일을 선택해주세요"
        case .timeFormat: return "날짜 형식을 선택해주세요"
        }
    }
    
    var text: String {
        switch self {
        case .dateFormat: return "일주일 시작일"
        case .timeFormat: return "시간 형식"
        }
    }
    
    var firstOption: String {
        switch self {
        case .dateFormat: return "일요일 시작"
        case .timeFormat: return "12시간 형식: PM 2:00"
        }
    }
    
    var secondOption: String {
        switch self {
        case .dateFormat: return "월요일 시작"
        case .timeFormat: return "24시간 형식: 14:00"
        }
    }
}
