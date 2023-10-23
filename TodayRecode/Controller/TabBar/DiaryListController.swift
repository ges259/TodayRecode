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
    private lazy var NavTitle: UILabel = {
        let lbl = UILabel()
            lbl.numberOfLines = 2
            lbl.textAlignment = .center
            lbl.textColor = .black
        return lbl
    }()
    
    /// 날짜 뷰
    private lazy var dateView: DateView = DateView()
    
    /// 콜렉션뷰
    private lazy var collectionView: UICollectionView = {
        // 수평스크롤 설정
        let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
        // 콜렉션뷰 설정
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout)
        
            collectionView.dataSource = self
            collectionView.delegate = self
            // 배경 설정
            collectionView.backgroundColor = UIColor.clear
        
            // 콜렉션뷰 옆으로 넘길 때 속도 설정
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
            // 인디케이터 없애기
            collectionView.showsHorizontalScrollIndicator = false
            // 콜렉션뷰가 바운스되지 않도록 설정
            collectionView.bounces = false
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
    private lazy var calendarIsHidden: Bool = false
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureNavBtn()
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
        self.navigationItem.titleView = self.NavTitle
        // MARK: - Fix
        self.setNavTitle(month: "10월")
        
        // 코너 둥글게 설정
        self.calendar.clipsToBounds = true
        self.calendar.layer.cornerRadius = 10
        
        // 콜렉션뷰
        self.collectionView.register(
            DiaryListCollectionViewCell.self,
            forCellWithReuseIdentifier: Identifier.diaryListCollectionViewCell)
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
            make.height.equalTo(40)
        }
        // 달력
        self.calendar.translatesAutoresizingMaskIntoConstraints = false
        self.calendarHeight = self.calendar.heightAnchor.constraint(equalToConstant: 280)
        self.calendarHeight?.isActive = true
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
    }
    
    // MARK: - 네비게이션 아이템 설정
    private func configureNavBtn() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.calendar,
            style: .done,
            target: self,
            action: #selector(self.calendarTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
}










// MARK: - 액션

extension DiaryListController {
    // self.scrollToTop(index: self.num.count - 1)
    // MARK: - 콜렉션뷰 아이템 이동 액션
    /// 달력의 날짜를 선택하면 해당 아이템으로 이동
    private func scrollToTop(index: Int) {
        self.collectionView.scrollToItem(
            at: IndexPath(row: index, section: 0),
            at: .right,
            animated: false)
    }
    
    
    
    // MARK: - 캘린더 액션
    /// 네비게이션 오른쪽 버튼을 누르면 호출되는 메서드
    @objc private func calendarTapped() {
        UIView.animate(withDuration: 0.5) {
            // 캘린더 토글 (숨김 Or 보이게)
            self.calendar.isHidden.toggle()
            // 캘린더가 숨겨져있다면 -> 캘린더 보이게 하기
            if self.calendarIsHidden {
                self.collectionView.frame.origin.y -= 340
                
            // 캘린더가 화면에 보인다면 -> 캘린더 숨기기
            } else {
                self.collectionView.frame.origin.y += 340
            }
            // 뷰 다시 그리기
            self.view.layoutIfNeeded()
        }
        self.calendarIsHidden.toggle()
    }
    
    
    // MARK: - 네비게이션 타이틀 설정 액션
    private func setNavTitle(month: String) {
        self.NavTitle.attributedText = self.configureNavTitle("하루 일기", month: month)
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
    func monthChanged(month: String) {
        self.setNavTitle(month: month)
    }
}










// MARK: - 스크롤뷰 델리게이트
extension DiaryListController {
    /// 스크롤이 시작되었을 때
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = (scrollView.contentOffset.x) / (self.collectionViewWidth + 15)
        print(Int(offset))
        
        
        // 달력을 바꿈
        // offset에 따라 -> Array[] (일기를 쓴 날)
//        if self.currentItem != Int(offset) {
//            self.currentItem = Int(offset)
//            print(Int(offset))
//        }
    }
    
    
    
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
        
//        // 어디서 어디로 스크롤하는지 확인
//        let scrolled = scrollView.contentOffset.x > targetContentOffset.pointee.x
//        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
//            // 왼쪽 -> 오른쪽으로 갈 때 자연스럽게
//            index = floor(index)
//
//        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
//            // 오른쪽 -> 왼쪽으로 갈 때 자연스럽게
//            index = ceil(index)
//        }
        
        // 한 페이지씩 움직일 수 있도록 설정
        if self.currentPage > index {
            self.currentPage -= 1
        } else if currentPage < index {
            self.currentPage += 1
        }
        // 현재 페이지 저장
        index = self.currentPage
        // 스크롤 속도가 줄어들어 정지될 때 예상되는 위치 설정
        // 즉, 멈출 페이지
        targetContentOffset.pointee = CGPoint(
            x: index * cellWidth - scrollView.contentInset.left,
            y: scrollView.contentInset.top)
    }
}










// MARK: - 콜렉션뷰 델리게이트
extension DiaryListController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,  UICollectionViewDataSource {
    /// 아이템의 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.num.count
    }
    /// 셀 설정
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.diaryListCollectionViewCell,
            for: indexPath) as! DiaryListCollectionViewCell
            
            cell.dateLbl.text = self.num[indexPath.row]
        return  cell
    }
    /// 셀을 클릭했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailWritingScreenController()
            // 상세 작성뷰에서 탭바 없애기
            vc.hidesBottomBarWhenPushed = true
            vc.detailViewMode = .diary
            vc.detailEditMode = .writingMode
        self.navigationController?.pushViewController(vc, animated: true)
        
        // MARK: - Fix
        /*
         추가해야할 것
         - 오늘인지
            - 아직 일기를 쓰지 않았는지   -> 수정 모드로 진입
            - 이미 일기를 썼는지        -> 저장 모드로 진입
         - 오늘이 아닌지                -> 저장 모드로 진입
         */
    }
    
    
    
    /// 아이템의 크기
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let offset = (collectionView.contentOffset.y) / (self.viewWidth + 15)
        
        
        return CGSize(width: self.collectionViewWidth, height: self.collectionView.frame.height)
    }
    /// 아이템간 좌우 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    /// 아이템간 상하 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
