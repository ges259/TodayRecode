//
//  DiaryListController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit

final class DiaryListController: UIViewController {
    
    // MARK: - 레이아웃
    /// 네비게이션 타이틀 레이블
    private lazy var navTitle: UILabel = UILabel.navTitleLbl()
    
    /// 날짜 뷰
    private lazy var dateView: DateView = DateView()
    
    /// 콜렉션뷰
    private lazy var collectionView: CustomCollectionView = {
        let collectionView = CustomCollectionView()
            collectionView.delegate = self
            collectionView.dataSource = self
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
        tintColor: UIColor.white,
        backgroundColor: UIColor.blue_Point)
    
    /// Record데이터가 없을 때 보이는 뷰
    private lazy var noDataView: NoRecordDataView = {
        let view = NoRecordDataView(
            frame: .zero,
            nodataEnum: .diary)
        return view
    }()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    /// 셀의 넓이
    private lazy var collectionViewWidth = self.collectionView.frame.width
    /// 셀의 높이
    private lazy var collectionViewHeight = self.collectionView.frame.height
    
    /// 콜렉션뷰의 현재 페이지
    private lazy var currentPage: Int = 0 {
        didSet {
            // 스크롤을 한다면 -> (일기 기록이 있다면)
            if self.diaryArray.count != 0 {
                // 스크롤된(도착) 날짜 가져오기
                let date = self.diaryArray[self.currentPage].date
                // -> 달력의 날짜 바꾸기
                self.calendar.calendar.select(date)
            }
        }
    }
    
    /// Record데이터 배열
    private lazy var diaryArray = [Record]() {
        didSet {
            // 날짜(일기를 쓴 날) -> 캘린더에 전달
            self.deliverTheDate()
            // 오늘 일기를 썼는지 확인 -> 썼다면 플러스 버튼 숨기기
            self.checkTodayDiary()
        }
    }
    /// Record데이터 배열의 날짜를 모아둔 배열
    private lazy var diaryDateArray = [Date]()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchDiaryArray()      // 일기 가져오기
        self.configureUI()          // UI 설정
        self.configureAutoLayout()  // 오토레이아웃 설정
        self.configureAction()      // 액션 설정
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 날짜 형식이 바뀌었다면 -> 캘린더 리로드
        if Format.dateFormat_Diary_Date {
            self.calendar.configureDateFormat()
            Format.dateFormat_Diary_Date = false
        }
    }
}




















// MARK: - 화면 설정

extension DiaryListController {
    
    // MARK: - UI 설정
    private func configureUI() {
        // 배경 색상 설정
        self.view.backgroundColor = UIColor.blue_base
        // 네비게이션 타이틀뷰(View) 설정
        self.navigationItem.titleView = self.navTitle
        // 네비게이션 타이틀(String) 설정
        self.setNavTitle() // -> 오늘로 설정
        // 코너 둥글게 설정
        self.plusBtn.clipsToBounds = true
        self.plusBtn.layer.cornerRadius = 65 / 2
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        [self.noDataView,
         self.collectionView,
         self.stackView,
         self.plusBtn].forEach { view in
            self.view.addSubview(view)
        }
        // ********** 오토레이아웃 설정 **********
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
            make.width.height.equalTo(65)
        }
        // 네비게이션 타이틀
        self.navTitle.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(100)
        }
        // 데이터 없을 때 나오는 뷰
        self.noDataView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.collectionView)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
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
    private func setNavTitle(date: Date = Date(),
                             navEnum: NavTitleSetEnum = .yyyy년M월) {
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
        // Record 날짜 배열에 저장
        self.diaryDateArray = diaryDateArray
        // 캘린더뷰에는 날짜 보내기 (일기를 쓴 날 표시하기 위함)
        self.calendar.diaryArray = diaryDateArray
    }
    
    
    
    // MARK: - 아이템 이동
    func moveToItem(date: Date, animated: Bool = true) {
        // 선택된 날짜
        guard let dateType = date.reset_time() else { return }
        // 날짜뷰 텍스트 해당 날짜로 바꾸기
        self.dateView.configureDate(selectedDate: date)
        // 콜렉션뷰 이동
        if let index = self.diaryDateArray.firstIndex(of: dateType) {
            // 자꾸 index가 -1되어 스크롤되는 상황이 발생하여 해당 코드 처럼 바꿈
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.collectionView.scrollToItem(
                    at: IndexPath(row: index, section: 0),
                    at: .right,
                    animated: animated)
            }
        }
    }
    
    
    
    // MARK: - 플러스 버튼 액션
    @objc private func plusBtnTapped() {
        // 오늘 일기가 없다면 -> 새로 생성
        self.goToDetailWriting()
    }
    
    
    
    // MARK: - 상세 작성 화면 이동
    private func goToDetailWriting(index: Int? = nil) {
        // 일기 목록 화면에서 넘어갔다는 표시
        let vc = DetailWritingScreenController()
            // 일기 목록 화면에서 들어갔다고 설정
            vc.detailViewMode = .diary
            // 델리게이트
            vc.delegate = self
            // 상세 작성 화면의 탭바 없애기
            vc.hidesBottomBarWhenPushed = true
        
        
        // ********** 아이템 선택한 경우 **********
        // 아이템(셀) 선택을 했을 경우 -> 데이터 보내기
        if let index = index {
            vc.selectedRecord = self.diaryArray[index]
            // 셀에 적힌 날짜의 기록 가져오기
            vc.fetchRecords_API(date: self.calendar.returnSelectedDate ?? Date())
            
        // ********** 플러스 버튼을 선택한 경우 **********
        } else {
            // 오늘 기록 가져오기
            vc.fetchRecords_API(date: Date())
        }
        // 화면 이동
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // MARK: - 오늘 일기를 썼는지 확인
    private func checkTodayDiary() {
        // 배열의 마지막 날
        let arrayLast = self.diaryArray.last?.date.reset_time()
        // 오늘
        let today = Date().reset_time()
        // 서로 비교
        self.plusBtn.isHidden = arrayLast == today
        ? true  // -> 같다면 일기를 썼다는 표시 -> 플러스버튼 숨기기
        : false // -> 다르다면 일기를 쓰지 않았다는 표시 -> 플러스버튼 보이게 하기
    }
}










// MARK: - API

extension DiaryListController {
    
    // MARK: - 이번달 일기 가져오기
    private func fetchDiaryArray(date: Date = Date()) {
        Record_API.shared.fetchRecode(writing_Type: .diary,
                                      date: date) { result in
            switch result {
            case .success(let recordArray):
                // 가져온 데이터 저장
                self.diaryArray = recordArray
                self.collectionView.reloadData()
                
                // 데이터가 있다면
                if !recordArray.isEmpty {
                    // 가장 최근에 쓴 일기 == (배열의 마지막 날짜)
                    let index = recordArray.count - 1
                    // 마지막 날짜의 인덱스 저장
                    self.currentPage = index
                    // 해당 날짜로 콜렉션뷰 자동 스크롤
                    self.moveToItem(date: recordArray[index].date, animated: false)
                }
                break
                
            case .failure(_):
                self.apiFail_Alert()
                break
            }
        }
    }
}




















// MARK: - 켈린더 델리게이트
extension DiaryListController: CalendarDelegate {
    /// 달력의 날짜를 누르면 호출
    func selectDate(date: Date) {
        // -> dateView의 날짜 레이블 바꾸기
        self.dateView.configureDate(selectedDate: date)
        
        // ********** 데이터가 있을 때 **********
        if self.diaryArray.count != 0 {
            // 선택한 날짜에 일기를 썼는지 확인
                // 썼다면 -> 몇 번째 인지 가져오기
            let index = self.diaryDateArray.firstIndex { record in
                record == date
            }
            
            // ********** 선택한 날짜에 일기를 썼다면 **********
            if let index = index {
                // 현재 인덱스 저장
                self.currentPage = index
                // 찾은 인덱스로 이동
                self.moveToItem(date: self.diaryDateArray[index])
            }
        }
    }
    
    /// 달력의 형태(week <-> month)가 바뀌면  높이가 업데이트된다.
    func heightChanged(height: CGFloat) {
        // 아무거나 넣어놨음
        self.setNavTitle()
    }
    
    /// month가 바뀌었을 때 호출
    func monthChanged(date: Date) {
        self.setNavTitle(date: date)
    }
}




















// MARK: - 상세 작성 화면 델리게이트
extension DiaryListController: DetailWritingScreenDelegate {
    func createRocord(record: Record?) {
        if let record = record {
            let last = self.diaryArray.count
            // 현재 배열 리로드
            self.diaryArray.insert(record, at: last)
            // 콜렉션뷰에 추가
            self.collectionView.insertItems(at: [IndexPath(item: last,
                                                           section: 0)])
            // 날짜 선택
            self.currentPage = last
            // 오늘 날짜로 콜렉션뷰 이동
            self.moveToItem(date: record.date)
            
        } else {
            self.apiFail_Alert()
        }
    }
    
    func updateRecord(record: Record?) {
        if let record = record {
            // 콜렉션뷰 업데이트, 날짜는 변경X
            self.diaryArray[self.currentPage] = record
            // 해당 콜렉션뷰 리로드
            self.collectionView.reloadItems(at: [IndexPath(item: self.currentPage,
                                                           section: 0)])
            
        } else {
            self.apiFail_Alert()
        }
    }
    
    func deleteRecord(success: Bool) {
        if success {
            // 데이터 삭제
            self.diaryArray.remove(at: self.currentPage)
            self.collectionView.deleteItems(at: [IndexPath(item: self.currentPage,
                                                           section: 0)])
            // 남아있는 데이터가 있다면
            if self.diaryArray.count != 0 {
                let nextIndex = self.diaryArray.count - 1
                // 배열의 마지막이라면
                self.currentPage = nextIndex
                // 날짜뷰 날짜 바꾸기
                self.dateView.configureDate(
                    selectedDate: self.diaryArray[nextIndex].date)
            }
        } else {
            self.apiFail_Alert()
        }
    }
}




















// MARK: - 콜렉션뷰 델리게이트
extension DiaryListController: UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {
    /// 아이템 개수
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        // 오늘 일기를 쓴 데이터가
        self.noDataView.isHidden = self.diaryArray.count == 0
        ? false // 있다면 -> 숨기기
        : true // 없다면 -> 이번 달에 작성한 일기가 없다고 띄우기
        
        return self.diaryArray.count
    }
    
    /// 아이템 표현?
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.imageListCollectionViewCell,
            for: indexPath) as! ImageCollectionViewCell
            
        // 상세 작성 화면
        cell.collectionViewEnum = .diaryList
        
        cell.dateLbl.text = Date.dateReturn_Custom(
            todayFormat: .d일,
            date: self.diaryArray[indexPath.row].date)
        
        
        // ********** 이미지 관련 **********
        // 셀 이미지 초기화
        cell.imageView.image = nil
        // 셀에 이미지 넣기
        if !diaryArray.isEmpty {
            // 일기 배열에서 가장 첫번째 이미지 가져오기
            if let url = self.diaryArray[indexPath.row].imageUrl.first?.value {
                // 이미지 로드
                ImageUploader.shared.loadImageView(
                    with: [url], completion: { image in
                        // 셀에 이미지 넣기
                        cell.imageView.image = image?.first
                    })
            }
        }
        return cell
    }
    
    /// 아이템을 선택했을 때
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        self.goToDetailWriting(index: indexPath.row)
    }
    
    
    /// 아이템간 좌우 간격
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    /// 아이템 크기 설정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewWidth,
                      height: self.collectionViewHeight)
    }
}









// MARK: - 콜렉션뷰 스클로뷰
extension DiaryListController {
    /// 콜렉션뷰에서 스크롤이 끝났을 때
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView, // 스크롤뷰(컬렉션뷰)
        withVelocity velocity: CGPoint, // 스크롤하다 터치 해제 시 속도
        targetContentOffset: UnsafeMutablePointer<CGPoint>) // 스크롤 속도가 줄어들어 정지될 때 예상되는 위치
    {
        // 현재 x의 offset위치
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        // 스크롤뷰의 크기 + 왼쪽 insets값
        let cellWidth = self.collectionViewWidth + 20
        
        // 스크롤한 위치값
        var index = scrolledOffsetX / cellWidth
        
        // 이동하는 위치 가져오기
        let scrolledX = scrollView.contentOffset.x
        let pointeeX = targetContentOffset.pointee.x
        
        // 어디서 어디로 스크롤하는지 확인
        if scrolledX > pointeeX {
            // 왼쪽 -> 오른쪽으로 갈 때 자연스럽게
            index = floor(index)
        } else if scrolledX < pointeeX {
            // 오른쪽 -> 왼쪽으로 갈 때 자연스럽게
            index = ceil(index)
        } else {
            index = round(index)
        }
        
        let page = CGFloat(self.currentPage)
        
        // 한 페이지씩 움직일 수 있도록 설정
        // 페이지 이동 (+델리게이트)
        if page > index {
            self.currentPage -= 1
        } else if page < index {
            self.currentPage += 1
        }
        
        // 현재 페이지 저장
        index = CGFloat(self.currentPage)
        // 스크롤 속도가 줄어들어 정지될 때 예상되는 위치 설정
        // 즉, 멈출 페이지
        targetContentOffset.pointee = CGPoint(
            x: index * cellWidth - scrollView.contentInset.left,
            y: scrollView.contentInset.top)
    }
}
