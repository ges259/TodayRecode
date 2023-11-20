//
//  SelectALoginMethodController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit
import SnapKit
import AuthenticationServices
//import CryptoKit

final class SelectALoginMethodController: UIViewController {
    
    // MARK: - 레이아웃
    // 앱 아이콘
    private lazy var iconImg: UIImageView = UIImageView(image: UIImage(named: "icon"))
    
    /// 애플 로그인 버튼
    private lazy var appleLogin: UIButton = UIButton.buttonWithTitle(
        title: "Apple로 로그인",
        font: UIFont.systemFont(ofSize: 16),
        backgroundColor: UIColor.white_Base)
    
    /// 구글 로그인 버튼
    private lazy var googleLogin: UIButton = UIButton.buttonWithTitle(
        title: "Google로 로그인",
        font: UIFont.systemFont(ofSize: 16),
        backgroundColor: UIColor.white_Base)
    
    /// 이메일 로그인 버튼
    private lazy var emailLogin: UIButton = UIButton.buttonWithTitle(
        title: "이메일로 로그인",
        font: UIFont.systemFont(ofSize: 16),
        backgroundColor: UIColor.white_Base)
    
    /// 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: self.buttonArray,
        axis: .vertical,
        spacing: 7,
        alignment: .fill,
        distribution: .fillEqually)
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    weak var delegate: AuthenticationDelegate?
    
    /// 버튼의 배열
    private lazy var buttonArray: [UIButton] = [self.appleLogin,
                                                self.googleLogin,
                                                self.emailLogin]
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureAutoLayoutAndUI() // 오토레이아웃 및 UI 설정
        self.configureAutoAction() // 액션 설정
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션바 없애기
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}










// MARK: - 화면 설정

extension SelectALoginMethodController {
    
    // MARK: - 오토레이아웃 및 UI 설정
    private func configureAutoLayoutAndUI() {
        // ********** addSubview 설정 **********
        self.view.addSubview(self.iconImg)
        self.view.addSubview(self.stackView)
        
        // ********** 오토레이아웃 설정 **********
        // 아이콘 설정
        self.iconImg.snp.makeConstraints { make in
            make.height.width.equalTo(240)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(160)
            make.centerX.equalToSuperview()
        }
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        // 버튼의 높이 설정 및 코너레디어스 설정
        self.buttonArray.forEach { btn in
            btn.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
            
            
            // ********** UI설정 **********
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 10
        }
        // 배경 색상 설정
        self.view.backgroundColor = UIColor.blue_Base
        // 네비게이션 타이틀 설정
        self.navigationItem.title = "로그인 선택"
    }
    
    
    
    // MARK: - 액션 설정
    private func configureAutoAction() {
        self.appleLogin.addTarget(self, action: #selector(self.appleLoginTapped), for: .touchUpInside)
        self.googleLogin.addTarget(self, action: #selector(self.googleLoginTapped), for: .touchUpInside)
        self.emailLogin.addTarget(self, action: #selector(self.emailLoginTapped), for: .touchUpInside)
    }
}
 









// MARK: - 액션
extension SelectALoginMethodController {
    @objc private func appleLoginTapped() {
        self.startSignInWithAppleFlow()
    }
    @objc private func googleLoginTapped() {
        
    }
    @objc private func emailLoginTapped() {
        let vc = LoginController()
        vc.delegate = self.delegate
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
