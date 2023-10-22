//
//  DiaryListController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit

final class DiaryListController: UIViewController {
    
    // MARK: - 레이아웃
    private lazy var dateView: DateView = DateView()
        
    
    
    /// 배경 뷰
    private lazy var backgroundImg: UIImageView = UIImageView(
        image: UIImage.blueSky)
    
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
    
    private lazy var calendar: CalendarView = {
        let calendar = CalendarView()
            calendar.delegate = self
        return calendar
    }()
    /// 달력의 높이 제약
    private var calendarHeight: NSLayoutConstraint?
    
    
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.calendar,
                           self.dateView],
        axis: .vertical,
        spacing: 5,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    // MARK: - 프로퍼티
    private lazy var viewWidth: CGFloat = self.collectionView.frame.width
    
//    private lazy var currentItem: Int = 0 {
//        didSet {
//            self.dateView.date = self.currentItem
//
//            collectionView.layoutIfNeeded()
//        }
//    }
    
    var currentPage: CGFloat = 0
    
    private var num: Int = 32
    private lazy var isHidden: Bool = false
    
    
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
    
    // MARK: - 화면 설정
    private func configureUI() {
        self.navigationItem.title = "하루 일기"
//        self.calendar.isHidden = true
        
        self.calendar.clipsToBounds = true
        self.calendar.layer.cornerRadius = 10
        
        
        // 콜렉션뷰
        self.collectionView.register(
            DiaryListCollectionViewCell.self,
            forCellWithReuseIdentifier: Identifier.diaryListCollectionViewCell)
        
        
        self.collectionView.clipsToBounds = true
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
        /// 콜렉션 뷰
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
    
    
    
    
    
    // MARK: - 캘린더 액션
    @objc private func calendarTapped() {
        UIView.animate(withDuration: 0.5) {
            self.calendar.isHidden.toggle()

            if self.isHidden {
                self.collectionView.frame.origin.y -= 340
            } else {
                self.collectionView.frame.origin.y += 340
            }
            self.view.layoutIfNeeded()
        }
        self.isHidden.toggle()
        
        
    }
    
    
    
    
    
    
    
    
    
    // MARK: - 날짜 설정
    /// dateLabel에 날짜를 띄우는 메서드
    /// 기본값: 오늘 날짜를 띄운다.
    /// - Parameter selectedDate: 선택된 날짜를 띄운다.
    func configureDate(selectedDate: Date = Date()) {
        self.dateView.configureDate(selectedDate: selectedDate)
    }
}










// MARK: - 콜렉션뷰 델리게이트
extension DiaryListController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,  UICollectionViewDataSource {
    /// 아이템의 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 31
    }
    /// 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.diaryListCollectionViewCell,
            for: indexPath) as! DiaryListCollectionViewCell
        
        self.num -= 1
        cell.dateLbl.text = "\(self.num)일"
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
        
        
        return CGSize(width: self.viewWidth, height: self.collectionView.frame.height)
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





// MARK: - 스크롤뷰 델리게이트
extension DiaryListController {
    /// 스크롤이 시작되었을 때
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = (scrollView.contentOffset.x) / (self.viewWidth + 15)
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
        let cellWidth = self.viewWidth + 20
        
        // 스크롤한 위치값
        var index = scrolledOffsetX / cellWidth
        
        // 어디서 어디로 스크롤하는지 확인
        let scrolled = scrollView.contentOffset.x > targetContentOffset.pointee.x
        if scrolled {
            // 왼쪽 -> 오른쪽으로 갈 때 자연스럽게
            index = floor(index)
        } else if scrolled {
            // 오른쪽 -> 왼쪽으로 갈 때 자연스럽게
            index = ceil(index)
        } else {
            // 움직이지 않음
            index = round(index)
        }
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






// MARK: - 켈린더 델리게이트
extension DiaryListController: CalendarDelegate {
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
