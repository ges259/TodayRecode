//
//  RecodeTableViewCell.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/15.
//

import UIKit
import SnapKit

final class RecodeTableViewCell: UITableViewCell {
    
    
    // MARK: - Layout
    let contextTextLbl: UILabel = {
        let lbl = UILabel()
        
        lbl.font = .systemFont(ofSize: 13)
        lbl.textColor = .black
        lbl.text = "2333safdlhdasl;h;lsdkjs;dflajfsd;akj;lsdafsdafasdfsadsdffasfdsafdasdfsda"
        lbl.numberOfLines = 3
        
        
        return lbl
    }()
    
    let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 10)
        lbl.text = "0000000000"
        lbl.textColor = .systemGray
        
        return lbl
    }()
    
    
    let recodeImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "blueSky")
        
        
        return img
    }()
    
    lazy var stackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [self.contextTextLbl,
                                                 self.timeLabel])
        stv.axis = .vertical
        stv.spacing = 5
        stv.alignment = .leading
//        stv.distribution = .fill
        
        return stv
    }()
    
    
    
    
    
    
    
    
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.configureUI()
        self.configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - 화면 구성
    private func configureUI() {
        self.backgroundColor = UIColor.customWhite5
        self.selectionStyle = .none
    }
    
    
    
    
    // MARK: - 오토레이아웃
    private func configureLayout() {
        
        self.addSubview(self.recodeImage)
        self.recodeImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-5)
            make.trailing.equalTo(self.recodeImage.snp.leading).offset(-15)
        }
    }
}
