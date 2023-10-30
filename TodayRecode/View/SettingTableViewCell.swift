//
//  SettingTableViewCell.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/25.
//

import UIKit
import SnapKit

final class SettingTableViewCell: UITableViewCell {
    /// 시스템 이미지
    private lazy var systemImg: UIImageView = {
        let img = UIImageView()
        img.tintColor = UIColor.black
        return img
    }()
    
    /// 레이블
    private let mainLabel: UILabel = UILabel.configureLbl(
        font: UIFont.systemFont(ofSize: 13))
    
    /// 레이블
    private lazy var subLabel: UILabel = UILabel.configureLbl(
        font: UIFont.systemFont(ofSize: 13))
    
    
    
    // MARK: - 프로퍼티
    var settingTableEnum: SettingTableEnum? {
        didSet {
            self.systemImg.image = self.settingTableEnum?.image
            self.mainLabel.text = self.settingTableEnum?.text
            // MARK: - Fix
            self.subLabel.text = "일요일 시작"
        }
    }

    
    
    // MARK: - 라이프사이클
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
        self.configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}










// MARK: - 화면 설정

extension SettingTableViewCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = UIColor.customWhite5
        self.selectionStyle = .none
    }
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureLayout() {
        // ********** addSubview 설정 **********
        [self.systemImg,
         self.mainLabel,
         self.subLabel].forEach { view in
            self.addSubview(view)
        }
        
        // ********** 오토레이아웃 설정 **********
        self.systemImg.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(21)
            make.centerY.equalToSuperview()
        }
        self.mainLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.systemImg.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        self.subLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-20)
            make.centerY.equalToSuperview()
        }
    }
}
