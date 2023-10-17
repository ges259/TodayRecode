//
//  EasyWritingScreenController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/16.
//

import UIKit
import SnapKit

final class EasyWritingScreenController: UIViewController {
    
    
    
    
    // MARK: - 레이아웃
    // 뷰
    private lazy var containerView: UIView = UIView().backgroundView(color: UIColor.white)
    
    // 텍스트뷰
    private lazy var messageTextView: UITextView = {
        let tv = UITextView.configureTV(fontSize: 14)
            tv.delegate = self
        return tv
    }()
        
    // 버튼
    private let cameraBtn: UIButton = UIButton.configureBtn(
        image: .camera,
        tintColor: UIColor.btnGrayColor)
    
    private let albumBtn: UIButton = UIButton.configureBtn(
        image: .album,
        tintColor: UIColor.btnGrayColor)
    
    private let expansionBtn: UIButton = UIButton.configureBtn(
        image: .expansion,
        tintColor: UIColor.btnGrayColor)
    
    private let sendButton: UIButton = {
        let btn = UIButton.configureBtn(
            image: .send,
            tintColor: UIColor.white,
            backgroundColor: UIColor.btnGrayColor)
            btn.isEnabled = false
        return btn
    }()
    
    // 레이블
    private lazy var dateLbl: UILabel = UILabel.configureLbl(
        font: UIFont.systemFont(ofSize: 12),
        textColor: UIColor.btnGrayColor)
    
    private let placeholderLbl: UILabel = UILabel.configureLbl(
        text: "어떤 일을 기록하시겠습니까?",
        font: UIFont.systemFont(ofSize: 15),
        textColor: UIColor.btnGrayColor)
    
    // 스택뷰
    private lazy var horizontalStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [self.cameraBtn,
                                                 self.albumBtn,
                                                 self.dateLbl])
            stv.axis = .horizontal
            stv.spacing = 12
            stv.alignment = .center
        return stv
    }()
    
    
    
    
        
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private lazy var size = CGSize(width: self.messageTextView.frame.width,
                                   height: .infinity)
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureAction()
        self.configureAotoLayout()
        self.configureUI()
    }
    override var canBecomeFirstResponder: Bool {
        return false
    }
    override var canResignFirstResponder: Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.containerView.isHidden = false
        self.messageTextView.becomeFirstResponder()
        
        // 노티피케이션
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.containerView.isHidden = true
        // 노티피케이션 삭제
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    
    
    
    // MARK: - 화면 설정
    private func configureUI() {
        // 배경 색 설정
        self.view.backgroundColor = .darkGray.withAlphaComponent(0.4)
        // 코너 둥글게
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        [self.containerView, self.sendButton].forEach { view in
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
        }
        // 현재 날짜 및 시간 표시
        self.dateLbl.text = self.todayReturn(todayFormat: .detaildayAndTime)
    }
    
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAotoLayout() {
        [self.sendButton,
         self.messageTextView,
         self.horizontalStackView,
         self.placeholderLbl,
         self.expansionBtn].forEach { view in
            self.containerView.addSubview(view)
        }
        self.view.addSubview(self.containerView)
        // 보내기 버튼
        self.sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        // 스택뷰 (카메라/앨범/날짜)
        self.horizontalStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(25)
        }
        // 텍스트뷰
        self.messageTextView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(self.sendButton.snp.leading).offset(-15)
            make.bottom.equalTo(self.horizontalStackView.snp.top).offset(-5)
            make.height.greaterThanOrEqualTo(60)
            make.height.lessThanOrEqualTo(150)
        }
        self.placeholderLbl.snp.makeConstraints { make in
            make.top.equalTo(self.messageTextView).offset(8)
            make.leading.equalTo(self.messageTextView).offset(5)
        }
        // 확대 버튼
        self.expansionBtn.snp.makeConstraints { make in
            make.top.equalTo(self.messageTextView)
            make.trailing.equalTo(self.sendButton)
            make.height.width.equalTo(20)
        }
        // 컨테이너 뷰
        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
    
    // MARK: - 액션 설정
    /// 제스쳐, 버튼 액션, 노티피케이션 설정
    private func configureAction() {
        /// 제스쳐
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
            gesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gesture)
        
        /// 아무 행동도 하지 않기
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.nothingHappened))
            gesture2.numberOfTapsRequired = 1
        self.containerView.addGestureRecognizer(gesture2)
        
        /// 버튼 액션
        self.sendButton.addTarget(self, action: #selector(self.sendTapped), for: .touchUpInside)
        self.cameraBtn.addTarget(self, action: #selector(self.cameraTapped), for: .touchUpInside)
        self.cameraBtn.addTarget(self, action: #selector(self.albumTapped), for: .touchUpInside)
        self.cameraBtn.addTarget(self, action: #selector(self.expansionTapped), for: .touchUpInside)
    }
    
    
    
    
    
    
    
    
    
    
    @objc private func cameraTapped() {
    }
    @objc private func albumTapped() {
    }
    @objc private func expansionTapped() {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 노티피케이션 액션
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc private func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    
    // MARK: - 뒤로가기 액션
    /// 컨테이너뷰를 클릭했을 때 viewTapped가 불려 뒤로 가는 현상으로 인해 해당 메서드를 만들었음
    @objc private func nothingHappened() {
        
    }
    /// 화면을 누르면 뒤로 가기
    @objc private func viewTapped() {
        print(#function)
        self.dismissView()
    }
    /// 보내기 버튼을 누르면 뒤로 가기
    @objc private func sendTapped() {
        print(#function)
        self.dismissView()
    }
    /// 키보드 닫기 + 뒤로가기 재사용
    private func dismissView() {
        self.messageTextView.resignFirstResponder()
        self.dismiss(animated: false)
    }
}








// MARK: - 텍스트뷰 델리게이트
extension EasyWritingScreenController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // 텍스트뷰에 텍스트의 개수가 0개라면
        if textView.text.count == 0 {
            // 플레이스홀더 띄우기
            self.placeholderLbl.isHidden = false
            self.sendButton.isEnabled = false
            self.sendButton.backgroundColor = .systemGray4
            
        // 텍스트뷰에 텍스트가 있다면
        } else {
            // 플레이스홀더 없애기
            self.placeholderLbl.isHidden = true
            self.sendButton.isEnabled = true
            self.sendButton.backgroundColor = .systemBlue
        }
        
        
        
        
        
        // 현재 테이블의 높이 가져오기
        let textViewHeight = self.messageTextView.sizeThatFits(self.size).height
        
        // 테이블의 최대 높이인 150을 넘으면
            // 더이상 텍스트뷰가 커지지 않고 스크롤이 가능하도록 설정
        self.messageTextView.isScrollEnabled = textViewHeight > 150
        ? true
        : false
    }
}
