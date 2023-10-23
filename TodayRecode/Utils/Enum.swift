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
    
    var today: String {
        switch self {
        case .day_d: return "d"
        case .detaildayAndTime_Mdahm: return "M/d a h:m"
        case .monthAndDay_Mdd: return "M월 dd일"
        case .month_M: return "M월"
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
