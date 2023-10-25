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
        font: UIFont.boldSystemFont(ofSize: 15),
        textColor: UIColor.black)
    
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
    private lazy var tableView: RecodeTableView = {
        let tableView = RecodeTableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    
    private lazy var logoutBtn: UIButton = UIButton.configureBtnWithTitle(
        title: "로그아웃",
        font: UIFont.boldSystemFont(ofSize: 20),
        backgroundColor: UIColor.customWhite5)
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
}










// MARK: - 화면 설정

extension SettingController {
    
    // MARK: - UI 설정
    private func configureUI() {
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
        
        [self.backgroundImg,
         self.userContainerView,
         self.tableView,
         self.logoutBtn].forEach { view in
            self.view.addSubview(view)
        }
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
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(100)
        }
        /// 테이블뷰
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.userContainerView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(self.userContainerView)
        }
        /// 로그아웃 버튼
        self.logoutBtn.snp.makeConstraints { make in
            make.top.equalTo(self.tableView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(self.userContainerView)
            make.height.equalTo(50)
        }
    }
    
    
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.userImgView.image = UIImage(named: "cat")
        self.userNameLbl.text = "KGE"
        self.userEmailLbl.text = "chekel@gmail.com"
        
        
        
        self.logoutBtn.addTarget(self, action: #selector(self.logoutBtnTapped), for: .touchUpInside)
    }
}










// MARK: - 액션

extension SettingController {
    
    // MARK: - 로그아웃 버튼 얼럿 액션
    /// 로그아웃 버튼이 눌리면 얼럿창을 띄움
    @objc private func logoutBtnTapped() {
        self.presentAlertController(
            alertStyle: .actionSheet,
            withTitle: "정말 로그아웃 하시겠습니까?",
            secondButtonName: "로그아웃") { _ in
                print(#function)
            }
    }
    
    
    // MARK: - 날짜 형식 설정
    func dateFormatTapped(index: Int) {
        if index == 0 {
            // 0 (+ 1)
            // 1이면 일요일 시작
        } else {
            // 1 (+ 1)
            // 2면 월요일 시작
        }
    }
    
    // MARK: - 시간 형식 설정
    func timeFormatTapped(index: Int) {
        if index == 0 {
            // 12시간 형식: PM 2:00
        } else {
            // 24시간 형식: 14:00
        }
    }
}










// MARK: - 테이블뷰
extension SettingController: UITableViewDelegate, UITableViewDataSource {
    // 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.settingTableCell,
            for: indexPath) as! SettingTableViewCell
        
        cell.settingTableEnum = SettingTableEnum(rawValue: indexPath.row)
        return cell
    }
    
    // 테이블 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    // 테이블뷰를 선택하면 호출 됨
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let settingTableEnum = SettingTableEnum(rawValue: indexPath.row)
        // 얼럿창 띄우기
        self.presentAlertController(
            alertStyle: .actionSheet,
            withTitle: settingTableEnum!.alertTitle,
            secondButtonName: settingTableEnum!.firstOption,
            thirdButtonName: settingTableEnum!.secondOption) { index in
                // 선택된 결과
                settingTableEnum == .dateFormat
                ? self.dateFormatTapped(index: index)
                : self.timeFormatTapped(index: index)
            }
    }
}
