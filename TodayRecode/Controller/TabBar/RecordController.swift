//
//  RecodeController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit
import SnapKit
import FSCalendar

final class RecordController: UIViewController {
    
    // MARK: - 레이아웃
    /// 배경 이미지
    private lazy var backgroundImg: UIImageView = UIImageView(
        image: UIImage.blueSky)
    
    /// 네비게이션 타이틀 레이블
    private lazy var navTitle: UILabel = UILabel.navTitleLbl()
    
    /// 날짜 표시해주는 뷰 (+ 레이블)
    private lazy var dateView: DateView = DateView()
    
    /// +버튼
    private lazy var plusBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.plus,
        tintColor: UIColor.black,
        backgroundColor: UIColor.white)
    
    /// 스크롤뷰
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
            scrollView.delegate = self
            scrollView.bounces = false
            scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    /// 컨텐트뷰 ( - 스크롤뷰)
    private lazy var contentView: UIView = UIView()
    
    /// 테이블뷰
    private lazy var tableView: RecodeTableView = {
        let tableView = RecodeTableView()
            tableView.register(RecodeTableViewCell.self,
                               forCellReuseIdentifier: Identifier.recodeTableCell)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.isScrollEnabled = false
        return tableView
    }()
    
    /// 달력
    private lazy var calendar: CalendarView = {
        let calendar = CalendarView()
            calendar.delegate = self
            calendar.calendar.scope = .week
        calendar.isHidden = true
        return calendar
    }()
    /// 달력의 높이 제약
    private var calendarHeight: NSLayoutConstraint?
    
    /// 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.calendar,
                           self.dateView],
        axis: .vertical,
        spacing: 5,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    /// 오늘인지 아닌지 판단하는 변수
    private var isToday: Bool = true
    
    /// 오늘 기록
    private var todayRecords_Array: [Record] = [Record]()
    /// 다른 날의 기록
    private var anotherDayRecords_Array: [Record] = [Record]()
    /// 오늘 날짜
    private lazy var today_Date: Date? = Date.UTC_Plus9(date: Date())
    /// 다른 날짜 (
    private var anotherDay_Date: Date?
    
    /// 셀을 통해 상세 작성 화면으로 넘어간 후 수정했을 때, 셀을 업데이트를 하기 위한 index 표시
    private var currentIndex: Int = 0
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchRecords()         // 데이터 가져오기
        self.configureUI()          // UI 설정
        self.configureAutoLayout()  // 오토레이아웃 설정
        self.configureAction()      // 액션 설정
    }
}
    
    
    














    
    
    
// MARK: - 화면 설정

extension RecordController {
    
    // MARK: - UI 설정
    private func configureUI() {
        // 네비게이션 타이틀뷰(View) 설정
        self.navigationItem.titleView = self.navTitle
        
        // 네비게이션 타이틀(String) 설정
        self.setNavTitle(date: Date())
        // dateLabel에 날짜 띄우기
        self.configureDate()
        // 달력에 오늘 날짜 선택 (원래 기본적으로 선택 안 되어있음)
        self.calendar.calendar.select(Date())
        
        // 코너 둥글게 설정
        self.tableView.clipsToBounds = true
        self.tableView.layer.cornerRadius = 10
        
        self.plusBtn.clipsToBounds = true
        self.plusBtn.layer.cornerRadius = 58 / 2
    }
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        [self.backgroundImg,
         self.stackView,
         self.scrollView,
         self.plusBtn].forEach { view in
            self.view.addSubview(view)
        }
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.tableView)
        
        
        // ********** 오토레이아웃 설정 **********
        // 배경화면
        self.backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 달력
        self.calendar.translatesAutoresizingMaskIntoConstraints = false
        self.calendarHeight = self.calendar.heightAnchor.constraint(equalToConstant: 280)
        self.calendarHeight?.isActive = true
        // 날짜 뷰
        self.dateView.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
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
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
        // 플러스 버튼
        self.plusBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-17)
            make.trailing.equalToSuperview().offset(-17)
            make.width.height.equalTo(58)
        }
        // 네비게이션 타이틀
        self.navTitle.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(100)
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.calendar,
            style: .done,
            target: self,
            action: #selector(self.navCalendarBtnTapped))
        
    }
}
















// MARK: - API
extension RecordController {
    private func fetchRecords(date: Date = Date()) {
        // 해당 날짜의 데이터 가져오기
        Record_API.shared.fetchRecode(date: date) { recodeArray in
            // 오늘이라면
            if self.isToday {
                self.todayRecords_Array = recodeArray
                // 오늘이 아니라면
            } else {
                self.anotherDayRecords_Array = recodeArray
            }
            // 테이블뷰 리로드
            self.tableView.reloadData()
        }
    }
}




















// MARK: - 셀렉터

extension RecordController {
    
    // MARK: - 위/아래 스와이프
    /// 스와이프를 하면 자동으로 불리는 메서드
    /// up: 달력을 한 주만 보이도록 설정
    /// down: 달력을 한 달 전체가 보이도록 설정
    @objc private func swipeAction(_ swipe: UISwipeGestureRecognizer) {
        swipe.direction == .up
        ? self.calendar.swipeAction(up: true)
        : self.calendar.swipeAction(up: false)
    }
    
    
    
    // MARK: - 네비게이션 버튼 액션
    /// 네비게이션 오른쪽 버튼, 달력 이미지누르면 달력을 숨기거나 보이게할 수 있다.
    @objc private func navCalendarBtnTapped() {
        UIView.animate(withDuration: 0.5) {
            // 캘린더 숨기기 / 보이게 하기
            self.calendar.isHidden.toggle()
            self.stackView.layoutIfNeeded()
            // 캘린더의 현재 상태(isHidden)를 저장
            calendarIsHidden_Static.toggle()
            // calendar(달력)에서 현재 선택된 날짜를 받아옴
            guard let date = self.calendar.returnSelectedDate else { return }
            // 네비게이션 타이틀 재설정
            self.setNavTitle(date: date)
        }
    }
    
    
    
    // MARK: - 간편 작성 화면 이동 (플러스 버튼)
    /// 플러스 버튼을 누르면 간편 작성 화면으로 이동
    @objc private func plusBtnTapped() {
        let vc = EasyWritingScreenController()
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        // 달력에 선택된 날짜 보내기
        vc.selectedDate = self.calendar.calendar.selectedDate
        // 화면 이동
        self.present(vc, animated: false)
    }
}










// MARK: - 액션

extension RecordController {
    
    // MARK: - 네비게이션 타이틀 재설정
    /// 선택된 날짜에 따라 네비게이션 타이틀을 설정하는 메서드
    private func setNavTitle(date: Date = Date()) {
        if calendarIsHidden_Static {
            self.navTitle.text = "하루 기록"
        } else {
            self.navTitle.attributedText = self.configureNavTitle( "하루 기록", date: date)
        }
    }
    
    
    
    // MARK: - 날짜 설정 액션
    /// dateLabel에 날짜를 띄우는 메서드
    func configureDate(selectedDate: Date = Date()) {
        self.dateView.configureDate(selectedDate: selectedDate)
    }
    
    
    
    // MARK: - 상세 작성 화면으로 이동
    /// 상세 작성 화면으로 이동
    private func pushToDetailWritingScreen(selectedRecord: Record? = nil,
                                           easyViewString: String? = nil) {
        let vc = DetailWritingScreenController()
        // 상세 작성뷰에서 탭바 없애기
        vc.hidesBottomBarWhenPushed = true
        // 델리게이트 설정
        vc.delegate = self
        
        // 기록 확인 화면에서 사용할 해당 날짜 배열
        vc.todayRecords = self.isToday
        ? self.todayRecords_Array // 오늘일 때
        : self.anotherDayRecords_Array // 오늘이 아닐 때
        
        
        // 기록 화면에서 넘어갔다는 표시
        vc.detailViewMode = selectedRecord == nil
        ? .record_plusBtn
        : .record
        
        
        // 확장 버튼을 통해 넘어간 경우
            // -> 아무 것도 적혀있지 않다면
        if easyViewString != "" {
            // 문자열만 가져간다.
            vc.diaryTextView.text = easyViewString
            vc.placeholderLbl.isHidden = true
        }
        
        // 데이터 넘겨주기 (파라미터로 받은 데이터)
        vc.selectedRecord = selectedRecord
        
            
        
        
        // 화면 이동
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // MARK: - 테이블에 데이터 추가
    private func addRecord(record: Record) {
        // 오늘이라면
        if self.isToday {
            // 오늘 배열에 넣기
            self.todayRecords_Array.insert(record, at: 0)
        // 오늘이 아니라면
        } else {
            self.anotherDayRecords_Array.insert(record, at: 0)
        }
        // 테이블뷰 특정 셀 리로드
        self.tableView.insertRows(
            at: [IndexPath(row: 0, section: 0)],
            with: .none)
    }
}




















// MARK: - 켈린더 델리게이트
extension RecordController: CalendarDelegate {
    /// 날짜를 선택하면 호출
    func selectDate(date: Date) {
        // 데이트뷰의 선택한 날짜로 레이블을 변경
        self.configureDate(selectedDate: date)
        // 선택된 날짜의 [년, 월, 일]
        let selectedDate = Date.UTC_Plus9(date: date)
        
        // 선택된 날짜가 오늘이라면
        if self.today_Date == selectedDate {
            self.isToday = true
            self.tableView.reloadData()

        // 선택된 날짜가 오늘이 아니라면
            // 1. 가장 최근에 선택되었던 날이라면
        } else if self.anotherDay_Date == selectedDate {
            self.isToday = false
            self.tableView.reloadData()
            
            // 2. 가장 최근에 선택된 날이 아니라면
        } else {
            self.isToday = false
            // 선택한 날짜의 데이터 가져오기
            self.fetchRecords(date: date)
            // 가장 최근에 선택되었다는 표시 남기기
            self.anotherDay_Date = selectedDate
        }
    }
    
    // 달력의 높이가 바뀌면 호출
    func heightChanged(height: CGFloat) {
        // 높이 바꾸기
        self.calendarHeight?.constant = height
        // 뷰(켈린더) 다시 그리기
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// 달력을 스크롤하여 다른 달이 되었을 때 호출
    func monthChanged(date: Date) {
        self.setNavTitle(date: date)
    }
}










// MARK: - 스크롤뷰
extension RecordController: UIScrollViewDelegate {
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
extension RecordController: UITableViewDelegate {
    /// 스와이프 설정
    /// 오른쪽 -> 왼쪽 스와이프하면 버튼이 나타남
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 왼쪽에 만들기
        let trash = UIContextualAction(style: .normal, title: "삭제") { (_, _, success: @escaping (Bool) -> Void) in
            print("trash 클릭 됨")
            success(true)
        }
        // 이미지 및 색상 설정
            trash.image = UIImage(systemName: "trash")
            trash.backgroundColor = .systemPink
        //actions배열 인덱스 0이 왼쪽에 붙어서 나옴
        let swipeAction = UISwipeActionsConfiguration(actions:[trash])
            swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    
    /// 셀을 눌렀을 때
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        // 오늘인지 아닌지 판단
        let array: [Record] = self.isToday
        ? self.todayRecords_Array      // 오늘일 때
        : self.anotherDayRecords_Array // 오늘이 아닐 때
        
        // 상세 작성 화면으로 이동
        self.pushToDetailWritingScreen(selectedRecord: array[indexPath.row])
    }
}

extension RecordController: UITableViewDataSource {
    /// 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        // 오늘인지 아닌지 판단
        return self.isToday
        ? self.todayRecords_Array.count       // 오늘일 때
        : self.anotherDayRecords_Array.count  // 오늘이 아닐 때
    }
    /// 셀 구현
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.recodeTableCell,
            for: indexPath) as! RecodeTableViewCell
        
        // 오늘인지 아닌지 판단
        cell.cellRecord = self.isToday
        ? self.todayRecords_Array[indexPath.row]      // 오늘일 때
        : self.anotherDayRecords_Array[indexPath.row] // 오늘이 아닐 때
        
        // index 표시
        self.currentIndex = indexPath.row
        
        // 리턴
        return cell
    }
}










// MARK: - 간편 작성 화면 델리게이트
extension RecordController: EasyWritingScreenDelegate {
    /// 확대 버튼을 누르면 -> 상세 작성 화면으로 이동
    func expansionBtnTapped(context: String?) {
        self.pushToDetailWritingScreen(easyViewString: context)
    }
    
    /// 데이터를 생성하면 -> 셀에 추가
    func createRecord(record: Record) {
        self.addRecord(record: record)
    }
}










extension RecordController: DetailWritingScreenDelegate {
    /// 데이터를 생성하면 -> 셀에 추가
    func createRocord(record: Record) {
        self.addRecord(record: record)
    }
    
    /// 데이터를 업데이트하면 -> 셀을 업데이트
    func updateRecord(context: String, image: String?) {
        // currentIndex를 사용
        
        // String 및 이미지만 바꾸면 됨
    }
    
    func deleteRecord() {
        /// 데이터를 삭제하면 -> 셀 삭제
    }
}
