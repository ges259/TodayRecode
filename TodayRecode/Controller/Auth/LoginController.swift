//
//  LoginController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit

final class LoginController: UIViewController {
    
    // MARK: - 레이아웃
    /// 배경뷰
    private lazy var backgroundImg: UIImageView = UIImageView(
        image: UIImage.blueSky)
    
    private lazy var containerView: UIView = UIView.backgroundView(
        color: UIColor.customWhite5)
    
    /// "로그인" 레이블
    private lazy var loginLbl: UILabel = UILabel.configureLbl(
        text: "로그인",
        font: UIFont.boldSystemFont(ofSize: 20))
    
    /// 이메일 텍스트필드
    private lazy var emailTF: UITextField = UITextField.configureAuthTextField(
        withPlaceholder: "이메일을 입력하세요",
        keyboardType: .emailAddress)
    
    /// 비밀번호 텍스트필드
    private lazy var passwordTF: UITextField = UITextField.configureAuthTextField(
        withPlaceholder: "비밀번호를 입력하세요",
        keyboardType: .default,
        isSecureTextEntry: true)
    
    /// 로그인 버튼
    private lazy var logInBtn: UIButton = UIButton.configureBtnWithTitle(
        title: "로그인",
        font: UIFont.systemFont(ofSize: 20),
        backgroundColor: UIColor.customWhite5)
    
    /// 회원가입 화면으로 이동 버튼
    private lazy var goToSignUpViewBtn: UIButton = UIButton.configureBtnWithTitle(
        title: "아이디가 없으신가요?",
        font: UIFont.systemFont(ofSize: 20),
        backgroundColor: UIColor.customWhite5)
    
    /// 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.loginLbl,
                           self.emailTF,
                           self.passwordTF,
                           self.logInBtn,
                           self.goToSignUpViewBtn],
        axis: .vertical,
        spacing: 4,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAutoAction()
    }
}










// MARK: - 화면 설정
extension LoginController {
    private func configureUI() {
        
    }
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        
        // ********** 오토레이아웃 설정 **********
        
        
    }
    private func configureAutoAction() {
        
    }
}










// MARK: - 액션
extension LoginController {
    
}
