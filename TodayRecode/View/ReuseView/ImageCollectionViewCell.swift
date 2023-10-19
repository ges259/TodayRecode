//
//  ImageCollectionViewCell.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/19.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    
    
    
    
    /// 이미지뷰
    private lazy var imageView: UIImageView = UIImageView(
        image: UIImage(named: "cat"))
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - 화면 설정
    private func configreUI() {
        
    }
    // MARK: - 오토레이아웃 설정
    private func configreAutoLayout() {
        self.addSubview(self.imageView)
        // 이미지뷰
        self.imageView.snp.makeConstraints { make in
            make.width.height.equalTo(self.imageView.snp.width)
        }
    }
    // MARK: - 액션 설정
    private func configreAction() {
        
    }
    
    
    
    
    
}
