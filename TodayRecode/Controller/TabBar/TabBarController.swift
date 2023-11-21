//
//  ViewController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 탭바 설정
        self.configureUI()
        self.configureTabBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 유저가 있는지 확인
        User_API.shared.checkUser
        ? self.fetchUser_API() // 있다면 -> 탭바 설정
        :self.goToSelectALoginController() // 없다면 -> 로그인 선택 창으로 이동
    }
}
    
    
    
    
    
// MARK: - 화면 설정

extension TabBarController {
    
    // MARK: - UI 설정
    /// 뷰의 배경, 탭바, 네비게이션 바 설정
    private func configureUI() {
        // 탭바 아이콘의 배경색
        self.tabBar.tintColor = UIColor.blue_Point
        // 탭바 배경 색
        self.tabBar.backgroundColor = UIColor.white
    }
    
    // MARK: - 탭바 설정
    /// 탭바 설정
    private func configureTabBar(user: User? = nil) {
        // 기록 화면
        let recode = self.templateNavContoller(
            unselectedImg: UIImage.recode,
            selectedImg: UIImage.recode_fill,
            rootController: RecordController())
        
        
        let today = Date.dateReturn_Custom(todayFormat: .d)
        // 일기 목록 화면
        // 오늘 날짜 가져오기 -> 오늘 날짜에 따라 탭바 이미지 다르게 설정
        let diaryList = self.templateNavContoller(
            unselectedImg: UIImage(systemName: "\(today).circle"),
            selectedImg: UIImage(systemName: "\(today).circle.fill"),
            rootController: DiaryListController())
        
        // 설정 화면
        let setting = self.templateNavContoller(
            unselectedImg: UIImage.setup,
            selectedImg: UIImage.setup_fill,
            rootController: SettingController())
        // 탭바 추가
        self.viewControllers = [recode, diaryList, setting]
    }
}
    
    
    
    
    
    




// MARK: - 액션
    
extension TabBarController {
    
    // MARK: - 탭바 이미지 설정 액션
    /// 탭바의 이미지 및
    /// - Parameters:
    ///   - unselectedImg: 선택되지 않은 상태의 이미지
    ///   - selectedImg: 선택되었을 때 이미지
    ///   - rootController: 화면
    private func templateNavContoller(
        unselectedImg: UIImage?,
        selectedImg: UIImage?,
        rootController: UIViewController)
    -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootController)
        // 선택되지 않았을 때 이미지 설정
        nav.tabBarItem.image = unselectedImg
        // 선택되었을 때 이미지 설정
        nav.tabBarItem.selectedImage = selectedImg
        return nav
    }
    
    // MARK: - 로그인 선택창 이동 액션
    private func goToSelectALoginController() {
        DispatchQueue.main.async {
            // 유저가 없다면 -> 로그인 선택 화면으로 이동
            let controller = SelectALoginMethodController()
            // 델리게이트 설정
            controller.delegate = self
            let vc = UINavigationController(rootViewController: controller)
            vc.modalPresentationStyle = .fullScreen
            // 화면 이동
            self.present(vc, animated: false)
        }
    }
}
    
    
    
    
    
    
    
    


// MARK: - API

extension TabBarController {
    
    // MARK: - 유저정보 가져오기 _ API
    private func fetchUser_API() {
        // 유저가 있는지 확인
        User_API
            .shared
            .fetchUser { result in
            switch result {
                // 유저가 있다면
            case .success(let user):
                // user데이터 저장 -> 설정 화면에서 user데이터 사용
                UserData.user = user
                break
                
            case .failure(_):
                // 로그인 선택 창으로 이동
                self.goToSelectALoginController()
                break
            }
        }
    }
}










// MARK: - Auth 델리게이트

extension TabBarController: AuthenticationDelegate {
    
    // MARK: - 로그인 성공 시
    func authenticationComplete() {
        // 로그인 시
        // user데이터 가져오기
        self.fetchUser_API()
        
        
        // 기록 화면이 보이도록 설정
        self.selectedIndex = 0
        // 뒤로가기 (기록 화면으로 이동)
        self.dismiss(animated: true)
        // 로그인했다는 표시 -> RecordController에서 fetch진행
        DataUpdate.login = true
    }
}
