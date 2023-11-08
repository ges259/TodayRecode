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
        text: "어떤 일을 기록하시겠습니까?",
        font: UIFont.systemFont(ofSize: 14),
        textColor: UIColor.btnGrayColor)
    
    
    // 상단 스택뷰
    /// 텍스트뷰
    private lazy var recodeTextView: UITextView = {
        let tv = UITextView.configureTV(fontSize: 14)
            tv.delegate = self
        return tv
    }()
    /// 확장 버튼
    private let expansionBtn: UIButton = UIButton.buttonWithImage(
        image: .expansion,
        tintColor: UIColor.btnGrayColor)
    /// 스택뷰
    private lazy var topStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.recodeTextView,
                           self.expansionBtn],
        axis: .horizontal,
        spacing: 12,
        alignment: .top,
        distribution: .fill)
    
    // 하단 스택뷰
    /// 날짜 레이블
    private lazy var dateLbl: UILabel = UILabel.configureLbl(
        font: UIFont.systemFont(ofSize: 13),
        textColor: UIColor.btnGrayColor)
    
    /// 저장 버튼
    private let sendBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.check,
        tintColor: UIColor.white,
        backgroundColor: UIColor.btnGrayColor)
    /// 스택뷰
    private lazy var bottomStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.dateLbl,
                           self.sendBtn],
        axis: .horizontal,
        spacing: 12,
        alignment: .center,
        distribution: .fill)
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    private lazy var size = CGSize(width: self.recodeTextView.frame.width,
                                   height: .infinity)
    
    // 델리게이트
    weak var delegate: EasyWritingScreenDelegate?
    
    
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
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner,
                                                  .layerMaxXMinYCorner]
        [self.containerView,
         self.sendBtn].forEach { view in
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
        }
        // 데이트뷰에 날짜 설정
        self.dateLbl.text = Date.DateLabelString(date: Date())
    }
    
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAotoLayout() {
        // ********** addSubview 설정 **********
        self.containerView.addSubview(self.topStackView)
        self.containerView.addSubview(self.bottomStackView)
        self.containerView.addSubview(self.placeholderLbl)
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
        self.recodeTextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(60)
            make.height.lessThanOrEqualTo(160)
        }
        // 상단 스택뷰
        self.topStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.greaterThanOrEqualTo(60)
            make.height.lessThanOrEqualTo(200)
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
            make.height.lessThanOrEqualTo(500)
        }
    }
    
    
    
    // MARK: - 액션 설정
    /// 제스쳐, 버튼 액션, 노티피케이션 설정
    private func configureAction() {
        /// 제스쳐
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
            gesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gesture)
        
        /// 아무 행동도 하지 않기
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.nothingHappened))
            gesture2.numberOfTapsRequired = 1
        self.containerView.addGestureRecognizer(gesture2)
        
        self.expansionBtn.addTarget(self, action: #selector(self.expansionBtnTapped), for: .touchUpInside)
        
        
        // 액션
        self.sendBtn.addTarget(self, action: #selector(self.sendBtnTapped), for: .touchUpInside)
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
        self.delegate?.expansionBtnTapped(context: self.recodeTextView.text)
    }
    
    
    
    // MARK: - 저장 버튼 액션
    @objc private func sendBtnTapped() {
        self.dismissView()
    }
    
    
    
    
    
    
    
    /// 컨테이너뷰를 클릭했을 때 viewTapped가 불려 뒤로 가는 현상으로 인해 해당 메서드를 만들었음
    @objc private func nothingHappened() {
    }
    
    
    
    // MARK: - 뒤로가기 액션 + API
    /// 화면을 누르면 + 보내기 버튼 누르면 뒤로 가기
    /// 키보드 닫기 + 뒤로가기 재사용
    @objc private func dismissView() {
        // 텍스트뷰에 텍스트가 있다면 -> 저장
        if self.recodeTextView.hasText {
            // DB에 데이터 생성
            self.createRecord_API()
            // 뒤로갈 때 키보드 내리기
            self.recodeTextView.resignFirstResponder()
        }
        // 뒤로가기
        self.dismiss(animated: false)
    }
}



// MARK: - API
extension EasyWritingScreenController {
    private func createRecord_API() {
        // DB에 데이터 생성
        Record_API.shared.createRecord(writing_Type: .record_plusBtn,
                                       date: self.todayDate,
                                       context: self.recodeTextView.text,
                                       image: nil) { result in
            switch result {
            case .success(let record):
                print("데이터 생성 성공")
                // DB 생성
                self.delegate?.createRecord(record: record)

                break
            case .failure(_):
                // Fix
                break
            }
        }
    }
}








// MARK: - 텍스트뷰 델리게이트
extension EasyWritingScreenController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // 텍스트뷰에 텍스트의 개수가 0개라면
        if textView.text.count == 0 {
            // 플레이스홀더 띄우기
            self.placeholderLbl.isHidden = false
            self.sendBtn.isEnabled = false
            self.sendBtn.backgroundColor = UIColor.btnGrayColor
        // 텍스트뷰에 텍스트가 있다면
        } else {
            // 플레이스홀더 없애기
            self.placeholderLbl.isHidden = true
            self.sendBtn.isEnabled = true
            self.sendBtn.backgroundColor = UIColor.customblue6
        }
        
        // 현재 테이블의 높이 가져오기
        let textViewHeight = self.recodeTextView.sizeThatFits(self.size).height
        
        // 테이블의 최대 높이인 150을 넘으면
            // 더이상 텍스트뷰가 커지지 않고 스크롤이 가능하도록 설정
        self.recodeTextView.isScrollEnabled = textViewHeight > 150
        ? true
        : false
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.dismissView()
        }
        return true
    }
}
