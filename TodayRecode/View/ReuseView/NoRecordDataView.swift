//
//  NoRecordDataView.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/11/06.
//

import UIKit
import SnapKit

final class NoRecordDataView: UIView {
    
    
    private lazy var noDataLbl: UILabel = {
        let lbl = UILabel.navTitleLbl(font: .systemFont(ofSize: 15))
            lbl.text = "아직 작성한 기록이 없어요\n +버튼을 눌러 오늘을 기록해보세요!"
        return lbl
    }()
    
    private lazy var plusBtn: UIImageView = {
        let img = UIImageView(image: UIImage(systemName: "list.bullet.clipboard"))
        img.tintColor = .customblue3
        return img
    }()
    
    
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
        // 오토레이아웃 설정
        self.configureAutoLayout()
        // 레이블의 텍스트 설정
        self.configureUI(nodataEnum: nodataEnum)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    // MARK: - 레이블의 텍스트 설정
    /// NodataEnum에 따라 레이블의 텍스트를 바꿈
    private func configureUI(nodataEnum: NoDataEnum) {
        self.noDataLbl.text = nodataEnum.lblString
    }
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.addSubview(self.stackView)
        
        // ********** 오토레이아웃 설정 **********
        self.plusBtn.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(100)
        }
        self.stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
