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
    
    // MARK: - Layout
    /// 배경 이미지
    private let backgroundImg: UIImageView = UIImageView()
    /// 달력
    private let calendar: FSCalendar = FSCalendar()
    /// 달력의 높이 제약
    private var calendarHeight: NSLayoutConstraint?
    /// 달력 밑의 뷰
    private let dateView: UIView = UIView()
    /// 달력 밑, 날짜를 알려주는 레이블
    private let dateLabel: UILabel = UILabel()
    /// 스크롤뷰
    private let scrollView: UIScrollView = UIScrollView()
    /// 컨텐트뷰 ( - 스크롤뷰)
    private let contentView: UIView = UIView()
    /// 테이블뷰
    private var tableView: CustomTableView = CustomTableView()
    // +버튼
    private let plusBtn: UIButton = UIButton(type: .system)
        
    
    
    
    
    
    
    // MARK: - Properties
    /// 날짜가 선택되면 날짜레이블(dateLabel)에 해당 날짜 표시
    private var selectedDay: String? {
        didSet { self.dateLabel.text = self.selectedDay }
    }
    
    /// 셀의 개수
    private var tableCellCount: Int = 0
    
    
    
    
    
    
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableAndScroll()
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.configureCalendar()
    }
    
    // 오토레이아웃
    private func configureAutoLayout() {
        [self.backgroundImg, self.calendar, self.dateView, self.scrollView, self.plusBtn].forEach { views in
            self.view.addSubview(views)
        }
        
        // 배경화면
        self.backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 달력
        self.calendar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        self.calendarHeight = self.calendar.heightAnchor.constraint(equalToConstant: 300)
        self.calendarHeight?.isActive = true
        // 날짜 뷰
        self.dateView.snp.makeConstraints { make in
            make.top.equalTo(self.calendar.snp.bottom).offset(5)
            make.leading.equalTo(self.calendar)
            make.trailing.equalTo(self.calendar)
            make.height.equalTo(35)
        }
        // 날짜 레이블
        self.dateView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        // 스크롤뷰
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.dateView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        // 컨텐트뷰
        self.scrollView.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.scrollView.contentLayoutGuide)
            make.width.equalTo(self.scrollView.frameLayoutGuide)
        }
        // 테이블뷰
        self.contentView.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.lessThanOrEqualTo(self.contentView.snp.bottom).offset(-10)
        }
        // 플러스 버튼
        self.plusBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.height.equalTo(50)
        }
    }
    
    
    
    // MARK: - 화면 구성
    private func configureUI() {
        self.navigationItem.title = "하루 기록"
        // 배경 이미지
        self.backgroundImg.image = UIImage(named: "blueSky")
        // 날짜 뷰
        self.dateView.backgroundColor = UIColor.customWhite5
        // 날짜 레이블
        self.dateLabel.font = .systemFont(ofSize: 13)
            // dateLabel에 날짜 띄우기
        self.dateChangeToString()
        // 플러스 버튼
        self.plusBtn.setImage(UIImage(systemName: "plus"), for: .normal)
        self.plusBtn.backgroundColor = .white
        
        
        
        // cornerRadius
        [self.calendar, self.dateView, self.tableView].forEach({ view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        })
        self.plusBtn.clipsToBounds = true
        self.plusBtn.layer.cornerRadius = 50 / 2
    }
    
    

    // MARK: - 달력 설정
    /// 달력 기본 설정
    private func configureCalendar() {
        self.calendar.delegate = self
        self.calendar.dataSource = self
        // 배경 색상 설정
        self.calendar.backgroundColor = .customWhite5
        // 처음에는 일주일만 보이도록 설정
        self.calendar.scope = .week
        // (월/화/수~~)한글로 표시
        self.calendar.locale = Locale(identifier: "ko_KR")
            // 폰트 크기 설정
        self.calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 12)
            // 색상
        self.calendar.appearance.weekdayTextColor = .black.withAlphaComponent(0.7)
        // 헤더 높이 설정
        self.calendar.headerHeight = 0
        // 이벤트 - 선택되지 않은 날짜 색깔
        self.calendar.appearance.eventDefaultColor = UIColor.green
        // 이벤트 - 선택된 날짜 색깔
        self.calendar.appearance.eventSelectionColor = .clear
    }
    
    
    
    // MARK: - 테이블뷰 설정
    /// 테이블뷰 설정
    private func configureTableAndScroll() {
        // 스크롤뷰
        self.scrollView.delegate = self
        self.scrollView.bounces = false
        
        // 테이블뷰
        self.tableView.register(RecodeTableViewCell.self,
                                forCellReuseIdentifier: Identifier.recodeTableCell)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // 배경 색상 설정
        self.tableView.backgroundColor = UIColor.clear
        // 바운스 되지 않게 설정
        self.tableView.bounces = false
        // 스크롤바 없애기
        self.tableView.showsVerticalScrollIndicator = false
        // 테이블뷰 셀간 구분선 없애기
        self.tableView.separatorStyle = .none
        // 테이블뷰가 스크롤되지 않도록 설정(스크롤뷰가 대신 스크롤 됨)
        self.tableView.isScrollEnabled = false
        // 테이블뷰 높이 설정
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = 70
    }
    
    
    
    // MARK: - 액션 설정
    private func configureAction() {
        // 위로 스와이프
        let swipeUp = UISwipeGestureRecognizer(target: self,
                                               action: #selector(self.swipeAction(_:)))
            swipeUp.direction = .up
        self.tableView.addGestureRecognizer(swipeUp)
        self.view.addGestureRecognizer(swipeUp)
        // 아래로 스와이프
        let swipeDown = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(self.swipeAction(_:)))
            swipeDown.direction = .down
        self.tableView.addGestureRecognizer(swipeDown)
        self.view.addGestureRecognizer(swipeDown)
        
        // 플러스 버튼 셀렉터
        self.plusBtn.addTarget(self, action: #selector(self.plusBtnTapped), for: .touchUpInside)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /// 스와이프를 하면 자동으로 불리는 메서드
    /// up: 달력을 한 주만 보이도록 설정
    /// down: 달력을 한 달 전체가 보이도록 설정
    @objc private func swipeAction(_ swipe: UISwipeGestureRecognizer) {
        swipe.direction == .up
        ? self.calendar.setScope(.week, animated: true)
        : self.calendar.setScope(.month, animated: true)
    }
    
    @objc private func plusBtnTapped() {
        
        self.tableCellCount += 1
        
        self.tableView.reloadData()
    }
    
    
    
    
    
    
    /// dateLabel에 날짜를 띄우는 메서드
    /// 기본값: 오늘 날짜를 띄운다.
    /// - Parameter selectedDate: 선택된 날짜를 띄운다.
    func dateChangeToString(selectedDate: Date? = Date()) {
        // 날짜 설정
        let dateFormat = DateFormatter()
            dateFormat.dateFormat = "M월 d일"
        // dateLabel에 오늘 날짜 띄우기
        self.selectedDay = dateFormat.string(from: selectedDate!)
    }
    
    
    
    
    
    
    
    
    
    
    
}






// MARK: - 켈린더 델리게이트
extension Recodecontroller: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        // 높이 바꾸기
        self.calendarHeight?.constant = bounds.height
        // 뷰 다시 그리기
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    /// 날짜를 선택했을 때
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // dateLabel에 선택된 날짜 띄우기
        self.dateChangeToString(selectedDate: date)
    }
    
    
    
    /// 이벤트가 표시되는 갯수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
}







// MARK: - 테이블뷰 델리게이트
extension Recodecontroller: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < 1 {
            self.scrollView.isScrollEnabled = false
            // 한 달 전체가 보이도록 설정
            self.calendar.setScope(.month, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.scrollView.isScrollEnabled = true
            }
            
            
        } else if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
        }
    }
}


extension Recodecontroller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableCellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.recodeTableCell, for: indexPath) as! RecodeTableViewCell
        
        
         
        return cell
    }
}
