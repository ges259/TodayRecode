//
//  RecodeController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit
import SnapKit
import FSCalendar

final class Recodecontroller: UIViewController {
    
    // MARK: - 레이아웃
    /// 배경 이미지
    private lazy var backgroundImg: UIImageView = UIImageView(
        image: UIImage.blueSky)
    
    /// 날짜 표시해주는 뷰 (+ 레이블)
    private lazy var dateView: DateView = DateView()
    
    /// +버튼
    private lazy var plusBtn: UIButton = UIButton.configureBtn(
        image: UIImage.plus,
        tintColor: UIColor.black,
        backgroundColor: UIColor.white)
    
    /// 스크롤뷰
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
            scrollView.delegate = self
            scrollView.bounces = false
        return scrollView
    }()
    /// 컨텐트뷰 ( - 스크롤뷰)
    private lazy var contentView: UIView = UIView()
    
    /// 테이블뷰
    private lazy var tableView: CustomTableView = {
        let tableView = CustomTableView()
            tableView.register(RecodeTableViewCell.self,
                                forCellReuseIdentifier: Identifier.recodeTableCell)
            tableView.delegate = self
            tableView.dataSource = self
            // 배경 색상 설정
            tableView.backgroundColor = UIColor.clear
            // 바운스 되지 않게 설정
            tableView.bounces = false
            // 스크롤바 없애기
            tableView.showsVerticalScrollIndicator = false
            // 테이블뷰 셀간 구분선 없애기
            tableView.separatorStyle = .none
            // 테이블뷰가 스크롤되지 않도록 설정(스크롤뷰가 대신 스크롤 됨)
            tableView.isScrollEnabled = false
            // 테이블뷰 높이 설정
            tableView.estimatedRowHeight = 120
            tableView.rowHeight = 70
        return tableView
    }()
    
    /// 달력
    private lazy var calendar: CalendarView = {
        let calendar = CalendarView()
            calendar.delegate = self
            calendar.calendar.scope = .week
        return calendar
    }()
    /// 달력의 높이 제약
    private var calendarHeight: NSLayoutConstraint?
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    /// 셀의 개수
    private var tableCellCount: Int = 0
    
    
    
    
    
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.calendar,
                           self.dateView],
        axis: .vertical,
        spacing: 5,
        alignment: .fill,
        distribution: .fill)
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        // dateLabel에 날짜 띄우기
        self.configureDate()
    }
    
    
    
    // MARK: - 화면 구성
    private func configureUI() {
        self.navigationItem.title = "하루 기록"
        
        // cornerRadius
        [self.calendar,
         self.tableView].forEach({ view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        })
        self.plusBtn.clipsToBounds = true
        self.plusBtn.layer.cornerRadius = 50 / 2
    }
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // addSubView
        [self.backgroundImg,
//         self.calendar,
//         self.dateView,
         self.stackView,
         self.scrollView,
         self.plusBtn].forEach { views in
            self.view.addSubview(views)
        }
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.tableView)
        
        // 배경화면
        self.backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 달력
        self.calendar.snp.makeConstraints { make in
//            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
//            make.leading.equalToSuperview().offset(10)
//            make.trailing.equalToSuperview().offset(-10)
        }
        self.calendarHeight = self.calendar.heightAnchor.constraint(equalToConstant: 280)
        self.calendarHeight?.isActive = true
        // 날짜 뷰
        self.dateView.snp.makeConstraints { make in
//            make.top.equalTo(self.calendar.snp.bottom).offset(5)
//            make.leading.equalTo(self.calendar)
//            make.trailing.equalTo(self.calendar)
            make.height.equalTo(35)
        }
        self.stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
//            make.bottom.equalToSuperview()
        }
        // 스크롤뷰
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.stackView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        // 컨텐트뷰
        self.contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.scrollView.contentLayoutGuide)
            make.width.equalTo(self.scrollView.frameLayoutGuide)
        }
        // 테이블뷰
        self.tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.lessThanOrEqualTo(self.contentView.snp.bottom).offset(-10)
        }
        // 플러스 버튼
        self.plusBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.trailing.equalToSuperview().offset(-15)
            make.width.height.equalTo(53)
        }
    }
    
    
        
    // MARK: - 액션 설정
    private func configureAction() {
        // 뷰 액션 설정
            // 위로 스와이프
        let swipeUp = UISwipeGestureRecognizer(target: self,
                                               action: #selector(self.swipeAction(_:)))
            swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
            // 아래로 스와이프
        let swipeDown = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(self.swipeAction(_:)))
            swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        // 플러스 버튼 액션 설정
        self.plusBtn.addTarget(self, action: #selector(self.plusBtnTapped), for: .touchUpInside)
        
        self.configureNavBtn()
    }
    
    
    
    private func configureNavBtn() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.calendar,
            style: .done,
            target: self,
            action: #selector(self.calendarTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc private func calendarTapped() {
        
        
        UIView.animate(withDuration: 0.5) {
            self.calendar.isHidden.toggle()
            self.view.layoutIfNeeded()
            
        }
    }
    
    
    
    
    
    
    
    // MARK: - 날짜 설정
    /// dateLabel에 날짜를 띄우는 메서드
    /// 기본값: 오늘 날짜를 띄운다.
    /// - Parameter selectedDate: 선택된 날짜를 띄운다.
    func configureDate(selectedDate: Date = Date()) {
        self.dateView.configureDate(selectedDate: selectedDate)
    }
    
    
    
    // MARK: - 위/아래 스와이프 액션
    /// 스와이프를 하면 자동으로 불리는 메서드
    /// up: 달력을 한 주만 보이도록 설정
    /// down: 달력을 한 달 전체가 보이도록 설정
    @objc private func swipeAction(_ swipe: UISwipeGestureRecognizer) {
        
        // MARK: - Fix
        swipe.direction == .up
        ? self.calendar.swipeAction(up: true)
        : self.calendar.swipeAction(up: false)
    }
    
    
    
    // MARK: - 플러스 버튼 액션
    /// 간편 작성 화면으로 이동
    @objc private func plusBtnTapped() {
        let vc = EasyWritingScreenController()
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
        self.present(vc, animated: false)
    }
    
    // MARK: - 상세 작성 화면으로 이동
    private func pushToDetailWritingScreen() {
        let vc = DetailWritingScreenController()
            // 상세 작성뷰에서 탭바 없애기
            vc.hidesBottomBarWhenPushed = true
            vc.detailViewMode = .recode
            vc.detailEditMode = .writingMode
        self.navigationController?.pushViewController(vc, animated: true)
        // MARK: - Fix
        /*
         추가해야할 것
         - 셀을 눌러서 넘어갈 때 -> 셀의 데이터 가져가기
         - 확대 버튼을 눌러서 넘어갈 때 -> easyWritingScreen에 있는 텍스트 및 이미지 가져가기
         */
    }
}











// MARK: - 켈린더 델리게이트
extension Recodecontroller: CalendarDelegate {
    func selectDate(date: Date) {
        self.configureDate(selectedDate: date)
    }
    
    func heightChanged(height: CGFloat) {
        // 높이 바꾸기
        self.calendarHeight?.constant = height
        // 뷰(켈린더) 다시 그리기
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}













// MARK: - 스크롤뷰
extension Recodecontroller: UIScrollViewDelegate {
    /// 스크롤이 끝났을 때
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 스크롤이 끝났을 때
        if scrollView.contentOffset.y == 0 && self.calendar.currentCalendarScope() == .week {
            // 한 달 전체가 보이도록 설정
            self.calendar.calendar.setScope(.month, animated: true)
        }
    }

    /// 스크롤을 시작했을 때 달력이 월 별 달력이라면 주간 달력으로 바꿈
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.calendar.currentCalendarScope() == .month {
            self.calendar.calendar.setScope(.week, animated: true)
            // 잠깐동안 스크롤되지 않게 하기 위해 설정
            self.scrollView.isScrollEnabled = false
            self.scrollView.isScrollEnabled = true
        }
    }
}










// MARK: - 테이블뷰 델리게이트
extension Recodecontroller: UITableViewDelegate {
    /// 스와이프 설정
    /// 오른쪽 -> 왼쪽 스와이프하면 버튼이 나타남
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 왼쪽에 만들기
        let trash = UIContextualAction(style: .normal, title: "삭제") { (_, _, success: @escaping (Bool) -> Void) in
            print("trash 클릭 됨")
            success(true)
        }
        trash.image = UIImage(systemName: "trash")
        trash.backgroundColor = .systemPink
        //actions배열 인덱스 0이 왼쪽에 붙어서 나옴
        let swipeAction = UISwipeActionsConfiguration(actions:[trash])
            swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushToDetailWritingScreen()
    }
}

extension Recodecontroller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.tableCellCount
        return 12
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.recodeTableCell, for: indexPath) as! RecodeTableViewCell
        
        return cell
    }
}









// MARK: - 간편 작성 화면 델리게이트
extension Recodecontroller: EasyWritingScreenDelegate {
    func expansionBtnTapped() {
        self.pushToDetailWritingScreen()
    }
}
