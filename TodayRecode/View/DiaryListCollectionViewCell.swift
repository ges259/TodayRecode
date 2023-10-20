//
//  DiaryListCollectionViewCell.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/19.
//

import UIKit

final class DiaryListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - 레이아웃
    /// 이미지뷰
    private lazy var imageView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "cat"))
        // image: UIImage(named: "cat")
            img.backgroundColor = UIColor.customWhite5
            img.contentMode = .scaleAspectFill
        return img
    }()
    /// 날짜 레이블
    private lazy var dateLbl: UILabel = UILabel.configureLbl(
        font: UIFont.boldSystemFont(ofSize: 30),
        textColor: UIColor.black)
    
    
    
    
    // MARK: - 프로퍼티
    
    
    
    
    
    
    
    
    // MARK: - 라이프 사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
        self.configureImage()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    // MARK: - 화면 설정
    private func configureUI() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
        
        // MARK: - Fix
        self.dateLbl.text = "10"
        
    }
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.addSubview(self.imageView)

        self.addSubview(self.dateLbl)
        
        
        // ********** 오토레이아웃 설정 **********
        // 이미지뷰
        self.imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 날짜 레이블
        self.dateLbl.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
    }
    // MARK: - 액션 설정
    private func configureAction() {
        self.backgroundColor = .blue
        
        
    }
    
    
    // MARK: - 이미지 설정
    /// 이미지가 있다면 alpha값을 0.5로 설정
    /// 이미지가 없다면 셀에 배경 색 넣기
    private func configureImage() {
        // 이미지가 있다면 -> alpha값을 0.5로 설정
        self.imageView.alpha = 0.5
        
        // 이미지가 없다면 -> 색갈 넣기
//        self.backgroundColor = .customblue3
    }
    
    
    
    
}
