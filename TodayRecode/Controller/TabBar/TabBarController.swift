//
//  ViewController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - 유저가 있는지 확인
    private var checkUser: () {
        // user가 있는지 없는지 확인
        return User_API.shared.checkUser
        // 있다면 -> 탭바 설정
        ? self.configureTabBar()
        // 없다면 -> 로그인 선택 창으로 이동
        : self.goToSelectALoginController()
    }
    
    
    
    
    // 스플래시 화면
    // 얼럿창 취소 버튼
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        // 로그인이 되어있는 상태인지 확인
        self.checkUser
        // 탭바 설정
        self.configureUI()
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 화면 설정
    /// 뷰의 배경, 탭바, 네비게이션 바 설정
    private func configureUI() {
        self.tabBar.tintColor = UIColor.blue_tab
        
        self.tabBar.backgroundColor = UIColor.white
        
        self.tabBar.isTranslucent = false
    }
    
    // MARK: - 탭바 설정
    /// 탭바 설정
    private func configureTabBar(user: User? = nil) {
        // 탭바 컨틀롤러 설정
        // 오늘 날짜 가져오기
        let today = Date.dateReturn_Custom(todayFormat: .d)
        // 기록 화면
        let recode = self.templateNavContoller(
            unselectedImg: UIImage.recode,
            selectedImg: UIImage.recode_fill,
            rootController: RecordController())
        // 일기 목록 화면
            // 오늘 날짜에 따라 탭바 이미지 다르게 설정
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
        nav.tabBarItem.image = unselectedImg
        nav.tabBarItem.selectedImage = selectedImg
        return nav
    }
    
    
    
    
    
    

    
    
    
    // MARK: - 로그인 선택창 이동 액션
    private func goToSelectALoginController() {
        DispatchQueue.main.async {
            // 유저가 없다면 -> 로그인 선택 화면으로 이동
            let controller = SelectALoginMethodController()
            controller.delegate = self
            let vc = UINavigationController(rootViewController: controller)
                vc.modalPresentationStyle = .fullScreen
            
            self.present(vc, animated: false)
        }
    }
}










extension TabBarController: AuthenticationDelegate {
    func authenticationComplete() {
        self.dismiss(animated: true)
        self.configureTabBar()
    }
}
