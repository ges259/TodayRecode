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
        
        self.configureUI()
        self.configureTabBar()
    }
    
    
    
    // MARK: - 화면 설정
    /// 뷰의 배경, 탭바, 네비게이션 바 설정
    private func configureUI() {
        self.tabBar.tintColor = UIColor.blue.withAlphaComponent(0.3)
        self.tabBar.backgroundColor = UIColor.white
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 탭바 설정
    /// 탭바 설정
    private func configureTabBar() {
        // 오늘 날짜 가져오기
        let today = Date.todayReturnString(todayFormat: .d)
        
        // 기록 화면
        let recode = self.templateNavContoller(
            unselectedImg: UIImage.recode,
            selectedImg: UIImage.recode_fill,
            rootController: RecodeController())
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
    
    
    
    // MARK: - 탭바 이미지 설정
    /// 탭바의 이미지 및
    /// - Parameters:
    ///   - unselectedImg: 선택되지 않은 상태의 이미지
    ///   - selectedImg: 선택되었을 때 이미지
    ///   - rootController: 화면
    private func templateNavContoller(unselectedImg: UIImage?,
                                      selectedImg: UIImage?,
                                      rootController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootController)
//            nav.tabBarItem.image = UIImage(systemName: unselectedImg)
//            nav.tabBarItem.selectedImage = UIImage(systemName: selectedImg)
        nav.tabBarItem.image = unselectedImg
        nav.tabBarItem.selectedImage = selectedImg
        
//            nav.navigationBar.tintColor = UIColor.black
        return nav
    }
    
    
    
    
    
    
    
    // MARK: - API
    private func checkUser() {
        
    }
    
    
    
    
}
