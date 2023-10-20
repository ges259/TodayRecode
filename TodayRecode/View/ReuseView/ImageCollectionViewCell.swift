//
//  ImageCollectionViewCell.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/19.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - 레이아웃
    /// 이미지뷰
    private lazy var imageView: UIImageView = UIImageView(
        image: UIImage(named: "cat"))
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    // MARK: - 화면 설정
    private func configureUI() {
        
    }
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.imageView)
        // 이미지뷰
        self.imageView.snp.makeConstraints { make in
            make.width.height.equalTo(self.imageView.snp.width)
        }
    }
    // MARK: - 액션 설정
    private func configureAction() {
        
    }
    
    
    
    
    
}
