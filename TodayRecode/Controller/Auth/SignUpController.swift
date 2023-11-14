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
    private lazy var signUpBtn: UIButton = {
        let btn = UIButton.buttonWithTitle(
            title: "회원가입",
            titleColor: UIColor.white,
            font: UIFont.systemFont(ofSize: 20),
            backgroundColor: UIColor.customblue3)
            btn.isEnabled = false
        return btn
    }()
    
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
    
    /// 네비게이션 타이틀 레이블
    private lazy var navTitle: UILabel = UILabel.navTitleLbl()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    /// 델리게이트
    weak var delegate: AuthenticationDelegate?
    /// 모든 텍스트필드에 텍스트가 있는지 확인
    private var textfieldHasText: Bool {
        return self.userNameTF.hasText
        && self.emailTF.hasText
        && self.passwordTF.hasText
        && self.passwordCheckTF.hasText
    }
    
    
    
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
        self.formValidation()
    }
}










// MARK: - 화면 설정

extension SignUpController {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.view.backgroundColor = UIColor.blue_base
        // 네비게이션 타이틀뷰(View) 설정
        self.navigationItem.titleView = self.navTitle
        self.navTitle.text = "설정"
        
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
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.stackView)
        
        // ********** 오토레이아웃 설정 **********
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










// MARK: - 셀렉터

extension SignUpController {
    
    // MARK: - 회원가입 버튼 액션
    @objc private func signUpBtnTapped() {
        self.signUpBtn.isEnabled = false
        // 모든 텍스트필드에 텍스트가 있는지 확인
        if self.checkEmail()
            && self.checkPassword6words()
            && self.checkPasswordIsSame() {
            self.signup()
        } else {
            self.alert_SignupFail(signupEnum: .signupFail)
        }
    }
    
    // MARK: - 텍스트필드 액션
    @objc private func formValidation() {
        // 모든 텍스트필드에 텍스트가 있는지 확인
        if self.textfieldHasText {
            // 텍스트필드가 빈칸이 없을 때
            self.signUpBtn.isEnabled = true
            self.signUpBtn.backgroundColor = .customblue6
            return
        }
        // 텍스트필드에 빈칸이 있을 때
        self.signUpBtn.isEnabled = false
        self.signUpBtn.backgroundColor = .customblue3
    }
}










// MARK: - 액션

extension SignUpController {
    
    // MARK: - 회원가입 조건
    /// 이메일 텍스트필드가 이메일 형식이 맞는지 확인하는 메서드
    private func checkEmail() -> Bool {
        // 이메일 형식인지
        if self.isValidEmail(testStr: self.emailTF.text) {
            return true
        }
        self.alert_SignupFail(signupEnum: .emailFormatError)
        return false
    }
    /// 비밀번호가 6자리인지 확인하는 메서드
    private func checkPassword6words() -> Bool {
        if self.isValidPassword(pw: self.passwordTF.text) &&
            self.isValidPassword(pw: self.passwordCheckTF.text){
            return true
        }
        self.alert_SignupFail(signupEnum: .password6Error)
        return false
    }
    /// 비밀번호TF와 비밀번호 확인TF 가 같은지 확인하는 메서드
    private func checkPasswordIsSame() -> Bool {
        if self.passwordTF.text == self.passwordCheckTF.text {
            return true
        }
        self.alert_SignupFail(signupEnum: .passwordIsNotSameError)
        return false
    }
    
    
    
    
    // MARK: - 얼럿창 띄우기
    private func alert_SignupFail(signupEnum: AuthEnum) {
        let stringArray = signupEnum.alert_StringArray
        // 커스텀 얼럿창 띄우기
        self.customAlert(
            alertStyle: .alert,
            withTitle: stringArray[0],
            message: stringArray[1]) { _ in
                self.signUpBtn.isEnabled = true
                return
            }
    }
}










// MARK: - API
extension SignUpController {
    private func signup(){
        // 닉네임/아이디/비밀번호 옵셔널 바인딩
        guard let userName = self.userNameTF.text,
              let email = self.emailTF.text,
              let password = self.passwordTF.text
        else { return }
        
        // 회원가입
        Auth_API.shared.signUp(
            userName: userName,
            email: email,
            password: password) { result in
                switch result {
                case .success(_):
                    // 뒤로가기
//                    self.dismiss(animated: true)
                    self.delegate?.authenticationComplete()
                    
                case .failure(_):
                    self.alert_SignupFail(signupEnum: .unknownError)
                    break
                }
            }
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
