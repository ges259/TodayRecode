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
    /// 뷰
    private lazy var containerView: UIView = UIView.backgroundView(color: UIColor.white)
    
    private lazy var accessoryCustomView: InputAccessoryCustomView = {
        let view = InputAccessoryCustomView()
            view.delegate = self
            view.currentWritingScreen = .easyWritingScreen
        return view
    }()
    /// 텍스트뷰
    private lazy var recodeTextView: UITextView = {
        let tv = UITextView.configureTV(fontSize: 14)
            tv.delegate = self
        return tv
    }()
    /// 버튼
    private let expansionBtn: UIButton = UIButton.configureBtn(
        image: .expansion,
        tintColor: UIColor.btnGrayColor)
    /// 레이블
    private let placeholderLbl: UILabel = UILabel.configureLbl(
        text: "어떤 일을 기록하시겠습니까?",
        font: UIFont.systemFont(ofSize: 14),
        textColor: UIColor.btnGrayColor)
    

    
        
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private lazy var size = CGSize(width: self.recodeTextView.frame.width,
                                   height: .infinity)
    
    
    weak var delegate: EasyWritingScreenDelegate?
    
    
    
    
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
        self.recodeTextView.becomeFirstResponder()
        
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
        [self.containerView].forEach { view in
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
        }
    }
    
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAotoLayout() {
        [self.recodeTextView,
         self.accessoryCustomView,
         self.placeholderLbl,
         self.expansionBtn].forEach { view in
            self.containerView.addSubview(view)
        }
        self.view.addSubview(self.containerView)
        
        
        // 하단 악세서리뷰 (스택뷰 (카메라/앨범/날짜))
        self.accessoryCustomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }
        // 확대 버튼
        self.expansionBtn.snp.makeConstraints { make in
            make.top.equalTo(self.recodeTextView)
            make.trailing.equalToSuperview().offset(-16)
            make.height.width.equalTo(20)
        }
        // 텍스트뷰
        self.recodeTextView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(self.expansionBtn.snp.leading).offset(-15)
            make.bottom.equalTo(self.accessoryCustomView.snp.top).offset(-5)
            make.height.greaterThanOrEqualTo(60)
            make.height.lessThanOrEqualTo(150)
        }
        // 플레이스 홀더
        self.placeholderLbl.snp.makeConstraints { make in
            make.top.equalTo(self.recodeTextView).offset(9)
            make.leading.equalTo(self.recodeTextView).offset(5)
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
        
        self.expansionBtn.addTarget(self, action: #selector(self.expansionBtnTapped), for: .touchUpInside)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 노티피케이션 액션
    /// 키보드가 올라갈 때 호출 됨
    @objc private func keyboardWillShow(_ notification: Notification) {
        if self.view.frame.origin.y == 0 {
            // 키보드 높이 구하기
            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
            // 키보드 높이만큼 뷰 올리기
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    /// 키보드가 낼려갈 때 호출 됨
    @objc private func keyboardWillHide() {
        // 뷰 다시 내리기
        self.view.frame.origin.y = 0
    }
    
    
    
    
    
    
    
    
    
    // MARK: - 확장 버튼 액션
    /// 확장 버튼을 누르면 호출 됨
    @objc private func expansionBtnTapped() {
        // 뒤로가기
        self.dismiss(animated: false)
        // DetailWritingScreen으로 진입
        self.delegate?.expansionBtnTapped()
    }
    
    
    
    
    
    
    // MARK: - 뒤로가기 액션
    /// 컨테이너뷰를 클릭했을 때 viewTapped가 불려 뒤로 가는 현상으로 인해 해당 메서드를 만들었음
    @objc private func nothingHappened() {
    }
    /// 화면을 누르면 뒤로 가기
    @objc private func viewTapped() {
        self.dismissView()
    }
    /// 보내기 버튼을 누르면 뒤로 가기
    @objc private func sendTapped() {
        self.dismissView()
    }
    /// 키보드 닫기 + 뒤로가기 재사용
    private func dismissView() {
        self.recodeTextView.resignFirstResponder()
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
            self.accessoryCustomView.sendBtnIsEnable(isEnable: false)
            
        // 텍스트뷰에 텍스트가 있다면
        } else {
            // 플레이스홀더 없애기
            self.placeholderLbl.isHidden = true
            self.accessoryCustomView.sendBtnIsEnable(isEnable: true)
        }
        
        
        // 현재 테이블의 높이 가져오기
        let textViewHeight = self.recodeTextView.sizeThatFits(self.size).height
        
        // 테이블의 최대 높이인 150을 넘으면
            // 더이상 텍스트뷰가 커지지 않고 스크롤이 가능하도록 설정
        self.recodeTextView.isScrollEnabled = textViewHeight > 150
        ? true
        : false
    }
}





// MARK: - 악세서리 델리게이트
extension EasyWritingScreenController: AccessoryViewDelegate {
    func cameraBtnTapped() {
        print("Easy --- \(#function)")
    }
    
    func albumBtnTapped() {
        print("Easy --- \(#function)")
    }
    
    func accessoryRightBtnTapped() {
        print("Easy --- \(#function)")
    }
}
