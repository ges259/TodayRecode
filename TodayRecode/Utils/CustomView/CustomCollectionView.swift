//
//  ImageCollectionView.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/18.
//

import UIKit
import SnapKit

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
