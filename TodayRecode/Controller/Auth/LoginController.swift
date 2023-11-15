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
    private lazy var containerView: UIView = UIView.backgroundView(
        color: UIColor.customWhite5)
    
    /// "로그인" 레이블
    private lazy var loginLbl: UILabel = UILabel.configureLbl(
        text: "이메일 로그인",
        font: UIFont.boldSystemFont(ofSize: 25))
    
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
        tf.returnKeyType = .done
        return tf
    }()
    
    /// 로그인 버튼
    private lazy var logInBtn: UIButton = {
        let btn = UIButton.buttonWithTitle(
            title: "로그인",
            titleColor: UIColor.white,
            font: UIFont.boldSystemFont(ofSize: 20),
            backgroundColor: UIColor.customblue1)
            btn.isEnabled = false
        return btn
    }()
    
    /// 회원가입 화면으로 이동 버튼
    private lazy var goToSignUpViewBtn: UIButton = {
        let btn = UIButton.buttonWithTitle(
            title: "아이디가 없으신가요?",
            font: UIFont.systemFont(ofSize: 13),
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
    
    
    /// 네비게이션 타이틀 레이블
    private lazy var navTitle: UILabel = UILabel.navTitleLbl()
    
    
    
    // MARK: - 프로퍼티
    weak var delegate: AuthenticationDelegate? 
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션바 보이게하기
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 모든 키보드 내리기
        self.view.endEditing(true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 뷰가 사라지면 텍스트필드의 텍스트를 모드 없앰
        self.emailTF.text = nil
        self.passwordTF.text = nil
        self.formValidation()
    }
}










// MARK: - 화면 설정

extension LoginController {
    
    // MARK: - UI 설정
    private func configureUI() {
        // 배경 색상 설정
        self.view.backgroundColor = UIColor.blue_base
        // 네비게이션 타이틀뷰(View) 설정
        self.navigationItem.titleView = self.navTitle
        self.navTitle.text = "이메일 로그인"
        // '아이디가 없으신가요?' 버튼 <- 스택뷰 간격 넓히기
        self.stackView.setCustomSpacing(15, after: self.loginLbl)
        
        [self.containerView,
         self.emailTF,
         self.passwordTF,
         self.logInBtn].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.stackView)
        self.containerView.addSubview(self.goToSignUpViewBtn)
        
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
        }
        //
        self.goToSignUpViewBtn.snp.makeConstraints { make in
            make.top.equalTo(self.stackView.snp.bottom).offset(10)
            make.leading.equalTo(self.stackView).offset(10)
            make.trailing.equalTo(self.stackView).offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        // 텍스트필드 높이 설정
        [self.emailTF,
         self.passwordTF,
         self.logInBtn].forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(45)
            }
        }
    }
    
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.logInBtn.addTarget(self, action: #selector(self.logInBtnTapped), for: .touchUpInside)
        self.goToSignUpViewBtn.addTarget(self, action: #selector(self.goToSignUpView), for: .touchUpInside)
        
        [self.emailTF,
         self.passwordTF].forEach { tf in
            tf.addTarget(self, action: #selector(self.formValidation), for: .editingChanged)
        }
    }
}










// MARK: - 셀렉터

extension LoginController {
    
    // MARK: - 로그인 버튼 액션
    @objc private func logInBtnTapped() {
        self.logInBtn.isEnabled = false

        if self.checkEmailFormat()
            && self.checkpassword6words() {
            self.login()
        } else {
            self.alert_LoginFail(authEnum: .loginFail)
        }
    }
    
    
    
    // MARK: - 텍스트필드 액션
    @objc private func formValidation() {
        if self.emailTF.hasText
            && self.passwordTF.hasText {
            // 텍스트필드가 모두 채워지면
            self.logInBtn.isEnabled = true
            self.logInBtn.backgroundColor = UIColor.blue_Point
            return
        }
        // 텍스트필드에 빈칸이 있을 때
        self.logInBtn.isEnabled = false
        self.logInBtn.backgroundColor = UIColor.customblue1
    }
    
    
    
    // MARK: - 회원가입 화면 이동 액션
    @objc private func goToSignUpView() {
        let vc = SignUpController()
        vc.delegate = self.delegate
        self.navigationController?.pushViewController(vc, animated: true)
    }
}










// MARK: - 액션

extension LoginController {
    
    // MARK: - 로그인 조건
    private func checkEmailFormat() -> Bool {
        // 로그인 형식이 맞는지 확인
        if self.isValidEmail(testStr: self.emailTF.text) {
            return true
        }
        self.alert_LoginFail(authEnum: .emailFormatError)
        return false
    }
    private func checkpassword6words() -> Bool {
        // 비밀번호가 6자리 이상인지 확인
        if self.isValidPassword(pw: self.passwordTF.text) {
            return true
        }
        self.alert_LoginFail(authEnum: .password6Error)
        return false
    }
    
    // MARK: - 얼럿창 띄우기
    private func alert_LoginFail(authEnum: AuthEnum) {
        let stringArray = authEnum.alert_StringArray
        // 커스텀 얼럿창 띄우기
        self.customAlert(
            alertStyle: .alert,
            withTitle: stringArray[0],
            message: stringArray[1]) { _ in
                self.logInBtn.isEnabled = true
                return
            }
    }
}










// MARK: - 로그인
extension LoginController {
    private func login() {
        
        guard let email = self.emailTF.text,
              let password = self.passwordTF.text
        else { return }
        
        Auth_API.shared.login(
            email: email,
            password: password) { result in
                switch result {
                    // 로그인에 성공했다면
                case .success():
                    self.delegate?.authenticationComplete()
                    
                    // 로그인에 실패했다면
                case .failure(_):
                    // 커스텀 얼럿창 띄우기
                    self.alert_LoginFail(authEnum: .unknownError)
                }
        }
    }
}










// MARK: - 텍스트필드 델리게이트
extension LoginController: UITextFieldDelegate {
    /// 텍스트필드 엔터키를 누르면 호출 되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTF {
            self.passwordTF.becomeFirstResponder()
        } else {
            self.logInBtnTapped()
        }
        return true
    }
}
