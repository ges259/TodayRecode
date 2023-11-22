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
    /// 네비게이션 타이틀 레이블
    private lazy var navTitle: UILabel = UILabel.navTitleLbl()
    
    /// 날짜 표시해주는 뷰 (+ 레이블)
    private lazy var dateView: DateView = DateView()
    
    /// +버튼 -> EasyWritingScreenView로 이동
    private lazy var plusBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.plus,
        tintColor: UIColor.white,
        backgroundColor: UIColor.blue_Point)
    
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
    private lazy var tableView: RecordTableView = {
        let tableView = RecordTableView()
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
    
    /// Record데이터가 없을 때 보이는 뷰
    private lazy var noDataView: NoRecordDataView = {
        let view = NoRecordDataView(
            frame: .zero,
            nodataEnum: .record_Main)
        return view
    }()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    
    // ********** 데이터 관련 **********
    /// 오늘의 기록을 담는 배열
    private var todayRecords_Array: [Record] = [Record]()
    /// 다른 날의 기록을 담는 배열
    private var anotherDayRecords_Array: [Record] = [Record]()
    /// 오늘 날짜를 바탕으로 현재 테이블뷰에 어떤 데이터를 띄울지 판단하는 변수
    private var currentArray: [Record] {
        return self.isToday             // 오늘이라면
        ? self.todayRecords_Array       // true  -> 오늘 배열에서 문서ID 가져오기
        : self.anotherDayRecords_Array  // false -> 다른 날 배열에서 문서ID 가져오기
    }
    /// 셀을 통해 상세 작성 화면으로 넘어간 후 수정 or 삭제 했을 때, 셀을 업데이트 or 삭제 를 하기 위한 index 표시
    private var currentIndex: Int = 0
    
    
    // ********** 날짜 관련 **********
    /// 오늘인지 아닌지 판단하는 변수
    private var isToday: Bool = true
    
    /**
     *** 코드 리팩토링 사항
        - [날짜: Record] 타입의 전역변수를 만들기
     -> 달력을 누르면 전역변수에 있는지 먼저 확인
        -> 있으면 - 해당 데이터 사용
        -> 없으면 - fetch_API
     -------------> 똑같은 날을 다시 누를 때마다 호출이 되는 것을 방지
     */
    /// 오늘이 아닌 다른 날짜를 적어둠 -> 누를 때마다 호출이 되는 상황 방지
    private var anotherDay_Date: Date?
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()          // UI 설정
        self.configureAutoLayout()  // 오토레이아웃 설정
        self.configureAction()      // 액션 설정
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataUpdate.dataUpdateStart = true
        // 새로 로그인했다면
        if DataUpdate.login {
            // 오늘 기록 가져오기
            self.fetchRecords_API()
            DataUpdate.login = false
        }
        // 시간 형식이 바뀌었다면 -> 테이블뷰 리로드
        if Format.dateFormat_Record_Time {
            self.tableView.reloadData()
            Format.dateFormat_Record_Time = false
        }
        // 날짜 형식이 바뀌었다면 -> 캘린더 리로드
        if Format.dateFormat_Record_Date {
            self.calendar.configureDateFormat()
            Format.dateFormat_Record_Date = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 데이터가 생성 or 업데이트 되었다면
        if DataUpdate.imageDataUpdate {
            // 다른 화면으로 이동 못 하도록 로딩뷰 띄우기
            self.showLoading(true)
            DataUpdate.imageDataUpdate = false
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DataUpdate.dataUpdateStart = false
    }
}
    
    
    














    
    
    
// MARK: - 화면 설정

extension RecordController {
    
    // MARK: - UI 설정
    private func configureUI() {
        // 배경 색상 설정
        self.view.backgroundColor = UIColor.blue_Base
        // 네비게이션 타이틀뷰(View) 설정
        self.navigationItem.titleView = self.navTitle
        // 네비게이션 타이틀(String) 설정
        self.setNavTitle(date: Date())
        // dateLabel에 날짜 띄우기
        self.configureDate()
        // 달력에 오늘 날짜 선택 (원래 기본적으로 선택 안 되어있음)
        self.calendar.calendar.select(Date())
        
        // 코너 둥글게 설정
        [self.tableView].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
        self.plusBtn.clipsToBounds = true
        self.plusBtn.layer.cornerRadius = 65 / 2
    }
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        [self.stackView,
         self.scrollView,
         self.plusBtn].forEach { view in
            self.view.addSubview(view)
        }
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.tableView)
        self.scrollView.addSubview(self.noDataView)
        
        
        // ********** 오토레이아웃 설정 **********
        // 달력 높이 설정
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
            make.width.height.equalTo(65)
        }
        // 네비게이션 타이틀
        self.navTitle.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(100)
        }
        // 데이터가 없을 때 나오는 레이블
        self.noDataView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.tableView)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        // 뷰 액션 설정
        // 위로 스와이프 -> 달력 크기 변경(주)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(_:)))
            swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        // 아래로 스와이프 -> 달력 크기 변경(월)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(_:)))
            swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        // 플러스 버튼 액션 설정 -> EasyWritingScreenView 이동
        self.plusBtn.addTarget(self, action: #selector(self.plusBtnTapped), for: .touchUpInside)
    }
}
















// MARK: - API

extension RecordController {
    
    // MARK: - 기록 가져오기_API
    private func fetchRecords_API(date: Date = Date()) {
        Record_API.shared.fetchRecode(writing_Type: .record_CellTapped,
                                      date: date) { result in
            switch result {
            case .success(let recordArray):
                self.fetchCell(recordArray: recordArray)
            case .failure(_):
                self.customAlert(alertEnum: .fetchError) { _ in }
                break
            }
        }
    }
    
    // MARK: - 기록 삭제_API
    private func deleteRecord_API(documentID: String?,
                                  imageDictionary: [String: String]?) {
        // DB - 삭제
        Record_API.shared.deleteRecord(documentID: documentID,
                                       imageDictionary: imageDictionary) { result in
            switch result {
            case .success(_):
                // 셀 삭제
                self.deleteCell()
                break
            case .failure(_):
                self.customAlert(alertEnum: .deleteError) { _ in }
                break
            }
        }
    }
}










// MARK: - 셀 업데이트

extension RecordController {
    
    // MARK: - 셀 추가
    /// 셀 그리고 배열 데이터 추가
    private func addRecord(record: Record) {
        self.isToday
        // 오늘이라면 -> 오늘 배열에 넣기
        ? self.todayRecords_Array.insert(record, at: 0)
        // 오늘이 아니라면 -> 다른 날 배열에 넣기
        : self.anotherDayRecords_Array.insert(record, at: 0)
        
        // 테이블뷰 특정 셀 리로드
        self.tableView.insertRows(
            at: [IndexPath(row: 0, section: 0)],
            with: .none)
        self.showLoading(false)
    }
    
    // MARK: - 셀 업데이트
    /// 셀 그리고 배열 데이터 업데이트
    private func updateCell(record: Record) {
        // 오늘이라면 -> 오늘 배열에 저장
        if self.isToday {
            self.todayRecords_Array[self.currentIndex] = record
        // 오늘이 아니라면 -> 다른 날 배열에 저장
        } else {
            self.anotherDayRecords_Array[self.currentIndex] = record
        }
        // 해당 셀만 리로드
        self.tableView.reloadRows(at: [IndexPath(row: self.currentIndex,
                                                 section: 0)],
                                  with: .automatic)
        self.showLoading(false)
    }
    
    // MARK: - 셀 삭제
    /// 셀 그리고 배열에서 데이터 삭제
    private func deleteCell() {
        _ = self.isToday
        // 오늘이라면 -> 오늘 배열에서 삭제
        ? self.todayRecords_Array.remove(at: self.currentIndex)
        // 오늘이 아니라면 -> 다른 날 배열에서 삭제
        : self.anotherDayRecords_Array.remove(at: self.currentIndex)
        
        // 테이블뷰의 해당 셀 리로드
        self.tableView.deleteRows(at: [IndexPath(row: self.currentIndex,
                                                 section: 0)],
                                  with: .automatic)
    }
    
    // MARK: - 셀 가져오기
    /// 가져온 데이터를 셀 그리고 배열에 넣기
    private func fetchCell(recordArray: [Record]) {
        // 오늘이라면 -> 오늘 배열에 저장
        if self.isToday {
            self.todayRecords_Array = recordArray
        // 오늘이 아니라면 -> 다른 날 배열에 저장
        } else {
            self.anotherDayRecords_Array = recordArray
        }
        // 테이블뷰 리로드
        self.tableView.reloadData()
    }
}




















// MARK: - 셀렉터

extension RecordController {
    
    // MARK: - 위/아래 스와이프
    /// 스와이프를 하면 자동으로 불리는 메서드
    @objc private func swipeAction(_ swipe: UISwipeGestureRecognizer) {
        // 어느 방향으로 스와이프 했는지 확인
        swipe.direction == .up
        // up: 달력을 한 주만 보이도록 설정
        ? self.calendar.swipeAction(up: true)
        // down: 달력을 한 달 전체가 보이도록 설정
        : self.calendar.swipeAction(up: false)
    }
    
    // MARK: - 간편 작성 화면 이동 (플러스 버튼)
    /// 플러스 버튼을 누르면 간편 작성 화면으로 이동
    @objc private func plusBtnTapped() {
        let vc = EasyWritingScreenController()
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        // 달력의 선택된 날짜를 보냄 (데이터 생성할 때 사용)
        vc.todayDate = self.calendar.returnSelectedDate
        // 화면 이동
        self.present(vc, animated: false)
    }
}










// MARK: - 액션

extension RecordController {
    
    // MARK: - 네비게이션 타이틀 재설정
    /// 선택된 날짜에 따라 네비게이션 타이틀을 설정하는 메서드
    private func setNavTitle(date: Date = Date(),
                             navEnum: NavTitleSetEnum = .yyyy년M월) {
        // 네비게이션 타이틀 설정
        self.navTitle.attributedText = self.configureNavTitle(
            navEnum.record_String,
            navTitleSetEnum: navEnum,
            date: date)
    }
    
    // MARK: - 날짜 설정 액션
    /// dateLabel에 날짜를 띄우는 메서드
    func configureDate(selectedDate: Date = Date()) {
        // 현재 달력에 선택된 날짜를 보내기
        self.dateView.configureDate(selectedDate: selectedDate)
    }
    
    // MARK: - 상세 작성 화면으로 이동
    /// 상세 작성 화면으로 이동
    private func pushToDetailWritingScreen(selectedRecord: Record? = nil,
                                           easyViewString: String? = nil) {
        // 기록 화면에서 넘어갔다는 표시
        let vc = DetailWritingScreenController()
        // ********** 공통 **********
        // 상세 작성뷰에서 탭바 없애기
        vc.hidesBottomBarWhenPushed = true
        // 델리게이트 설정
        vc.delegate = self
        // 기록 확인 화면에서 사용할 해당 날짜 배열
        vc.todayRecords = self.currentArray
        
        // ********** 확장 버튼(플러스 버튼)을 통해 넘어가는 경우 **********
            // -> 아무 것도 적혀있지 않다면
        if easyViewString != nil {
            // 데이터를 생성할 때 사용할 날짜 넘기기
            vc.todayDate = self.calendar.returnSelectedDate
            // 문자열 가져가기
            vc.diaryTextView.text = easyViewString
            vc.detailViewMode = .record_plusBtn
        
        // ********** 셀 클릭하여 이동 **********
        } else {
            // 선택한 셀의 데이터 넘겨주기(파라미터로 받은 데이터)
            vc.selectedRecord = selectedRecord
            vc.detailViewMode = .record_CellTapped
        }
        
        // 화면 이동
        self.navigationController?.pushViewController(vc, animated: true)
    }
}




















// MARK: - 켈린더 델리게이트
extension RecordController: CalendarDelegate {
    /// 날짜를 선택하면 호출
    func selectDate(date: Date) {
        // 데이트뷰의 선택한 날짜로 레이블을 변경
        self.configureDate(selectedDate: date)
        // 선택된 날짜
        let selectedDate = date.reset_time() // 다른 날
        let todayDate = Date().reset_time() // 오늘
        
        // ********** 선택된 날짜가 오늘이라면 **********
        if todayDate == selectedDate {
            // 오늘 기록을 테이블뷰에 표시 (fetch할 필요 X)
            self.isToday = true
            self.tableView.reloadData()

        // ********** 선택된 날짜가 오늘이 아니라면 **********
            // 1. 가장 최근에 선택되었던 날이라면
                // -> 기존에 가지고 있던 데이터 표시
        } else if self.anotherDay_Date == selectedDate {
            self.isToday = false
            self.tableView.reloadData()
            
            // 2. 가장 최근에 선택된 날이 아니라면
                // -> 데이터를 fetch
        } else {
            self.isToday = false
            // 선택한 날짜의 데이터 가져오기
            self.fetchRecords_API(date: date)
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
        // 네비게이션 타이틀 바꾸기
        self.setNavTitle(date: date)
    }
}










// MARK: - 스크롤뷰
extension RecordController: UIScrollViewDelegate {
    /// 스크롤이 끝났을 때
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        // 스크롤이 끝났을 때 -> Offset이 0이라면
        if scrollView.contentOffset.y == 0
            && self.calendar.currentCalendarScope() == .week {
            // 한 달 전체가 보이도록 설정
            self.calendar.calendar.setScope(.month, animated: true)
        }
    }

    /// 스크롤을 시작했을 때 (아래로)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // -> 달력이 월 별 달력이라면
        if self.calendar.currentCalendarScope() == .month {
            // -> 주간 달력으로 바꿈
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
        let trash = UIContextualAction(style: .normal, title: nil) { (_, _, success: @escaping (Bool) -> Void) in
            // 셀의 인덱스 저장
            self.currentIndex = indexPath.row
            // 배열 가져오기 가져오기
            let record: Record = self.currentArray[indexPath.row]
            // DB삭제 + 셀 삭제 + 이미지 삭제
            self.deleteRecord_API(documentID: record.documentID,
                                  imageDictionary: record.imageUrl)
            success(true)
        }
        // 이미지 및 색상 설정
            trash.image = UIImage(systemName: "trash")
            trash.backgroundColor = .systemPink
        // action배열 인덱스 0이 왼쪽에 붙어서 나옴
        let swipeAction = UISwipeActionsConfiguration(actions:[trash])
            swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    
    /// 셀을 눌렀을 때
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        // 클릭한 셀의 index 저장
        self.currentIndex = indexPath.row
        // 오늘인지 아닌지 판단 + 해당 배열 가져오기
        let array: [Record] = self.currentArray
        // 상세 작성 화면으로 이동
        self.pushToDetailWritingScreen(selectedRecord: array[indexPath.row])
    }
}

extension RecordController: UITableViewDataSource {
    /// 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        // 현재 데이터가 0개라면
        self.noDataView.isHidden = self.currentArray.count == 0
        ? false // noDataView 보이게 하기
        : true  // noDataView 숨기기
        
        // 셀의 개수 설정
        // 오늘인지 아닌지 판단 + 배열 가져오기 -> 한 번에
        return self.currentArray.count
    }
    
    /// 셀 구현
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.recodeTableCell,
            for: indexPath) as! RecordTableViewCell
        
        // 오늘인지 아닌지 판단 및 데이터 보내기
        cell.cellRecord = self.currentArray[indexPath.row]
        return cell
    }
}










// MARK: - 간편 작성 화면 델리게이트
extension RecordController: EasyWritingScreenDelegate {
    /// 확대 버튼을 누르면 -> 상세 작성 화면으로 이동
    func expansionBtnTapped(context: String?) {
        self.pushToDetailWritingScreen(easyViewString: context)
    }
    
    /// 데이터를 생성하면 -> DB + 셀에 추가
    func createRecord(record: Record?) {
        // record가 있다면 == 데이터 생성에 성공했다면
        if let record = record {
            self.addRecord(record: record)
            
        // record가 없다면 == 데이터 생성에 실패했다면
        } else {
            self.customAlert(alertEnum: .createError) { _ in }
        }
    }
}



// MARK: - 상세 작성 화면 델리게이트

extension RecordController: DetailWritingScreenDelegate {
    func createRocord(record: Record?) {
        // record가 있다면 == 데이터 생성에 성공했다면
        if let record = record {
            self.addRecord(record: record)
        // record가 없다면 == 데이터 생성에 실패했다면
        } else {
            self.customAlert(alertEnum: .createError) { _ in
                self.showLoading(false)
            }
        }
    }
    
    func updateRecord(record: Record?) {
        // record가 있다면 == 데이터 업데이트에 성공했다면
        if let record = record {
            self.updateCell(record: record)
            
        // record가 없다면 == 데이터 업데이트에 실패했다면
        } else {
            self.customAlert(alertEnum: .updateError) { _ in
                self.showLoading(false)
            }
        }
    }
    
    func deleteRecord(success: Bool) {
        _ = success
        // True == 삭제 성공
        ? self.deleteCell()
        // False == 삭제 실패
        : self.customAlert(alertEnum: .deleteError) { _ in }
    }
}
