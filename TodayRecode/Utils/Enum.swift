//
//  Enum.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//
import UIKit

/// 시간의 형식을 리턴하는 열거형
enum TodayFormatEnum {
    case day_d
    case detaildayAndTime_Mdahm
    case monthAndDay_Mdd
    case month_M
    case yearAndMonth
    case year_yyyy
    
    var today: String {
        switch self {
        case .day_d: return "d"
        case .detaildayAndTime_Mdahm: return "M/d a h:m"
        case .monthAndDay_Mdd: return "M월 dd일"
        case .month_M: return "M월"
        case .yearAndMonth: return "yyyy년 M월"
        case .year_yyyy: return "yyyy년"
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
    case diary // 일기
    case recode // 기록
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
