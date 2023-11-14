//
//  Enum.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//
import UIKit

/// 날짜의 형식을 리턴하는 열거형
enum TodayFormatEnum {
    // 시간
    case a_hmm // PM 2:00
    case HHmm // 14:00
    // 날짜
    case h // 1시
    case d // 4일
    case M // 11월
    case yyyy // 2023
    case yyyy_MM_dd // 2023-11-4
    case yyyy_MM_dd_HH_dd_ss // 2023-11-04 01:05:05 +0000
    
    case d일
    case M월
    case M월d일
    case yyyy년
    case yyyy년M월
    
    
    // String 리턴
    var today: String {
        switch self {
        // 시간
        case .a_hmm: return "a h:mm"
        case .HHmm: return "HH:mm"
        // 날짜
        case .h: return "h"
        case .d: return "d"
        case .M: return "M"
        case .yyyy: return "yyyy"
        case .yyyy_MM_dd: return "yyyy-MM-dd"
        case .yyyy_MM_dd_HH_dd_ss: return "yyyy-MM-dd 00:00:00 +0000"
        
        case .d일: return "d일"
        case .M월: return "M월"
        case .M월d일: return "M월 d일"
        case .yyyy년: return "yyyy년"
        case .yyyy년M월: return "yyyy년 M월"
        }
    }
}



enum NavTitleSetEnum {
    case yyyy년M월
    case M월d일
    
    var first: String {
        switch self {
        case .yyyy년M월: return "yyyy년"
        case .M월d일: return "M월"
        }
    }
    var second: String {
        switch self {
        case .yyyy년M월: return " M월"
        case .M월d일: return " d일"
        }
    }
    
    var diary_String: String {
        return "하루 일기"
    }
    var record_String: String {
        return "하루 기록"
    }
}





enum NoDataEnum {
    case record_Main
    case record_Check
    case diary
    
    var lblString: String {
        switch self {
        case .record_Main: return "아직 작성한 기록이 없어요.\n +버튼을 눌러 오늘을 기록해보세요!"
        case .record_Check: return "오늘 작성한 기록이 없어요."
        case .diary: return "이번 달에 작성한 일기가 없어요"
        }
    }
    
    var systemImg: UIImage? {
        switch self {
        case .record_Main: return UIImage.noDataList
        case .record_Check: return UIImage.noDataList
        case .diary: return UIImage.calendar
        }
    }
    
}




/// 상세 작성 화면 및 간편 작성 화면,
/// 오른쪽 버튼을 설정하기 위한 열겨형
enum WritingScreenMode {
    case easyWritingScreen // 간편 작성 화면
    case detailWritingScreen // 상세 작성 화면
}

/// 상세 작성 화면 일기모드 / 기록모드 설정 열거형
enum DetailViewMode {
    case record_plusBtn // 기록 - 플러스버튼
    case record_CellTapped // 기록 - 셀 클릭
    case diary // 일기
    
    var api: String {
        switch self {
        case .record_plusBtn: return "record" // fallthrough 사용X
        case .record_CellTapped: return "record"
        case .diary: return "diary"
        }
    }
}

/// Enum에 따라 콜렉션뷰의 UI가 다름
enum CollectionViewEnum {
    case diaryList
    case photoList
}

/// 설정 화면에서 테이블뷰의 화면 구성
enum SettingTableEnum: Int {
    case dateFormat = 0
    case timeFormat = 1
    
    /// 셀에 표시될 텍스트
    var text: String {
        switch self {
        case .dateFormat: return "일주일 시작일"
        case .timeFormat: return "시간 형식"
        }
    }
    /// 셀에 표시될 시스템이미지
    var image: UIImage? {
        switch self {
        case .dateFormat: return UIImage.calendar
        case .timeFormat: return UIImage.clock
        }
    }
    
    /// 얼럿창을 띄우면 나올 텍스트 배열
    var alertStringArray: [String] {
        switch self {
        case .dateFormat:
            return ["일주일 시작일을 선택해주세요",
                    "일요일 시작",
                    "월요일 시작"]
        case .timeFormat:
            return ["날짜 형식을 선택해주세요",
                    "12시간 형식: PM 2:00",
                    "24시간 형식: 14:00"]
        }
    }
    
    var timeOption: String {
        switch Format.timeFormat_Static {
        case 0: return "12시간 형식: PM 2:00"
        case 1: return "24시간 형식: 14:00"
        default: return ""
        }
    }
    
    var dateOption: String {
        switch Format.dateFormat_Static {
        case 0: return "일요일 시작"
        case 1: return "월요일 시작"
        default: return ""
        }
    }
}





enum AuthEnum {
    case emailFormatError
    case password6Error
    case passwordIsNotSameError
    case unknownError
    case loginFail
    case signupFail
    
    var alert_StringArray: [String] {
        switch self {
        case .emailFormatError: return ["이메일 형식이 올바르지 않습니다.",
                                        "이메일을 다시 입력해 주세요"]
        case .password6Error: return ["비밀번호는 6자리 이상 입력해 주세요.",
                                      "비밀번호를 다시 입력해 주세요"]
        case .passwordIsNotSameError: return ["비밀번호가 일치하지 않습니다.",
                                         "비밀번호를 정확히 입력해 주세요."]
        case .unknownError: return ["알 수 없는 에러",
                                    "다시 시도해 주세요"]
        case .loginFail: return ["로그인에 실패하였습니다.",
                                 "아이디와 비밀번호를 정확히 입력해 주세요."]
        case .signupFail: return ["회원가입에 실패하였습니다.",
                                  "아이디와 비밀번호를 정확히 입력해 주세요."]
        }
    }
}
