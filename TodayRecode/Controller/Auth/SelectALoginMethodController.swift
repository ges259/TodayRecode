//
//  SelectALoginMethodController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit
import SnapKit

final class SelectALoginMethodController: UIViewController {
    
    // MARK: - 레이아웃
    /// 배경뷰
    private lazy var backgroundImg: UIImageView = UIImageView(
        image: UIImage.blueSky)
    
    /// 애플 로그인 버튼
    private lazy var appleLogin: UIButton = UIButton.configureBtnWithTitle(
        title: "Apple로 로그인",
        font: UIFont.systemFont(ofSize: 20),
        backgroundColor: UIColor.customWhite5)
    
    /// 구글 로그인 버튼
    private lazy var googleLogin: UIButton = UIButton.configureBtnWithTitle(
        title: "Google로 로그인",
        font: UIFont.systemFont(ofSize: 20),
        backgroundColor: UIColor.customWhite5)
    
    /// 이메일 로그인 버튼
    private lazy var emailLogin: UIButton = UIButton.configureBtnWithTitle(
        title: "이메일로 로그인",
        font: UIFont.systemFont(ofSize: 20),
        backgroundColor: UIColor.customWhite5)
    
    /// 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.appleLogin,
                           self.googleLogin,
                           self.emailLogin],
        axis: .vertical,
        spacing: 7,
        alignment: .fill,
        distribution: .fillEqually)
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUIAndAutoLayout()
        self.configureAutoAction()
    }
}










// MARK: - 화면 설정
extension SelectALoginMethodController {
    private func configureUIAndAutoLayout() {
        // ********** addSubview 설정 **********
        self.view.addSubview(self.backgroundImg)
        self.view.addSubview(self.stackView)
        
        // ********** 오토레이아웃 설정 **********
        self.backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(100)
        }
        // 버튼의 높이 설정 및 코너레디어스 설정
        [self.appleLogin,
         self.googleLogin,
         self.emailLogin].forEach { btn in
            btn.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 10
        }
    }
    
    
    
    private func configureAutoAction() {
        self.appleLogin.addTarget(self, action: #selector(self.appleLoginTapped), for: .touchUpInside)
        self.googleLogin.addTarget(self, action: #selector(self.googleLoginTapped), for: .touchUpInside)
        self.emailLogin.addTarget(self, action: #selector(self.emailLoginTapped), for: .touchUpInside)
    }
}










// MARK: - 액션
extension SelectALoginMethodController {
    @objc private func appleLoginTapped() {
        print(#function)
    }
    @objc private func googleLoginTapped() {
        print(#function)
    }
    @objc private func emailLoginTapped() {
        print(#function)
    }
}
