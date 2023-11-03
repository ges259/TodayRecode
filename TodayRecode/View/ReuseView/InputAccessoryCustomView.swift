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
    /// 카메라 버튼
    private let cameraBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.camera,
        tintColor: UIColor.btnGrayColor)
    /// 앨범 버튼
    private let albumBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.album,
        tintColor: UIColor.btnGrayColor)
    /// 보내기 버튼
    private let sendBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.check,
        tintColor: UIColor.white,
        backgroundColor: UIColor.btnGrayColor)
    /// 키보드 내리기 버튼
    private let keyboardDownBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.keyboardDown,
        tintColor: UIColor.btnGrayColor)
    
    /// 날짜 레이블
    private lazy var dateLbl: UILabel = UILabel.configureLbl(
        font: UIFont.systemFont(ofSize: 13),
        textColor: UIColor.btnGrayColor)
    
    /// 스택뷰
    private lazy var horizontalStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.cameraBtn,
                           self.albumBtn,
                           self.dateLbl],
        axis: .horizontal,
        spacing: 12,
        alignment: .center,
        distribution: .fill)
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    weak var delegate: AccessoryViewDelegate?
    
    ///
    var currentWritingScreen: AccessoryViewMode? {
        didSet { self.configureRightBtn() }
    }
    
    
    
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
}










// MARK: - 화면 설정

extension InputAccessoryCustomView {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.dateLbl.text = Date.dateReturn_Custom(
            todayFormat: .a_hmm,
            UTC_Plus9: false)
        
        self.sendBtn.layer.cornerRadius = 10
        self.sendBtn.clipsToBounds = true
    }
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.horizontalStackView)
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
        
        // 스택뷰 (카메라/앨범/날짜 / 보내기)
        self.horizontalStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
        }
    }
    
    
    
    // MARK: - Enum에 따른 보내기 버튼 설정
    private func configureRightBtn() {
        let buttons = [self.albumBtn, self.cameraBtn]
        
        switch self.currentWritingScreen! {
        // 간편 작성 화면
        case .easyWritingScreen:
            // 보내기 버튼
            self.addSubview(self.sendBtn)
            self.sendBtn.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-10)
                make.top.equalToSuperview().offset(10)
                make.width.equalTo(70)
                make.height.equalTo(30)
            }
            self.sendBtn.addTarget(self, action: #selector(self.accessoryRightBtnTapped), for: .touchUpInside)
            
            self.sendBtn.isEnabled = false
            buttons.forEach { btn in btn.isHidden = true }
            break
            
            
        // 싱세 작성 화면
        case .detailWritingScreen:
            // 보내기 버튼
            self.addSubview(self.keyboardDownBtn)
            self.keyboardDownBtn.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-10)
                make.top.equalToSuperview().offset(10)
                make.width.equalTo(30)
                make.height.equalTo(30)
            }
            self.keyboardDownBtn.addTarget(self, action: #selector(self.accessoryRightBtnTapped), for: .touchUpInside)
            
            self.sendBtn.isEnabled = true
            
            buttons.forEach { btn in btn.isHidden = false }
        }
    }
    
    
    
    // MARK: - 액션 설정
    private func configureAction() {
        /// 버튼 액션
        self.cameraBtn.addTarget(self, action: #selector(self.cameraBtnTapped), for: .touchUpInside)
        self.albumBtn.addTarget(self, action: #selector(self.albumBtnTapped), for: .touchUpInside)
    }
}
    
    
    
    






// MARK: - 화면 설정
    
extension InputAccessoryCustomView {
    
    // MARK: - 버튼 액션 메서드
    @objc private func accessoryRightBtnTapped() {
        self.delegate?.accessoryRightBtnTapped()
    }
    @objc private func cameraBtnTapped() {
        self.delegate?.cameraBtnTapped()
    }
    @objc private func albumBtnTapped() {
        self.delegate?.albumBtnTapped()
    }
    
    
    
    func configureDate(date: Date = Date()) {
        self.dateLbl.text = Date.dateReturn_Custom(
            todayFormat: .a_hmm,
            UTC_Plus9: false,
            date: date)
    }
    
    
    // MARK: - 보내기 버튼 활성화 / 바활성화
    func sendBtnIsEnable(isEnable: Bool) {
        if isEnable {
            self.sendBtn.isEnabled = true
            self.sendBtn.backgroundColor = .systemBlue
        } else {
            self.sendBtn.isEnabled = false
            self.sendBtn.backgroundColor = .systemGray4
        }
    }
}
