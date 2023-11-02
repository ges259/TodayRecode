//
//  SignUpController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit
import SnapKit
import FirebaseAuth

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
        font: UIFont.boldSystemFont(ofSize: 25))
    
    /// 유저 이름 텍스트필드
    private lazy var userNameTF: UITextField = {
        let tf = UITextField.authTextField(
            withPlaceholder: "이름을 입력하세요",
            keyboardType: .default)
        tf.delegate = self
        return tf
    }()
    
    /// 이메일 텍스트필드
    private lazy var emailTF: UITextField = {
        let tf = UITextField.authTextField(
            withPlaceholder: "이메일을 입력하세요",
            keyboardType: .emailAddress)
        tf.delegate = self
        return tf
    }()
    
    /// 비밀번호 텍스트필드
    private lazy var passwordTF: UITextField = {
        let tf = UITextField.authTextField(
            withPlaceholder: "비밀번호를 입력하세요",
            keyboardType: .default,
            isSecureTextEntry: true)
        tf.delegate = self
        return tf
    }()
    /// 비밀번호 텍스트필드
    private lazy var passwordCheckTF: UITextField = {
        let tf = UITextField.authTextField(
            withPlaceholder: "비밀번호를 다시 입력해 주세요",
            keyboardType: .default,
            isSecureTextEntry: true)
        tf.delegate = self
        return tf
    }()
    
    /// 회원가입 버튼
    private lazy var signUpBtn: UIButton = UIButton.buttonWithTitle(
        title: "회원가입",
        font: UIFont.systemFont(ofSize: 20),
        backgroundColor: UIColor.customblue3)
    
    /// 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.signUpLbl,
                           self.userNameTF,
                           self.emailTF,
                           self.passwordTF,
                           self.passwordCheckTF,
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
        self.configureAction()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 뷰가 사라지면 텍스트필드의 텍스트를 모드 없앰
        [self.userNameTF,
         self.emailTF,
         self.passwordTF,
         self.passwordCheckTF].forEach { tf in
            tf.text = nil
        }
    }
}










// MARK: - 화면 설정

extension SignUpController {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.navigationItem.title = "회원가입"
        self.stackView.setCustomSpacing(15, after: self.signUpLbl)
        
        [self.containerView,
         self.emailTF,
         self.userNameTF,
         self.passwordTF,
         self.passwordCheckTF,
         self.signUpBtn].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
    }
    
    
    
    // MARK: - 오토레이아웃 설정
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
        // 텍스트필드 높이 설정
        [self.emailTF,
         self.userNameTF,
         self.passwordTF,
         self.passwordCheckTF,
         self.signUpBtn].forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(45)
            }
        }
    }
    
    
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.signUpBtn.addTarget(self, action: #selector(self.signUpBtnTapped), for: .touchUpInside)
        
        
        [self.userNameTF,
         self.emailTF,
         self.passwordTF,
         self.passwordCheckTF].forEach { tf in
            tf.addTarget(self, action: #selector(self.formValidation), for: .editingChanged)
        }
    }
}










// MARK: - 액션

extension SignUpController {
    
    // MARK: - 회원가입 버튼 액션
    @objc private func signUpBtnTapped() {
        self.signUpBtn.isEnabled = false
        
        // 비밀번호 텍스트필드와 - 비밀번호 확인 텍스트필드가 다르면 얼럿창 띄우기
        if self.passwordTF.text != self.passwordCheckTF.text {
            // 커스텀 얼럿창 띄우기
            self.customAlert(
                alertStyle: .alert,
                withTitle: "비밀번호가 일치하지 않습니다.",
                message: "다시 입력해 주세요.") { _ in
                    print("비밀번호 불일치")
                    return
                }
        }
        
        // 닉네임/아이디/비밀번호 옵셔널 바인딩
        guard let userName = self.userNameTF.text,
              let email = self.emailTF.text,
              let password = self.passwordTF.text
        else { return }
        
        // 회원가입
        Auth_API.shared.signUp(
            userName: userName,
            email: email,
            password: password) {
                self.signUpBtn.isEnabled = true
                // 뒤로가기
                self.dismiss(animated: true)
            }
    }
    
    
    
    // MARK: - 텍스트필드 액션
    @objc private func formValidation() {
        // 모든 텍스트필드에 텍스트가 있는지 확인
        guard self.userNameTF.hasText,
              self.emailTF.hasText,
              self.passwordTF.hasText,
              self.passwordCheckTF.hasText
        else {
            // 텍스트필드에 빈칸이 있을 때
            self.signUpBtn.isEnabled = false
            self.signUpBtn.backgroundColor = .customblue3
            return
        }
        // 텍스트필드가 빈칸이 없을 때
        self.signUpBtn.isEnabled = true
        self.signUpBtn.backgroundColor = .customblue6
    }
}










// MARK: - 텍스트필드 델리게이트
extension SignUpController: UITextFieldDelegate {
    /// 텍스트필드 엔터키를 누르면 호출 되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.userNameTF {
            self.emailTF.becomeFirstResponder()
        } else if textField == self.emailTF {
            self.passwordTF.becomeFirstResponder()
        } else if textField == self.passwordTF {
            self.passwordCheckTF.becomeFirstResponder()
        } else {
            self.signUpBtnTapped()
        }
        return true
    }
}
