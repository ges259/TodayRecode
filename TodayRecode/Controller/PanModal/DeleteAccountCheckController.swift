//
//  DeleteAccountCheckView.swift
//  TodayRecord
//
//  Created by 계은성 on 2023/11/21.
//

import UIKit
import SnapKit
import PanModal

final class DeleteAccountCheckController: UIViewController {
    
    // MARK: - 레이아웃
    /// X버튼
    private lazy var dismissBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.deleteBtn,
        tintColor: .black)
    
    /// 타이틀 레이블
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textColor = .black
        lbl.attributedText =  self.customAttributedTitle(
            firstTitle: "정말 계정을 삭제할까요?\n",
            firstFont: UIFont.boldSystemFont(ofSize: 25),
            secondTitle: "삭제 전 아래의 주의사항을 읽어주세요!",
            secondFont: UIFont.systemFont(ofSize: 14),
            setSpacing: 9)
        return lbl
    }()
    
    /// 구분 선 뷰
    private lazy var separatorView: UIView = UIView.backgroundView(
        color: UIColor.lightGray)
    
    /// 설명 뷰1
    private lazy var guideLabel: UILabel = {
        let lbl = UILabel.configureLbl(
            text: self.currentMode?.labelText,
            font: UIFont.systemFont(ofSize: 14),
            textColor: UIColor.red)
        lbl.numberOfLines = 3
        return lbl
    }()
    
    /// 비밀번호 텍스트필드
    private lazy var passwordCheckTF: UITextField = {
        let tf = UITextField.authTextField(
            withPlaceholder: "비밀번호를 입력해 주세요",
            keyboardType: .default,
            isSecureTextEntry: true)
        tf.delegate = self
        tf.returnKeyType = .done
        return tf
    }()
    
    /// 탈퇴하기 버튼
    private lazy var deleteAccountBtn: UIButton = UIButton.buttonWithTitle(
        title: "탈퇴하기",
        titleColor: UIColor.white,
        font: UIFont.boldSystemFont(ofSize: 20),
        backgroundColor: self.currentMode?.btnColor ?? UIColor.blue_Lightly)
    
    /// 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.titleLabel,
                           self.separatorView,
                           self.guideLabel,
                           self.passwordCheckTF],
        axis: .vertical,
        spacing: 15,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    /// 로그인 방식에 따라 현재 모드 설정, (이메일 / 애플)
    var currentMode: LoginMethod?
    
    /// 델리게이트 - DeleteAccountCheckDelegate
    var delegate: DeleteAccountCheckDelegate?
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.configureLabel()
    }
    init(mode: LoginMethod) {
        self.currentMode = mode
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
    
    








// MARK: - 화면 설정

extension DeleteAccountCheckController {
    
    // MARK: - UI 설정
    private func configureUI() {
        
        self.view.backgroundColor = .blue_Base
        
        self.dismissBtn.clipsToBounds = true
        self.dismissBtn.layer.cornerRadius = 25
        
        [self.passwordCheckTF,
         self.deleteAccountBtn].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        [self.dismissBtn,
         self.stackView,
         self.deleteAccountBtn].forEach { view in
            self.view.addSubview(view)
        }
        
        // ********** 오토레이아웃 설정 **********
        self.separatorView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
        }
        self.passwordCheckTF.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        // X버튼
        self.dismissBtn.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview()
            make.width.height.equalTo(50)
        }
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.top.equalTo(self.dismissBtn.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        // 탈퇴 버튼
        self.deleteAccountBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-25)
            make.leading.trailing.equalTo(self.stackView)
            make.height.equalTo(45)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.passwordCheckTF.addTarget(self, action: #selector(self.passwordCheckTFTapped), for: .editingChanged)
        self.deleteAccountBtn.addTarget(self, action: #selector(self.deleteAccountBtnTapped), for: .touchUpInside)
        self.dismissBtn.addTarget(self, action: #selector(self.dismissBtnTapped), for: .touchUpInside)
    }
    
    // MARK: - 레이블 텍스트 설정
    private func configureLabel() {
        if self.currentMode == .apple {
            self.passwordCheckTF.isHidden = true
            self.deleteAccountBtn.isEnabled = true
            self.guideLabel.font = UIFont.boldSystemFont(ofSize: 14)
            
        } else {
            self.passwordCheckTF.isHidden = false
            self.deleteAccountBtn.isEnabled = false
            self.guideLabel.font = UIFont.boldSystemFont(ofSize: 14)
        }
    }
}
    
    








// MARK: - 셀렉터

extension DeleteAccountCheckController {
    
    // MARK: - 탈퇴 버튼 액션
    @objc private func deleteAccountBtnTapped() {
        // 이메일 로그인
        if self.currentMode == .email {
            if self.isValidPassword(pw: self.passwordCheckTF.text) {
                // 로그인 재인증 + 비밀번호가 맞는지 확인
                self.emailReauthenticate()
                return
            }
            // 6자리 미만
            self.customAlert(alertEnum: .password6Error) { _ in }
            return
            
            // 애플 로그인
        } else {
            self.customAlert(alertEnum: .deletedAppleAccount,
                             firstBtnColor: UIColor.red) { _ in
                UserData.deleteAccount = true
                self.delegate?.accountDelete(mode: .apple)
            }
        }
    }
    
    // MARK: - 텍스트 필드 액션
    @objc private func passwordCheckTFTapped() {
        if self.passwordCheckTF.hasText {
            // 텍스트필드에 텍스트가 있다면
            self.deleteAccountBtn.backgroundColor = UIColor.blue_Point
            self.deleteAccountBtn.isEnabled = true
            return
        }
        // 텍스트필드에 텍스트가 없다면
        self.deleteAccountBtn.isEnabled = false
        self.deleteAccountBtn.backgroundColor = UIColor.blue_Lightly
    }
    
    // MARK: - X버튼
    @objc private func dismissBtnTapped() {
        self.dismiss(animated: true)
    }
}
    
    
    







// MARK: - 액션

extension DeleteAccountCheckController {
    
    // MARK: - 사용자 재인증
    /// 사용자 재인증
    private func emailReauthenticate() {
        Auth_API
            .shared
            .deleteEmailAccount(password: self.passwordCheckTF.text) { result in
                switch result {
                case .success():
                    // 성공 -> 계정 및 데이터 삭제 진행
                    self.emailAccountDelete()
                    break
                case .failure(_):
                    // 실패 - 비밀번호 틀림
                    self.customAlert(alertEnum: .passwordIsNotSame) { _ in }
                }
            }
    }
    
    // MARK: - 이메일 계정 및 데이터 삭제
    /// 파이어베이스 계정 삭제 및 유저 데이터 삭제
    private func emailAccountDelete() {
        // 정말 삭제할지 물어보는 얼럿창
        self.customAlert(alertEnum: .deletedEmailAccount,
                         firstBtnColor: UIColor.red) { _ in
            // 계정 / 데이터 삭제
            Auth_API.shared.deleteFirebaseAccount { result in
                switch result {
                case .success(): // 성공
                    self.delegate?.accountDelete(mode: .email)
                    break
                case .failure(_): // 실패
                    self.customAlert(alertEnum: .unknownError) { _ in }
                }
            }
        }
    }
}










// MARK: - 텍스트필드 델리게이트
extension DeleteAccountCheckController: UITextFieldDelegate {
    /// 텍스트필드 엔터키를 누르면 호출 되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.passwordCheckTF.resignFirstResponder()
        return true
    }
}










// MARK: - 판모달 설정
extension DeleteAccountCheckController: PanModalPresentable {
    /// 스크롤뷰
    var panScrollable: UIScrollView? {
        return nil
    }
    /// 최대 사이즈
    var longFormHeight: PanModalHeight {
        return .contentHeight(self.view.frame.size.height)
    }
    /// 최소 사이즈
    var shortFormHeight: PanModalHeight {
        return .contentHeight(self.view.frame.size.height)
    }
    /// 화면 밖 - 배경 색
    var panModalBackgroundColor: UIColor {
        return #colorLiteral(red: 0.3215686275, green: 0.3221649485, blue: 0.3221649485, alpha: 0.64)
    }
    /// 상단 인디케이터 없애기
    var showDragIndicator: Bool {
        return false
    }
}
