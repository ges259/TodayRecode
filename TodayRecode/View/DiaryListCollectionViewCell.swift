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
        let img = UIImageView()
            img.backgroundColor = UIColor.customWhite5
            img.contentMode = .scaleAspectFill
        return img
    }()
    /// 날짜 레이블
    lazy var dateLbl: UILabel = {
        let lbl = UILabel.configureLbl(
            font: UIFont.boldSystemFont(ofSize: 30),
            textColor: UIColor.black)
        
            lbl.textAlignment = .center
        return lbl
    }()
    
    
    private lazy var whiteCustomView: UIView = UIView.backgroundView(
        color: UIColor.customWhite5)
    
    
    
    // MARK: - 프로퍼티
    
    private lazy var layoutArray = [self.imageView,
                                    self.whiteCustomView,
                                    self.dateLbl]
    
    
    
    
    
    
    // MARK: - 라이프 사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.configureAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    // MARK: - 화면 설정
    private func configureUI() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
//        self.imageView.clipsToBounds = true
//        self.imageView.layer.cornerRadius = 10
//        self.layoutArray.forEach { view in
//            view.clipsToBounds = true
//            view.layer.cornerRadius = 10
//        }
        
        // MARK: - Fix
        self.dateLbl.text = "10"
        self.imageView.image = UIImage(named: "cat")
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // 레이아웃 설정
        self.layoutArray.forEach { view in
            // ********** addSubview 설정 **********
            self.addSubview(view)
            
            // ********** 오토레이아웃 설정 **********
            view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}
