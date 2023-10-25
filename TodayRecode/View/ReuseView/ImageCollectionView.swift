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
    
    

    
    
    
    // MARK: - 프로퍼티
    private lazy var collectionViewWidth: CGFloat = self.collectionView.frame.width
    
    //    private lazy var currentItem: Int = 0
    
    var currentPage: CGFloat = 0 {
        didSet { self.delegate?.collectionViewScrolled() }
    }
    
    
    var collectionViewEnum: CollectionViewEnum?
    
    weak var delegate: CollectionViewDelegate?
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureAutoLayout()
        self.configureAction()
        self.configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 화면 설정
    private func configureUI() {
        self.collectionView.register(
            ImageCollectionViewCell.self,
            forCellWithReuseIdentifier: Identifier.imageListCollectionViewCell)
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.addSubview(self.collectionView)
        
        // ********** 오토레이아웃 설정 **********
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
}



















// MARK: - 콜렉션뷰 델리게이트
extension ImageCollectionView: UICollectionViewDelegate {
    /// 아이템간 좌우 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    /// 아이템을 선택했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.itemTapped()
    }
}


extension ImageCollectionView: UICollectionViewDataSource {
    /// 콜렉션뷰 아이템 개수 설정
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    /// 콜렉션뷰 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.imageListCollectionViewCell,
            for: indexPath) as! ImageCollectionViewCell
        
//        cell.delegate = self
        
        
            cell.collectionViewEnum = self.collectionViewEnum
        
        cell.delegate = self
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
    /*
     // 어디서 어디로 스크롤하는지 확인
     let scrolled = scrollView.contentOffset.x > targetContentOffset.pointee.x
     if scrollView.contentOffset.x > targetContentOffset.pointee.x {
         // 왼쪽 -> 오른쪽으로 갈 때 자연스럽게
         index = floor(index)

     } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
         // 오른쪽 -> 왼쪽으로 갈 때 자연스럽게
         index = ceil(index)
     }
     */
}







// MARK: - 이미지 콜렉션뷰 델리게이트
extension ImageCollectionView: ImageCollectionViewDelegate {
    //
    func deleteBtnTapped() {
        self.delegate?.itemDeleteBtnTapped()
    }
}
