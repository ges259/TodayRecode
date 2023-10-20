//
//  ImageCollectionView.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/18.
//

import UIKit
import SnapKit

final class ImageCollectionView: UICollectionView {
    
    // MARK: - 레이아웃
    
    
    

    
    
    
    // MARK: - 프로퍼티
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 화면 설정
    private func configureUI() {
        self.register(ImageCollectionViewCell.self,
                      forCellWithReuseIdentifier: Identifier.imageCollectionViewCell)
        
        self.delegate = self
        self.dataSource = self
        
        
        
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
}



















extension ImageCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did_Select_Item_At")
    }
}


extension ImageCollectionView: UICollectionViewDataSource {
    /// 콜렉션뷰 아이템 개수 설정
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    /// 콜렉션뷰 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.imageCollectionViewCell,
            for: indexPath) as! ImageCollectionViewCell
        
        
        return cell
    }
}



extension ImageCollectionView: UICollectionViewDelegateFlowLayout {
    /// 아이템 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let width = self.frame.width
        
        return CGSize(width: width, height: width)
    }
}
