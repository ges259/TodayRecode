//
//  ImageCollectionView.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/18.
//

import UIKit
import SnapKit

final class ImageCollectionView: UIView {
    
    // MARK: - 레이아웃
    lazy var collectionView: UICollectionView = {
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
    
    /// Record데이터가 없을 때 보이는 뷰
    private lazy var noDataView: NoRecordDataView = {
        let view = NoRecordDataView(
            frame: .zero,
            nodataEnum: .diary)
            view.backgroundColor = .customWhite5
        return view
    }()
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private lazy var collectionViewWidth: CGFloat = self.collectionView.frame.width
    
    var collectionViewEnum: CollectionViewEnum?
    
    weak var delegate: CollectionViewDelegate?
    
    /// 콜렉션뷰의 현재 페이지를 표시
    var currentPage: CGFloat = 0
    
    /// collectionViewEnum이 .photoList일 때
    var currentImage: [UIImage] = [] {
        didSet { self.collectionView.reloadData() }
    }
    /// collectionViewEnum이 .diaryList일 때
    var currentDiary: [Date] = [] {
        didSet { self.collectionView.reloadData() }
    }
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    init(frame: CGRect, collectionViewEnum: CollectionViewEnum) {
        super.init(frame: frame)
        
        self.collectionViewEnum = collectionViewEnum
        
        self.configureUI()
        self.configureAutoLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
    
    
    
    
    
    


    
// MARK: - 화면 설정

extension ImageCollectionView {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.collectionView.register(
            ImageCollectionViewCell.self,
            forCellWithReuseIdentifier: Identifier.imageListCollectionViewCell)
    }
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.addSubview(self.collectionView)
        self.addSubview(self.noDataView)
        
        // ********** 오토레이아웃 설정 **********
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 데이터가 없을 때 나오는 레이블
        self.noDataView.snp.makeConstraints { make in
            make.edges.equalTo(self.collectionView)
        }
    }
}
    
    
    
    
    
    
    
    


// MARK: - 액션

extension ImageCollectionView {
    
    // MARK: - 아이템 이동
    func moveToItem(date: Date) {
        
        guard let dateType = date.reset_time() else { return }
        
        if let index = self.currentDiary.firstIndex(of: dateType) {
            // 자꾸 index가 -1되어 스크롤되는 상황이 발생하여 해당 코드 처럼 바꿈
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.collectionView.scrollToItem(
                    at: IndexPath(row: index, section: 0),
                    at: .right,
                    animated: true)
            }
        }
    }
}


















// : UICollectionViewDelegate
// MARK: - 콜렉션뷰 델리게이트
extension ImageCollectionView {
    /// 아이템간 좌우 간격
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    /// 아이템을 선택했을 때
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if self.collectionViewEnum == .diaryList {
            self.delegate?.itemTapped(index: indexPath.item)
        }
    }
}


extension ImageCollectionView: UICollectionViewDataSource {
    /// 콜렉션뷰 아이템 개수 설정
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if self.collectionViewEnum == .photoList {
            self.noDataView.isHidden = true
            return self.currentImage.count
            
        } else {
            self.noDataView.isHidden = self.currentDiary.count == 0
            ? false
            : true
            return self.currentDiary.count
        }
    }
    /// 콜렉션뷰 설정
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.imageListCollectionViewCell,
            for: indexPath) as! ImageCollectionViewCell
        
        cell.delegate = self
        cell.collectionViewEnum = self.collectionViewEnum
        
        // 상세 작성 화면 콜렉션뷰
        if self.collectionViewEnum == .photoList {
            cell.imageView.image = self.currentImage[indexPath.row]
            
        // 일기 목록 화면 콜렉션뷰
        } else {
            cell.dateLbl.text = Date.dateReturn_Custom(
                todayFormat: .d일,
                UTC_Plus9: false,
                date: self.currentDiary[indexPath.row])
        }
        return cell
    }
}
extension ImageCollectionView: UICollectionViewDelegateFlowLayout {
    /// 아이템 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.frame.width,
                      height: self.frame.height)
    }
}


























// MARK: - 스크롤뷰 델리게이트
extension ImageCollectionView {
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
        
        
        // 한 페이지씩 움직일 수 있도록 설정
        // 페이지 이동 (+델리게이트)
        if self.currentPage > index {
            self.currentPage -= 1
        } else if currentPage < index {
            self.currentPage += 1
        }
        
        // 현재 페이지 저장
        index = self.currentPage
        if self.collectionViewEnum == .diaryList {
            // MARK: - Fix
            // 현재 페이지 = diaryArray의 index값
            /*
             1. 스크롤을 한다.
             2. 현재 페이지가 바뀐다.
             3. delegate를 통해 현재 페이지(currentPage)값을 넘김
             4. 캘린더 바꾸기 (선택된 날짜)
                -> 바뀐 현재 페이지값에 맞추기 (diaryArray가 1일 -> 5일이라면 캘린더도 5일로 이동)
             5. 날짜뷰(dateView)의 레이블 바꾸기
             */
            self.delegate?.collectionViewScrolled(index: Int(self.currentPage))
        }
        // 스크롤 속도가 줄어들어 정지될 때 예상되는 위치 설정
        // 즉, 멈출 페이지
        targetContentOffset.pointee = CGPoint(
            x: index * cellWidth - scrollView.contentInset.left,
            y: scrollView.contentInset.top)
    }
}







// MARK: - 이미지 콜렉션뷰 델리게이트
extension ImageCollectionView: ImageCollectionViewDelegate {
    /// 셀에서 삭제 버튼이 눌렸을 때, 다시 delegate를 통해서 보냄
    func cellDeleteBtnTapped() {
        self.delegate?.itemDeleteBtnTapped(index: Int(self.currentPage))
    }
}













final class CustomCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        self.register(ImageCollectionViewCell.self,
                      forCellWithReuseIdentifier: Identifier.imageListCollectionViewCell)
        
//        self.dataSource = self
//        self.delegate = self
        // 배경 설정
        self.backgroundColor = UIColor.clear
        // 콜렉션뷰 옆으로 넘길 때 속도 설정
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        // 인디케이터 없애기
        self.showsHorizontalScrollIndicator = false
        // 콜렉션뷰가 바운스되지 않도록 설정
        self.bounces = false
    }
}
