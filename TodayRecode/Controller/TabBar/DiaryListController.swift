//
//  DiaryListController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit

final class DiaryListController: UIViewController {
    
    // MARK: - 레이아웃
    /// 배경 뷰
    private lazy var backgroundImg: UIImageView = UIImageView(
        image: UIImage.blueSky)
    
    /// 네비게이션 타이틀 레이블
    private lazy var navTitle: UILabel = UILabel.navTitleLbl()
    
    /// 날짜 뷰
    private lazy var dateView: DateView = DateView()
    
    /// 콜렉션뷰
    private lazy var collectionView: ImageCollectionView = {
        let collectionView = ImageCollectionView()
        collectionView.collectionViewEnum = .diaryList
        collectionView.delegate = self
        return collectionView
    }()
    
    /// 달력
    private lazy var calendar: CalendarView = {
        let calendar = CalendarView()
            calendar.delegate = self
        return calendar
    }()
    
    /// 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.calendar,
                           self.dateView],
        axis: .vertical,
        spacing: 5,
        alignment: .fill,
        distribution: .fill)
    
    /// +버튼
    private lazy var plusBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.plus,
        tintColor: UIColor.black,
        backgroundColor: UIColor.white)
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    /// 콜렉션뷰의 넓이
    private lazy var collectionViewWidth: CGFloat = self.collectionView.frame.width
    
    /// 캘린더 IsHidden
    private lazy var calendarIsHidden: Bool = true
    
    private lazy var currentPage: Int = 0
    
    /// Record데이터 배열
    private lazy var diaryArray: [Record] = [] {
        // 날짜(일기를 쓴 날)를 콜렉션뷰 / 달력에 전달
        didSet { self.deliverTheDate() }
    }

    
    
    
    
    
    
    
    
    
    // MARK: - 라이프 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchDiaryArray()      // 일기 가져오기
        self.configureUI()          // UI 설정
        self.configureAutoLayout()  // 오토레이아웃 설정
        self.configureAction()      // 액션 설정
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}




















// MARK: - 화면 설정

extension DiaryListController {
    
    // MARK: - UI 설정
    private func configureUI() {
        // 네비게이션 타이틀뷰(View) 설정
        self.navigationItem.titleView = self.navTitle
        // 달력에 오늘 날짜 선택 (원래 기본적으로 선택 안 되어있음)
//        self.calendarDateSelect()
        
        // 네비게이션 타이틀(String) 설정
        self.setNavTitle() // -> 오늘로 설정
        
        // 코너 둥글게 설정
        self.plusBtn.clipsToBounds = true
        self.plusBtn.layer.cornerRadius = 58 / 2
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        [self.backgroundImg,
         self.collectionView,
         self.stackView,
         self.plusBtn].forEach { view in
            self.view.addSubview(view)
        }
        // ********** 오토레이아웃 설정 **********
        // 배경화면
        self.backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 날짜 뷰
        self.dateView.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        // 달력
        self.calendar.snp.makeConstraints { make in
            make.height.equalTo(280)
        }
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        // 콜렉션 뷰
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.stackView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(self.stackView)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
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
        self.plusBtn.addTarget(self, action: #selector(self.plusBtnTapped), for: .touchUpInside)
    }
}










// MARK: - 액션

extension DiaryListController {
    
    // MARK: - 네비게이션 타이틀 설정 액션
    private func setNavTitle(date: Date = Date()) {
        let navEnum: NavTitleSetEnum = .yyyy년M월
        self.navTitle.attributedText = self.configureNavTitle(
            navEnum.diary_String,
            navTitleSetEnum: navEnum,
            date: date)
    }
    
    
    // MARK: - 날짜 다른 뷰로 전달
    private func deliverTheDate() {
        // Record 배열에서 날짜만 가져오기
        let diaryDateArray: [Date] = self.diaryArray.map { record in
            record.date.reset_time() ?? Date()
        }
        
        // 캘린더뷰에는 날짜만 가면 됨
            // dateArray그대로 보내고 이벤트 표시할 때 바꾸는 것으로
        self.calendar.diaryArray = diaryDateArray
        
        // MARK: - Fix
        // 콜렉션뷰는 날짜 및 이미지url, month가 가야함
        self.collectionView.currentDiary = diaryDateArray
    }
    
    
    // MARK: - 플러스 버튼 액션
    @objc private func plusBtnTapped() {
        self.goToDetailWriting()
    }
    
    
    // MARK: - 상세 작성 화면 이동
    private func goToDetailWriting(index: Int? = nil) {
        // 일기 목록 화면에서 넘어갔다는 표시
        let vc = DetailWritingScreenController(detailViewMode: .diary)
            // 델리게이트
            vc.delegate = self
            // 상세 작성 화면의 탭바 없애기
            vc.hidesBottomBarWhenPushed = true
        
        // 아이템 선택
        if let index = index {
            vc.selectedRecord = self.diaryArray[index]
            // 상세 작성 화면에 날짜 전달
            vc.todayDate = self.diaryArray[self.currentPage].date
        // 플러스 버튼
        } else {
            // 상세 작성 화면에 오늘 날짜 전달
            vc.todayDate = Date()
        }
        // 화면 이동
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    // MARK: - 달력 날짜 바꾸기
    private func calendarDateSelect(date: Date) {
        // 달력에 오늘 날짜 선택
        self.calendar.calendar.select(date)
        // 해당 날짜로 콜렉션뷰 이동
        self.collectionView.moveToItem(date: date)
    }
}










// MARK: - API
extension DiaryListController {
    private func fetchDiaryArray(date: Date = Date()) {
        Record_API.shared.fetchRecode(writing_Type: .diary,
                                      date: date) { result in
            switch result {
            case .success(let recordArray):
                self.diaryArray = recordArray
                
                
                // 마지막 날 인덱스
                self.currentPage = recordArray.count - 1
                // 마지막 날 날짜
                let lastIndexDate: Date = recordArray[self.currentPage].date
                // 마지막날 선택되도록 설정
                self.calendarDateSelect(date: lastIndexDate)
                
                
                break
            case .failure(_):
                // Fix
                break
            }
        }
    }
}

















// MARK: - 켈린더 델리게이트
extension DiaryListController: CalendarDelegate {
    /// 달력의 날짜를 누르면 호출
    func selectDate(date: Date) {
        // 3. DiaryListController에서 dateView의 configureDate()로 전달
            // -> dateView의 날짜 레이블 바꾸기
        self.dateView.configureDate(selectedDate: date)
        // 4. self.currentDiary.firstIndex(of: Date)로 몇 번째 인덱스인지 찾기
            // -> 찾은 인덱스로 이동 ( moveToItem(index:_) )
        self.calendarDateSelect(date: date)
    }
    /// 달력의 형태(week <-> month)가 바뀌면  높이가 업데이트된다.
    func heightChanged(height: CGFloat) {
        
    }
    /// month가 바뀌었을 때 호출
    func monthChanged(date: Date) {
        self.setNavTitle(date: date)
    }
}
















// MARK: - 콜렉션뷰 델리게이트
extension DiaryListController: CollectionViewDelegate {
    func itemDeleteBtnTapped(index: Int) {
        print(#function)
    }
    func itemTapped() {
        self.goToDetailWriting(index: self.currentPage)
    }
    func collectionViewScrolled(index: Int) {
        print(index)
        self.currentPage = index
    }
}





// MARK: - 상세 작성 화면 델리게이트
extension DiaryListController: DetailWritingScreenDelegate {
    func createRocord(record: Record?) {
        if let record = record {
            self.diaryArray.insert(record, at: self.diaryArray.count)
            self.calendarDateSelect(date: record.date)
            
        } else {
            print("create_Error")
        }
    }
    
    func updateRecord(record: Record?) {
        if let record = record {
            self.diaryArray[self.currentPage] = record
            self.calendarDateSelect(date: record.date)
            
        } else {
            print("update_Error")
        }
    }
    
    func deleteRecord(bool: Bool) {
        if bool {
            self.calendarDateSelect(date: self.diaryArray[self.currentPage].date)
            self.diaryArray.remove(at: self.currentPage)
            
        } else {
            print("delete_Error")
        }
    }
}
