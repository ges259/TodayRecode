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
    /// 컨테이너 뷰
    private lazy var containerView: UIView = UIView.backgroundView(color: UIColor.white)
    
    /// 플레이스홀더 레이블
    private let placeholderLbl: UILabel = UILabel.configureLbl(
        text: "오늘의 기록..",
        font: UIFont.boldSystemFont(ofSize: 14),
        textColor: UIColor.lightGray)
    
    /// 컨터이너뷰 위, 누르면 뒤로가는 뷰
    private lazy var touchGestureView: UIView = UIView.backgroundView(
        color: UIColor.clear)
    
    // ********** 상단 스택뷰 **********
    /// 텍스트뷰
    private lazy var recordTextView: UITextView = {
        let tv = UITextView.configureTV(fontSize: 14)
        tv.delegate = self
        tv.backgroundColor = UIColor.clear
        tv.isScrollEnabled = false
        return tv
    }()
    /// 텍스트뷰의 높이 제약
    private var textViewHeight: NSLayoutConstraint?
    
    /// 확장 버튼
    private let expansionBtn: UIButton = UIButton.buttonWithImage(
        image: .expansion,
        tintColor: UIColor.lightGray)
    
    /// 스택뷰
    private lazy var topStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.recordTextView,
                           self.expansionBtn],
        axis: .horizontal,
        spacing: 12,
        alignment: .top,
        distribution: .fill)
    
    // ********** 하단 스택뷰 **********
    /// 날짜 레이블
    private lazy var dateLbl: UILabel = UILabel.configureLbl(
        font: UIFont.boldSystemFont(ofSize: 13),
        textColor: UIColor.lightGray)
    
    /// 저장 버튼
    private let sendBtn: UIButton = {
        let btn = UIButton.buttonWithImage(
            image: UIImage.check,
            tintColor: UIColor.white,
            backgroundColor: UIColor.lightGray)
        btn.isEnabled = false
        return btn
    }()
    
    /// 스택뷰
    private lazy var bottomStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.dateLbl,
                           self.sendBtn],
        axis: .horizontal,
        spacing: 12,
        alignment: .center,
        distribution: .fill)
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    /// 텍스트뷰의 높이, 텍스트뷰의 높이를 동적으로 조절할 때 사용
    private lazy var size = CGSize(width: self.recordTextView.frame.width,
                                   height: .infinity)
    
    /// 델리게이트
    weak var delegate: EasyWritingScreenDelegate?
    
    /// 이전 화면(RecordController)에서 달력의 선택된 날짜를 받는 변수
    var todayDate: Date?
    
    
    
    
     
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureAction()
        self.configureAotoLayout()
        self.configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.containerView.isHidden = false
        self.recordTextView.becomeFirstResponder()
        
        // 노티피케이션 설정
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
}
    
    
    
    
    
    
    



// MARK: - 화면 설정
    
extension EasyWritingScreenController {
    
    // MARK: - UI 설정
    private func configureUI() {
        // 배경 색 설정
        self.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        // 데이트뷰에 날짜 설정
        self.dateLbl.text = Date.DateLabelString(date: Date())
        // 코너 둥글게 설정
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner,
                                                  .layerMaxXMinYCorner]
        [self.containerView,
         self.sendBtn].forEach { view in
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
        }
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAotoLayout() {
        // ********** addSubview 설정 **********
        [self.topStackView,
         self.bottomStackView,
         self.placeholderLbl].forEach { view in
            self.containerView.addSubview(view)
        }
        self.view.addSubview(self.touchGestureView)
        self.view.addSubview(self.containerView)
        
        
        // ********** 오토레이아웃 설정 **********
        // 저장 버튼
        self.sendBtn.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        // 하단 스택뷰
        self.bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(self.topStackView.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(40)
        }
        // 확대 버튼
        self.expansionBtn.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
        // 텍스트뷰
        self.recordTextView.translatesAutoresizingMaskIntoConstraints = false
        self.textViewHeight = self.self.recordTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70)
        self.textViewHeight?.isActive = true
        // 상단 스택뷰
        self.topStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.greaterThanOrEqualTo(60)
        }
        // 플레이스 홀더
        self.placeholderLbl.snp.makeConstraints { make in
            make.top.equalTo(self.topStackView).offset(9)
            make.leading.equalTo(self.topStackView).offset(5)
        }
        // 컨테이너뷰
        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
        }
        self.touchGestureView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.containerView.snp.top)
        }
    }
    
    // MARK: - 액션 설정
    /// 제스쳐, 버튼 액션, 노티피케이션 설정
    private func configureAction() {
        /// 뒤로가기 뷰(dismissView), 제스쳐 설정
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
            gesture.numberOfTapsRequired = 1
        self.touchGestureView.addGestureRecognizer(gesture)
        
        // 액션 설정
        self.expansionBtn.addTarget(self, action: #selector(self.expansionBtnTapped), for: .touchUpInside)
        self.sendBtn.addTarget(self, action: #selector(self.sendBtnTapped), for: .touchUpInside)
    }
}

    
    
    
    
    




// MARK: - API
extension EasyWritingScreenController {
    private func createRecord_API() {
        // DB에 데이터 생성
        Record_API.shared.createRecord(writing_Type: .record_plusBtn,
                                       date: self.todayDate,
                                       context: self.recordTextView.text,
                                       imageDictionary: nil) { result in
            switch result {
            case .success(let record):
                // DB 생성
                self.delegate?.createRecord(record: record)
                break
            case .failure(_):
                self.delegate?.createRecord(record: nil)
                break
            }
        }
    }
}
    
    
    






    
// MARK: - 셀렉터
    
extension EasyWritingScreenController {
    
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
        // RecordController -> DetailWritingScreen으로 진입
        self.delegate?.expansionBtnTapped(context: self.recordTextView.text)
    }
    
    // MARK: - 저장 버튼 액션
    @objc private func sendBtnTapped() {
        self.dismissView()
    }
    
    // MARK: - 뒤로가기 액션 + API
    /// 화면을 누르면 + 보내기 버튼 누르면 뒤로 가기
    /// 키보드 닫기 + 뒤로가기 재사용
    @objc private func dismissView() {
        // 텍스트뷰에 텍스트가 있다면 -> 저장
        if self.recordTextView.hasText {
            // DB에 데이터 생성
            self.createRecord_API()
            // 뒤로갈 때 키보드 내리기
            self.recordTextView.resignFirstResponder()
        }
        // 뒤로가기
        self.dismiss(animated: false)
    }
}










// MARK: - 텍스트뷰 액션

extension EasyWritingScreenController {
    
    // MARK: - 보내기 버튼 및 플레이스 홀더
    private func configureTextViewUI(text_Count: Int) {
        // 텍스트뷰에 텍스트의 개수가 0개라면
        if text_Count == 0 {
            // 플레이스홀더 띄우기
            self.placeholderLbl.isHidden = false
            self.sendBtn.isEnabled = false
            self.sendBtn.backgroundColor = UIColor.lightGray
            
        // 텍스트뷰에 텍스트가 있다면
        } else {
            // 플레이스홀더 없애기
            self.placeholderLbl.isHidden = true
            self.sendBtn.isEnabled = true
            self.sendBtn.backgroundColor = UIColor.blue_Point
        }
    }
    
    // MARK: - 텍스트뷰 높이 설정
    private func configureTextViewHeight(height: CGFloat) {
        // 높이가 250이하라면
        if height < 210 {
            // 텍스트뷰의 제약이 80이상이 아니라면 -> 제약이 변경된 상태라면
            if self.textViewHeight?.constant != 70 {
                // 텍스트뷰의 높이 제약 변경
                self.textViewHeight?.constant = 70
                self.view.layoutIfNeeded()
                // 스크롤이 불가능하도록 설정
                self.recordTextView.isScrollEnabled = false
            }
            
            
        // 높이가 300 이상 + 텍스트뷰가 스크롤이 불가능할 때
            // -> 텍스트뷰의 높이 제약을 바꿈 (여러번 불리는 것 방지)
        } else if self.recordTextView.isScrollEnabled == false {
            // 텍스트뷰의 높이 제약 변경
            self.textViewHeight?.constant = height
            self.view.layoutIfNeeded()
            // 스크롤이 가능하도록 설정
            self.recordTextView.isScrollEnabled = true
        }
    }
}










// MARK: - 텍스트뷰 델리게이트
extension EasyWritingScreenController: UITextViewDelegate {
    /// 텍스트를 입력할 때마다 불림
    func textViewDidChange(_ textView: UITextView) {
        // 보내기 버튼 및 플레이스 홀더 UI 설정
        self.configureTextViewUI(text_Count: textView.text.count)
        
        // ********** 높이 설정 **********
        // 현재 테이블의 높이 가져오기
        let textViewHeight = self.recordTextView.sizeThatFits(self.size).height
        // 텍스트뷰 높이 설정
        self.configureTextViewHeight(height: textViewHeight)
    }
    /// 엔터 누르면 뒤로가기
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        // enter를 눌렀다면 -> 저장 및 뒤로가기
        if text == "\n" { self.dismissView() }
        return true
    }
}
