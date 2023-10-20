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
    
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        
            collectionView.dataSource = self
            collectionView.delegate = self
        
            collectionView.backgroundColor = UIColor.clear
        
        return collectionView
    }()
    
    
    
    
    // MARK: - 프로퍼티
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    
    
    
    // MARK: - 화면 설정
    private func configureUI() {
        self.navigationItem.title = "하루 일기"
        // 콜렉션뷰
        self.collectionView.register(
            DiaryListCollectionViewCell.self,
            forCellWithReuseIdentifier: Identifier.diaryListCollectionViewCell)
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        [self.backgroundImg,
         self.dateView,
         self.collectionView].forEach { view in
            self.view.addSubview(view)
        }
        
        // ********** 오토레이아웃 설정 **********
        // 배경화면
        self.backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 날짜 뷰
        self.dateView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }
        /// 콜렉션 뷰
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.dateView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(self.dateView)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
}










// MARK: - 콜렉션뷰 델리게이트
extension DiaryListController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,  UICollectionViewDataSource {
    /// 아이템의 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    /// 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.diaryListCollectionViewCell,
            for: indexPath) as! DiaryListCollectionViewCell
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.width - 20 - 15) / 2
        return CGSize(width: size, height: size)
    }
    
    
    
    /// 아이템간 상하 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    /// 아이템간 좌우 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    /// 뷰와 콜렉션뷰 사이의 간격 설정
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
//    }
}
