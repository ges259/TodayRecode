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
        case .record_Main: return "아직 작성한 기록이 없어요.\n +버튼을 눌러 오늘 하루를 기록해 보세요!"
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





enum ConfigurationBtnEnum {
    case logout
    case deleteAccount
    
    var btnTitle: String {
        switch self {
        case .logout: return "로그아웃"
        case .deleteAccount: return "회원탈퇴"
        }
    }
    
    var btnImage: UIImage? {
        switch self {
        case .logout: return UIImage.logout_Img
        case .deleteAccount: return UIImage.deleteAccount_Img
        }
    }
}

enum LoginMethod {
    case apple
    case email
    
    var description: String {
        switch self {
        case .apple: return "apple"
        case .email: return "email"
        }
    }
    var labelText: String {
        switch self {
        case .apple: return "•  애플 로그인은 다시 로그인하는 과정이 필요합니다."
        case .email: return "•  비밀번호를 정확히 입력해 주세요."
        }
    }
    var btnColor: UIColor? {
        switch self {
        case .apple: return UIColor.blue_Point
        case .email: return UIColor.blue_Lightly
        }
    }
}




// MARK: - 얼럿 텍스트
enum AlertEnum {
    // AuthSetting
    case albumAuth
    
    // Alert Caution
    case logout // 로그아웃
    case deletedAppleAccount // 회원탈퇴
    case deletedEmailAccount // 회원탈퇴
    case deleteRecord // 기록 삭제
    case limit5Image // 이미지 5개
    case timeFormat // 시간 형식
    case dateFormat // 날짜 형식
    
    // API Fail
    case fetchError
    case deleteError
    case updateError
    case createError
    case timeformatChangeFail
    case dateformatChangeFail
    
    // Revoke Token
    case deleteAccountFail
    case deleteAccountSuccess
    
    // Auth Fail
    case emailFormatError
    case password6Error
    case passwordIsNotSame
    case unknownError
    case loginFail
    case signupFail
    case logoutFail
    

    /// 얼럿창에 쓸 텍스트 배열
    var alert_StringArray: [String] {
        switch self {
        case .albumAuth: return ["설정",
                                 "'오늘 기록'이(가) 앨범 접근 허용되어 있지않습니다. \r\n 설정화면으로 가시겠습니까?",
                                 "확인",
                                 ""]
            
            // ********** Alert Caution **********
        case .logout: return ["정말 로그아웃 하시겠습니까?",
                              "",
                              "로그아웃",
                              ""]
        case .deletedAppleAccount: return ["다시 로그인을 하는 과정이 필요합니다.",
                                           "계속 진행하시겠습니까?",
                                           "회원 탈퇴",
                                           ""]
        case .deletedEmailAccount: return ["정말 회원을 탈퇴하시겠습니까?",
                                           "계정 및 모든 데이터가 삭제됩니다.",
                                           "회원 탈퇴",
                                           ""]
        case .deleteRecord: return ["정말 삭제하시겠습니까?",
                                    "",
                                    "삭제하기",
                                    ""]
        case .limit5Image: return ["이미지는 5개를 넘을 수 없습니다.",
                                   "",
                                   "",
                                   ""]
        case .timeFormat: return ["시간 형식을 선택해주세요",
                                  "",
                                  "12시간 형식: PM 2:00",
                                  "24시간 형식: 14:00"]
        case .dateFormat: return ["일주일 시작일을 선택해주세요",
                                  "",
                                  "일요일 시작",
                                  "월요일 시작"]
            
            
            // ********** API Fail **********
        case .fetchError: return ["데이터를 가져오는데 실패했습니다.",
                                  "",
                                  "",
                                  ""]
        case .deleteError: return ["데이터를 삭제하는데 실패했습니다.",
                                   "",
                                   "",
                                   ""]
        case .updateError: return ["데이터를 수정하는데 실패했습니다.",
                                   "",
                                   "",
                                   ""]
        case .createError: return ["데이터를 생성하는데 실패했습니다.",
                                   "",
                                   "",
                                   ""]
        case .timeformatChangeFail: return ["시간 형식을 변경하는데 실패했습니다.",
                                             "",
                                             "",
                                             ""]
        case .dateformatChangeFail: return ["날짜 형식을 변경하는데 실패했습니다.",
                                             "",
                                             "",
                                             ""]
            
            
            // ********** Revoke Token **********
        case .deleteAccountFail: return ["Apple 계정을 불러오지 못했습니다.",
                                         "잠시 후 다시 시도해 주세요",
                                         "",
                                         ""]
        case .deleteAccountSuccess: return ["회원 탈퇴에 성공하였습니다.",
                                            "",
                                            "",
                                            ""]
            
            
            
            // ********** Auth Fail **********
        case .emailFormatError: return ["이메일 형식이 올바르지 않습니다.",
                                        "이메일을 다시 입력해 주세요",
                                        "",
                                        ""]
        case .password6Error: return ["비밀번호를 6자리 이상 입력해 주세요.",
                                      "",
                                      "",
                                      ""]
        case .passwordIsNotSame: return ["이메일 또는 비밀번호가 일치하지 않습니다.",
                                         "정확하게 입력해 주세요.",
                                         "",
                                         ""]
        case .unknownError: return ["알 수 없는 에러",
                                    "다시 시도해 주세요",
                                    "",
                                    ""]
        case .loginFail: return ["로그인에 실패하였습니다.",
                                 "아이디와 비밀번호를 정확히 입력해 주세요.",
                                 "",
                                 ""]
        case .signupFail: return ["회원가입에 실패하였습니다.",
                                  "아이디와 비밀번호를 정확히 입력해 주세요.",
                                  "",
                                  ""]
        case .logoutFail: return ["로그아웃에 실패하였습니다.",
                                  "",
                                  "",
                                  ""]
        }
    }
}
