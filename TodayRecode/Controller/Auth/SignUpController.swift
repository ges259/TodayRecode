//
//  SignUpController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit

final class SignUpController: UIViewController {
    
    // MARK: - 레이아웃
    /// 배경뷰
    private lazy var backgroundImg: UIImageView = UIImageView(
        image: UIImage.blueSky)
    
    private lazy var containerView: UIView = UIView.backgroundView(
        color: UIColor.customWhite5)
    
    /// "회원가입" 레이블
    private lazy var signUpLbl: UILabel = UILabel.configureLbl(
        text: "회원가입",
        font: UIFont.boldSystemFont(ofSize: 20))
    
    /// 유저 이름 텍스트필드
    private lazy var userNameTF: UITextField = UITextField.configureAuthTextField(
        withPlaceholder: "이름을 입력하세요",
        keyboardType: .default)
    
    /// 이메일 텍스트필드
    private lazy var emailTF: UITextField = UITextField.configureAuthTextField(
        withPlaceholder: "이메일을 입력하세요",
        keyboardType: .emailAddress)
    
    /// 비밀번호 텍스트필드
    private lazy var passwordTF: UITextField = UITextField.configureAuthTextField(
        withPlaceholder: "비밀번호를 입력하세요",
        keyboardType: .default,
        isSecureTextEntry: true)
    
    /// 회원가입 버튼
    private lazy var signUpBtn: UIButton = UIButton.configureBtnWithTitle(
        title: "회원가입",
        font: UIFont.systemFont(ofSize: 20),
        backgroundColor: UIColor.customWhite5)
    
    /// 로그인 화면으로 이동 버튼
    private lazy var backToLoginViewBtn: UIButton = UIButton.configureBtnWithTitle(
        title: "아이디가 이미 있으신가요?",
        font: UIFont.systemFont(ofSize: 20),
        backgroundColor: UIColor.customWhite5)
    
    /// 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.signUpLbl,
                           self.userNameTF,
                           self.emailTF,
                           self.passwordTF,
                           self.signUpBtn,
                           self.backToLoginViewBtn],
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
extension SignUpController {
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
extension SignUpController {
    
}
