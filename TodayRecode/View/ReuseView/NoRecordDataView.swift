//
//  NoRecordDataView.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/11/06.
//

import UIKit
import SnapKit

final class NoRecordDataView: UIView {
    
    // MARK: - 레이아웃
    /// 텍스트
    private lazy var noDataLbl: UILabel = UILabel.navTitleLbl(
        font: .systemFont(ofSize: 15))
    
    /// 플러스버튼 이미지
    private lazy var plusBtn: UIImageView = {
        let img = UIImageView()
        img.tintColor = .blue_Point
        return img
    }()
        
    /// 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.plusBtn,
                           self.noDataLbl],
        axis: .vertical,
        spacing: 9,
        alignment: .center,
        distribution: .fill)
    
    
    
    

    
    
    
    
    
    // MARK: - 라이프사이클
    init(frame: CGRect, nodataEnum: NoDataEnum) {
        super.init(frame: frame)
        
        self.configureAutoLayout(nodataEnum: nodataEnum) // 오토레이아웃 설정
        self.configureUI(nodataEnum: nodataEnum) // 레이블의 텍스트 설정
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    // MARK: - 레이블의 텍스트 설정
    /// NodataEnum에 따라 레이블의 텍스트를 바꿈
    private func configureUI(nodataEnum: NoDataEnum) {
        self.backgroundColor = .white_Base
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.isHidden = true
        
        self.noDataLbl.attributedText = NSMutableAttributedString.setSpacing(
            context: nodataEnum.lblString,
            setSpacing: 4)
        // attributedText를 설정한 후 다시 textAlignment를 설정해 주어야 정상 작동(?)
        self.noDataLbl.textAlignment = .center
        self.plusBtn.image = nodataEnum.systemImg
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout(nodataEnum: NoDataEnum) {
        
        // ********** addSubview 설정 **********
        self.addSubview(self.stackView)
        
        // ********** 오토레이아웃 설정 **********
        // 이미지 -> 상황에 따라 다르게 설정
        if nodataEnum == .diary {
            self.plusBtn.snp.makeConstraints { make in
                make.width.equalTo(120)
                make.height.equalTo(100)
            }
        } else {
            self.plusBtn.snp.makeConstraints { make in
                make.width.equalTo(80)
                make.height.equalTo(100)
            }
        }
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
