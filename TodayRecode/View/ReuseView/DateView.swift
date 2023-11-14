//
//  DateView.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//

import UIKit
import SnapKit

final class DateView: UIView {
    
    // MARK: - 레이아웃
    private lazy var dateLabel: UILabel = UILabel.configureLbl(
        font: UIFont.boldSystemFont(ofSize: 12))
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.configureAutoLayout()
        
        // MARK: - Fix
        self.configureDate()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
 








// MARK: - 화면 설정
    
extension DateView {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = UIColor.customWhite5
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.dateLabel)
        // 날짜 레이블
        self.dateLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    
    
    // MARK: - 날짜 설정
    func configureDate(selectedDate: Date = Date()) {
        self.dateLabel.text = Date.dateReturn_Custom(todayFormat: .M월d일,
                                                     date: selectedDate)
    }
}
