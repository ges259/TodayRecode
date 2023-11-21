//
//  SettingController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit
import SnapKit

final class SettingController: UIViewController {
    // MARK: - 레이아웃
    /// 네비게이션 타이틀 레이블
    private lazy var navTitle: UILabel = UILabel.navTitleLbl()
    
    /// 유저의 정보를 담을 뷰
    private lazy var userContainerView: UIView = UIView.backgroundView(
        color: UIColor.white_Base)
    
    /// 유저 이미지
    private lazy var userImgView: UIImageView = {
        let img = UIImageView(image: UIImage.person_Img)
            img.tintColor = UIColor.black
        return img
    }()
    
    /// 유저 이름
    private lazy var userNameLbl: UILabel = UILabel.configureLbl(
        font: UIFont.boldSystemFont(ofSize: 17))
    
    /// 유저 이메일
    private lazy var userEmailLbl: UILabel = UILabel.configureLbl(
        font: UIFont.boldSystemFont(ofSize: 12),
        textColor: UIColor.lightGray)
    
    /// (유저 이름, 유저 이메일) 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.userNameLbl,
                           self.userEmailLbl],
        axis: .vertical,
        spacing: 5,
        alignment: .fill,
        distribution: .fill)
    
    /// 테이블뷰
    private lazy var tableView: RecordTableView = {
        let tableView = RecordTableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var logoutBtn: UIButton = UIButton.buttonWithImgAndTitle(.logout)
    
    private lazy var deleteAccountBtn: UIButton = UIButton.buttonWithImgAndTitle(.deleteAccount)
    
    
    private lazy var horizontalBtnStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.logoutBtn,
                           self.deleteAccountBtn],
        axis: .horizontal,
        spacing: 5,
        alignment: .fill,
        distribution: .fill)
    
    
    private lazy var containerStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.userContainerView,
                           self.tableView,
                           self.horizontalBtnStackView],
        axis: .vertical,
        spacing: 10,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dump(UserData.user)
        self.configureData()
    }
}










// MARK: - 화면 설정

extension SettingController {
    
    // MARK: - UI 설정
    private func configureUI() {
        // 배경 색상 설정
        self.view.backgroundColor = UIColor.blue_Base
        // 네비게이션 타이틀뷰(View) 설정
        self.navigationItem.titleView = self.navTitle
        self.navTitle.text = "설정"
        
        // 테이블뷰 설정
        self.tableView.register(
            SettingTableViewCell.self,
            forCellReuseIdentifier: Identifier.settingTableCell)
        // 코너 레디어스
        [self.userContainerView,
         self.tableView,
         self.logoutBtn,
         self.deleteAccountBtn].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.userContainerView.addSubview(self.userImgView)
        self.userContainerView.addSubview(self.stackView)
        self.view.addSubview(self.containerStackView)
        
        // ********** 오토레이아웃 설정 **********
        // 유저 이미지
        self.userImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(55)
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
        // 유저 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.leading.equalTo(self.userImgView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        /// 유저 컨테이너
        self.userContainerView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        /// 컨테이너 스택뷰
        self.containerStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.logoutBtn.addTarget(self, action: #selector(self.logoutBtnTapped), for: .touchUpInside)
        
        self.deleteAccountBtn.addTarget(self, action: #selector(self.deleteAccountBtnTapped), for: .touchUpInside)
    }
    
    // MARK: - 유저 정보 설정
    private func configureData() {
        // user 옵셔널바인딩
        guard let user = UserData.user else { return }
        // user 정보 업데이트
        self.userNameLbl.text = user.userName
        self.userEmailLbl.text = user.email
    }
}




















// MARK: - API
    
extension SettingController {
    
    // MARK: - 로그아웃
    private func logout_API() {
        // 로그아웃
        Auth_API.shared.logout { result in
            switch result {
            // 로그아웃에 성공했다면
            case .success():
                self.goToSelectALoginController(.logout)
                break
            // 로그아웃에 실패했다면
            case .failure(_):
                self.customAlert(alertEnum: .logoutFail) { _ in }
                break
            }
        }
    }
    
    // MARK: - 날짜 / 시간 형식 변경
    private func foramtChanged_API(_ settingTableEnum: SettingTableEnum,
                                   index: Int) {
        // 형식 업데이트
        User_API
            .shared
            .updateDateFormat(settingTableEnum,
                              selectedIndex: index) { result in
            switch result {
            case .success(_):
                break
                
            case .failure(_):
                if settingTableEnum == .dateFormat {
                    self.customAlert(alertEnum: .dateformatChangeFail) { _ in }
                } else {
                    self.customAlert(alertEnum: .timeformatChangeFail) { _ in }
                }
                break
            }
        }
    }
}




















// MARK: - 버튼 액션

extension SettingController {
    
    // MARK: - 로그아웃 버튼 얼럿 액션
    /// 로그아웃 버튼이 눌리면 얼럿창을 띄움
    @objc private func logoutBtnTapped() {
        self.customAlert(alertStyle: .actionSheet,
                         alertEnum: .logout,
                         firstBtnColor: .red) { _ in
            // 로그아웃 _ API
            self.logout_API()
        }
    }
    
    // MARK: - 회원 탈퇴 버튼 액션
    @objc private func deleteAccountBtnTapped() {
        
        let deleteAccountCheckVC: DeleteAccountCheckController?
        
        // 현재 로그인 방식 옵셔널 바인딩
        guard let loginMethod = UserData.user?.loginMethod else { return }
        // 로그인 방식에 따라 deleteAccountCheckVC의 UI및 내용이 달라진다.
        switch loginMethod {
        case LoginMethod.email.description:
            deleteAccountCheckVC = DeleteAccountCheckController(mode: .email)
        case LoginMethod.apple.description:
            deleteAccountCheckVC = DeleteAccountCheckController(mode: .apple)
        default:
            deleteAccountCheckVC = DeleteAccountCheckController(mode: .email)
        }
        
        // deleteAccountCheckVC로 이동
        if let recodeCheckVC = deleteAccountCheckVC {
            recodeCheckVC.delegate = self
            recodeCheckVC.modalPresentationStyle = .overFullScreen
            // 화면 전환 (판모달 사용)
            self.presentPanModal(recodeCheckVC)
        }
    }
    
    // MARK: - 로그인 선택창 이동
    /// 로그아웃에 성공하면 -> 로그인 선택창으로 이동
    private func goToSelectALoginController(_ btnEnum: ConfigurationBtnEnum) {
        let controller = SelectALoginMethodController()
            // 델리게이트 설정
            controller.delegate = self.tabBarController as? TabBarController
        
        let vc = UINavigationController(rootViewController: controller)
            vc.modalPresentationStyle = .fullScreen
        // 회원 탈퇴 버튼이 눌리면 -> 회원 탈퇴
        if btnEnum == .deleteAccount {
            controller.deleteUser()
        }
        self.present(vc, animated: true)
    }
}














// MARK: - 형식 변경 액션

extension SettingController {
    
    // MARK: - 날짜 형식 변경
    private func formatChanged(_ settingTableEnum: SettingTableEnum,
                              index: Int) {
        // 형식 변환 _ API
        self.foramtChanged_API(settingTableEnum, index: index)
        // 전역변수 업데이트
        self.setGlobalVariable(settingTableEnum, index: index)
        // 설정_테이블뷰 리로드
        self.tableView.reloadRows(
            at: [IndexPath(row: settingTableEnum.rawValue,
                           section: 0)],
            with: .automatic)
        // 로딩뷰 내리기
        self.showLoading(false)
    }
    
    // MARK: - 전역변수 업데이트
    /// 전역변수 업데이트
    private func setGlobalVariable(_ settingTableEnum: SettingTableEnum,
                                   index: Int) {
        // 전역 변수 업데이트
        if settingTableEnum.rawValue == 0 {
            // 날짜 형식을 바꿈
            Format.dateFormat_Static = index
            // 날짜 형식을 바뀌었다는 것을 알림
            Format.dateFormat_Diary_Date = true
            Format.dateFormat_Record_Date = true
        } else {
            // 시간 형식을 바꿈
            Format.timeFormat_Static = index
            // 시간 형식을 바뀌었다는 것을 알림
            Format.dateFormat_Record_Time = true
        }
    }
}
    
    
    
    
    
    
    
    
    











// MARK: - 테이블뷰
extension SettingController: UITableViewDelegate, UITableViewDataSource {
    // 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 셀 표현?
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.settingTableCell,
            for: indexPath) as! SettingTableViewCell
        
        cell.settingTableEnum = SettingTableEnum(rawValue: indexPath.row)
        return cell
    }

    // 테이블 높이
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    // 테이블뷰를 선택하면 호출 됨
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        guard let settingTableEnum = SettingTableEnum(rawValue: indexPath.row) else { return }
        
        let alertEnum: AlertEnum
        = settingTableEnum == .dateFormat
        ? .dateFormat
        : .timeFormat
        
        self.customAlert(alertStyle: .actionSheet,
                         alertEnum: alertEnum) { index in
            // 다른 화면으로 이동 못 하도록 로딩뷰 띄우기
            self.showLoading(true)
            // 선택된 결과 DB저장
            self.formatChanged(settingTableEnum, index: index)
        }
    }
}







extension SettingController: DeleteAccountCheckDelegate {
    func accountDelete(mode: LoginMethod) {
        self.dismiss(animated: true)
        mode == .apple
        ? self.goToSelectALoginController(.deleteAccount)
        : self.goToSelectALoginController(.logout)
    }
}
