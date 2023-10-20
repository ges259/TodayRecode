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
        
    
    // MARK: - 프로퍼티
    
    private lazy var diaryListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout())
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    
    
    
    
    
    // MARK: - 라이프 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    
    
    
    // MARK: - 화면 설정
    private func configureUI() {
        //
        self.view.backgroundColor = .red
        
        
        // 콜렉션뷰
        self.diaryListCollectionView.register(
            DiaryListCollectionViewCell.self,
            forCellWithReuseIdentifier: Identifier.diaryListCollectionViewCell)


    }
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        [self.dateView,
         self.diaryListCollectionView].forEach { view in
            self.view.addSubview(view)
        }
        
        // ********** 오토레이아웃 설정 **********
        self.dateView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }
        
        self.diaryListCollectionView.snp.makeConstraints { make in
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
extension DiaryListController: UICollectionViewDelegateFlowLayout {
    /// 아이템의 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 15
    }
    /// 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.diaryListCollectionViewCell,
            for: indexPath)
        
        
        return  cell
    }
    
    
    
    /// 아이템의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.width - 30 - 15 - 1) / 2
        
        return CGSize(width: width, height: width)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}




extension DiaryListController: UICollectionViewDelegate, UICollectionViewDataSource {
    
}
