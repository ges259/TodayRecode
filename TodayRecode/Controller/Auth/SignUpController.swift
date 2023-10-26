//
//  SignUpController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit
import SnapKit

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
        font: UIFont.boldSystemFont(ofSize: 30))
    
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
        backgroundColor: UIColor.customblue3)
    
    /// 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.signUpLbl,
                           self.userNameTF,
                           self.emailTF,
                           self.passwordTF,
                           self.signUpBtn],
        axis: .vertical,
        spacing: 7,
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
        self.navigationItem.title = "회원가입"
        self.stackView.setCustomSpacing(12, after: self.signUpLbl)
        
        [self.containerView,
         self.emailTF,
         self.userNameTF,
         self.passwordTF,
         self.signUpBtn].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
    }
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.view.addSubview(self.backgroundImg)
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.stackView)
        
        // ********** 오토레이아웃 설정 **********
        // 배경뷰
        self.backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 컨테이너뷰
        self.containerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        [self.emailTF,
         self.userNameTF,
         self.passwordTF,
         self.signUpBtn].forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(45)
            }
        }
        
    }
    private func configureAutoAction() {
        self.signUpBtn.addTarget(self, action: #selector(self.signUpBtnTapped), for: .touchUpInside)
    }
}










// MARK: - 액션
extension SignUpController {
    @objc private func signUpBtnTapped() {
        self.dismiss(animated: true)
    }
}
