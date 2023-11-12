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
    /// 배경 이미지
    private lazy var backgroundImg: UIImageView = UIImageView(
        image: UIImage.blueSky)
    
    /// 유저의 정보를 담을 뷰
    private lazy var userContainerView: UIView = UIView.backgroundView(
        color: UIColor.customWhite5)
    /// 유저 이미지
    private lazy var userImgView: UIImageView = UIImageView()
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
    
    
    private lazy var logoutBtn: UIButton = UIButton.buttonWithTitle(
        title: "로그아웃",
        titleColor: UIColor.red,
        font: UIFont.boldSystemFont(ofSize: 15),
        backgroundColor: UIColor.customWhite5)
    
    
    
    private lazy var containerStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.userContainerView,
                           self.tableView,
                           self.logoutBtn],
        axis: .vertical,
        spacing: 10,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private var user: User? {
        didSet { self.configureData() }
    }
    
    
    
    

    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUser_API()
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        
    }
}










// MARK: - 화면 설정

extension SettingController {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.navigationItem.title = "설정"
        // 테이블뷰 설정
        self.tableView.register(
            SettingTableViewCell.self,
            forCellReuseIdentifier: Identifier.settingTableCell)
        // 코너 레디어스
        [self.userContainerView,
         self.tableView,
         self.logoutBtn].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.userContainerView.addSubview(self.userImgView)
        self.userContainerView.addSubview(self.stackView)
        self.view.addSubview(self.backgroundImg)
        self.view.addSubview(self.containerStackView)
        
        // ********** 오토레이아웃 설정 **********
        // 배경뷰
        self.backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 유저 이미지뷰
        self.userImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.height.width.equalTo(60)
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
        /// 로그아웃 버튼
        self.logoutBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
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
    }
    
    // MARK: - 유저 정보 설정
    private func configureData() {
        // user 옵셔널바인딩
        guard let user = self.user else { return }
        // user 정보 업데이트
        self.userImgView.image = UIImage(named: "cat")
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
                self.goToSelectALoginController()
                break
            // 로그아웃에 실패했다면
            case .failure(_):
                self.apiFail_Alert()
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
                // MARK: - Fix
                self.apiFail_Alert()
                break
            }
        }
    }
    
    // MARK: - 유저정보 가져오기 _ API
    private func fetchUser_API() {
        // 유저가 있는지 확인
        User_API
            .shared
            .fetchUser { result in
            switch result {
                // 유저가 있다면
            case .success(let user):
                print("로그인 성공")
                self.user = user
                break
                
            case .failure(_):
                print("로그인 실패")
                // 로그인 선택 창으로 이동
                self.goToSelectALoginController()
                break
            }
        }
    }
}




















// MARK: - 로그아웃 액션

extension SettingController {
    
    // MARK: - 로그아웃 버튼 얼럿 액션
    /// 로그아웃 버튼이 눌리면 얼럿창을 띄움
    @objc private func logoutBtnTapped() {
        self.customAlert(
            withTitle: "정말 로그아웃 하시겠습니까?",
            firstBtnName: "로그아웃",
            firstBtnColor: UIColor.red) { _ in
                // 로그아웃 _ API
                self.logout_API()
            }
    }
    
    // MARK: - 로그인 선택창 이동
    /// 로그아웃에 성공하면 -> 로그인 선택창으로 이동
    private func goToSelectALoginController() {
        let controller = SelectALoginMethodController()
            // 델리게이트 설정
            controller.delegate = self.tabBarController as? TabBarController
        let vc = UINavigationController(rootViewController: controller)
            vc.modalPresentationStyle = .fullScreen
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
    }
    
    // MARK: - 전역변수 업데이트
    /// 전역변수 업데이트
    private func setGlobalVariable(_ settingTableEnum: SettingTableEnum,
                                   index: Int) {
        // 전역 변수 업데이트
        if settingTableEnum.rawValue == 0 {
            // 날짜 형식을 바꿈
            dateFormat_Static = index
            // 날짜 형식을 바뀌었다는 것을 알림
            dateFormat_Diary_Date = true
            dateFormat_Record_Date = true
        } else {
            // 시간 형식을 바꿈
            timeFormat_Static = index
            // 시간 형식을 바뀌었다는 것을 알림
            dateFormat_Record_Time = true
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
        // 얼럿창에 표시될 선택된 셀에 맞는 문자열 배열 가져오기
        let alertStringArray = settingTableEnum.alertStringArray
        
        // 얼럿창 띄우기
        self.customAlert(
            withTitle: alertStringArray[0],
            firstBtnName: alertStringArray[1],
            secondBtnName: alertStringArray[2]) { index in
                // 선택된 결과 DB저장
                self.formatChanged(settingTableEnum, index: index)
            }
    }
}
