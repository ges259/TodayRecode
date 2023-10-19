//
//  InputAccessoryCustomView.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//

import UIKit
import SnapKit

final class InputAccessoryCustomView: UIView {
    
    // MARK: - 레이아웃
    // 버튼
    private let cameraBtn: UIButton = UIButton.configureBtn(
        image: .camera,
        tintColor: UIColor.btnGrayColor)
    
    private let albumBtn: UIButton = UIButton.configureBtn(
        image: .album,
        tintColor: UIColor.btnGrayColor)
    
    private let sendButton: UIButton = UIButton.configureBtn(
        image: .send,
        tintColor: UIColor.white,
        backgroundColor: UIColor.btnGrayColor)

    // 레이블
    private lazy var dateLbl: UILabel = UILabel.configureLbl(
        font: UIFont.systemFont(ofSize: 13),
        textColor: UIColor.btnGrayColor)
    
    
    // 스택뷰
    private lazy var horizontalStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [self.cameraBtn,
                                                 self.albumBtn,
                                                 self.dateLbl, self.sendButton])
            stv.axis = .horizontal
            stv.spacing = 12
            stv.alignment = .center
//            stv.distribution = .fill
        return stv
    }()
    
    
    
    
    
    // MARK: - 프로퍼티
    var delegate: AccessoryViewDelegate?

    
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    private func configureUI() {
        self.dateLbl.text = self.todayReturn(todayFormat: .detaildayAndTime_Mdahm)
        
        
        self.sendButton.layer.cornerRadius = 10
        self.sendButton.clipsToBounds = true
    }
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.horizontalStackView)
//        self.addSubview(self.sendButton)
        // 카메라 버튼
        self.cameraBtn.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        // 앨범 버튼
        self.albumBtn.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        // 날짜 레이블
        self.dateLbl.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        // 보내기 버튼
        self.sendButton.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().offset(-10)
//            make.top.equalToSuperview().offset(10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        // 스택뷰 (카메라/앨범/날짜 / 보내기)
        self.horizontalStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
//            make.trailing.equalTo(self.sendButton.snp.leading)
//            make.centerY.equalTo(self.sendButton)
            
            
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        /// 버튼 액션
        self.sendButton.addTarget(self, action: #selector(self.sendTapped), for: .touchUpInside)
        self.cameraBtn.addTarget(self, action: #selector(self.cameraTapped), for: .touchUpInside)
        self.albumBtn.addTarget(self, action: #selector(self.albumTapped), for: .touchUpInside)
    }
    
    
    
    
    
    
    
    
    // MARK: - 버튼 액션 메서드
    @objc private func sendTapped() {
        self.delegate?.sendBtnTapped()
    }
    @objc private func cameraTapped() {
        self.delegate?.cameraBtnTapped()
    }
    @objc private func albumTapped() {
        self.delegate?.albumBtnTapped()
    }
    
    
    
    
    
    
    
    // MARK: - 보내기 버튼 활성화 / 바활성화
    func sendBtnIsEnable(isEnable: Bool) {
        if isEnable {
            self.sendButton.isEnabled = true
            self.sendButton.backgroundColor = .systemBlue
        } else {
            self.sendButton.isEnabled = false
            self.sendButton.backgroundColor = .systemGray4
        }
    }
    
    
    
    
    
    
    
    
    
    
}
