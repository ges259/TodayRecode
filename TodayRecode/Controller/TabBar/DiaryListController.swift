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
    private lazy var navTitle: UILabel = {
        let lbl = UILabel()
            lbl.numberOfLines = 2
            lbl.textAlignment = .center
            lbl.textColor = .black
        return lbl
    }()
    
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
    /// 콜렉션뷰의 넓이
    private lazy var collectionViewWidth: CGFloat = self.collectionView.frame.width
    
    //    private lazy var currentItem: Int = 0
    
    var currentPage: CGFloat = 0
    
    private var num: [String] = ["1일", "2일", "3일", "4일", "5일", "6일", "7일", "8일"]
    /// 캘린더 IsHidden
    private lazy var calendarIsHidden: Bool = true
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}




















// MARK: - 화면 설정

extension DiaryListController {
    
    // MARK: - UI 설정
    private func configureUI() {
        // 네비게이션 타이틀 설정
        self.navigationItem.titleView = self.navTitle
        // MARK: - Fix
        self.setNavTitle(year: "2023년", month: "10월")
        
        // 코너 둥글게 설정
        self.calendar.clipsToBounds = true
        self.calendar.layer.cornerRadius = 10
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        [self.backgroundImg,
         self.collectionView,
         self.stackView].forEach { view in
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
        self.calendar.translatesAutoresizingMaskIntoConstraints = false
        self.calendarHeight = self.calendar.heightAnchor.constraint(equalToConstant: 280)
        self.calendarHeight?.isActive = true
        
//        self.calendar.snp.makeConstraints { make in
//            make.height.greaterThanOrEqualTo(50)
//        }
        
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
        // 네비게이션 타이틀
        self.navTitle.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(100)
        }
    }
}










// MARK: - 액션

extension DiaryListController {
    // self.scrollToTop(index: self.num.count - 1)
    // MARK: - 콜렉션뷰 아이템 이동 액션
    /// 달력의 날짜를 선택하면 해당 아이템으로 이동
    private func scrollToTop(index: Int) {
//        self.collectionView.scrollToItem(
//            at: IndexPath(row: index, section: 0),
//            at: .right,
//            animated: false)
    }
    
    
    
    // MARK: - 네비게이션 타이틀 설정 액션
    private func setNavTitle(year: String, month: String) {
        self.navTitle.attributedText = self.configureNavTitle(
            "하루 일기",
            year: year,
            month: month)
    }
}




















// MARK: - 켈린더 델리게이트
extension DiaryListController: CalendarDelegate {
    /// 달력의 날짜를 누르면 호출
    func selectDate(date: Date) {
        self.dateView.configureDate(selectedDate: date)
    }
    /// 달력의 형태(week <-> month)가 바뀌면  높이가 업데이트된다.
    func heightChanged(height: CGFloat) {
        
    }
    /// month가 바뀌었을 때 호출
    func monthChanged(year: String, month: String) {
        self.setNavTitle(year: year, month: month)
    }
}
















// MARK: - 콜렉션뷰 델리게이트
extension DiaryListController: CollectionViewDelegate {
    func itemDeleteBtnTapped() {
        print(#function)
    }
    func itemTapped() {
        let vc = DetailWritingScreenController()
            // 상세 작성뷰에서 탭바 없애기
            vc.hidesBottomBarWhenPushed = true
            vc.detailViewMode = .diary
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionViewScrolled() {
        print(#function)
    }
}
