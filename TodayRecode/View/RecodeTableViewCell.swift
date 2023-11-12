//
//  RecodeTableViewCell.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/15.
//

import UIKit
import SnapKit

final class RecodeTableViewCell: UITableViewCell {
    
    // MARK: - 레이아웃
    /// 기록 내용 레이블
    private lazy var contextTextLbl: UILabel = {
        let lbl = UILabel.configureLbl(
            font: UIFont.systemFont(ofSize: 13),
            textColor: UIColor.black)
        
            lbl.numberOfLines = 3
        return lbl
    }()
    
    /// 날짜 레이블
    private lazy var timeLabel: UILabel = UILabel.configureLbl(
        font: .systemFont(ofSize: 10),
        textColor: .systemGray)
    
    /// 기록 이미지
    private lazy var recodeImage: UIImageView = {
        let img = UIImageView()
            img.clipsToBounds = true
            img.contentMode = .scaleAspectFill
        return img
    }()
    
    /// 기록 내용 레이블 및 날짜 레이블 --- 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.contextTextLbl,
                           self.timeLabel],
        axis: .vertical,
        spacing: 5,
        alignment: .leading,
        distribution: .fill)
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    var cellRecord: Record? {
        didSet { self.settingContext(record: self.cellRecord) }
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

extension RecodeTableViewCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.backgroundColor = UIColor.customWhite5
        self.selectionStyle = .none
    }
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureLayout() {
        // ********** addSubview 설정 **********
        [self.recodeImage,
         self.stackView].forEach { view in
            self.addSubview(view)
        }
        
        // ********** 오토레이아웃 설정 **********
        // 이미지
        self.recodeImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.width.height.equalTo(35)
            make.centerY.equalToSuperview()
        }
        // 기록 레이블
        self.contextTextLbl.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(10)
        }
        // 시간 레이블
        self.timeLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-5)
            make.trailing.equalTo(self.recodeImage.snp.leading).offset(-10)
        }
    }
}










// MARK: - 액션

extension RecodeTableViewCell {
    
    // MARK: - 기록 내용 설정
    func settingContext(record: Record?) {
        // 옵셔널 바인딩
        guard let record = record else { return }
        // 본문 내용 설정
        let attrString = NSMutableAttributedString(string: record.context)

        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3

            attrString.addAttribute(
                NSAttributedString.Key.paragraphStyle,
                value: paragraphStyle,
                range: NSMakeRange(0, attrString.length))
        self.contextTextLbl.attributedText = attrString
        
        
        // 시간 레이블 설정
        self.timeLabel.text = Date.DateLabelString(date: record.date)
        
        
        // 이미지가 있다면
        if !record.imageUrl.isEmpty {
            self.recodeImage.isHidden = false
            guard let url = record.imageUrl.first else { return }
            
            ImageUploader.shared.loadImageView(
                with: [url]) { image in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        self.recodeImage.image = image.first
                    }
                }
        } else {
            self.recodeImage.isHidden = true
        }
    }
}
