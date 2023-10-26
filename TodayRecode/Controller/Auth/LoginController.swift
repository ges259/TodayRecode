//
//  LoginController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit
import SnapKit

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
        font: UIFont.boldSystemFont(ofSize: 30))
    
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
        backgroundColor: UIColor.customblue3)
    
    /// 회원가입 화면으로 이동 버튼
    private lazy var goToSignUpViewBtn: UIButton = {
        let btn = UIButton.configureBtnWithTitle(
            title: "아이디가 없으신가요?",
            font: UIFont.systemFont(ofSize: 12),
            backgroundColor: UIColor.clear)
        
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    /// 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.loginLbl,
                           self.emailTF,
                           self.passwordTF,
                           self.logInBtn],
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
extension LoginController {
    private func configureUI() {
        [self.containerView,
         self.emailTF,
         self.passwordTF,
         self.logInBtn].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
        self.navigationItem.title = "로그인"
        self.stackView.setCustomSpacing(12, after: self.loginLbl)
    }
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.view.addSubview(self.backgroundImg)
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.stackView)
        self.containerView.addSubview(self.goToSignUpViewBtn)
        
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
            
        }
        //
        self.goToSignUpViewBtn.snp.makeConstraints { make in
            make.top.equalTo(self.stackView.snp.bottom).offset(10)
            make.leading.equalTo(self.stackView).offset(10)
            make.trailing.equalTo(self.stackView).offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        [self.emailTF,
         self.passwordTF,
         self.logInBtn].forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(45)
            }
        }
    }
    private func configureAutoAction() {
        self.goToSignUpViewBtn.addTarget(self, action: #selector(self.goToSignUpView), for: .touchUpInside)
    }
}










// MARK: - 액션
extension LoginController {
    @objc private func goToSignUpView() {
        let vc = SignUpController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
