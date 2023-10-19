//
//  DetailWritingScreenController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit
import SnapKit

final class DetailWritingScreenController: UIViewController {
    
    // MARK: - 레이아웃
    /// 배경 뷰
    private lazy var backgroundImg: UIImageView = UIImageView(
        image: UIImage(named: ImageEnum.blueSky.imageString))
    
    
    
    
    /// 하단 악세서리 뷰
    private lazy var accessoryCustomView: InputAccessoryCustomView = {
        let view = InputAccessoryCustomView()
            view.delegate = self
            view.backgroundColor = .white
        return view
    }()
    
    
    /// 날짜 표시해주는 뷰 (+ 레이블)
    private lazy var dateView: DateView = DateView()
    
    
    /// 스크롤뷰
    private lazy var scrollView: CustomScrollView = {
        let scrollView = CustomScrollView()
            scrollView.delegate = self
            scrollView.bounces = false

        return scrollView
    }()
    /// 컨텐트뷰
    private lazy var contentView: UIView = UIView()
    
    /// 텍스트뷰
    private lazy var diaryTextView: UITextView = {
        let tv = UITextView.configureTV(fontSize: 14)
            tv.delegate = self
        
            tv.textContainerInset = UIEdgeInsets(
                top: 18, left: 10, bottom: 18, right: 10)
        
        tv.isScrollEnabled = false
        return tv
    }()
    
    /// 레이블
    private let placeholderLbl: UILabel = UILabel.configureLbl(
        text: "오늘 무슨 일이 있었지?",
        font: UIFont.systemFont(ofSize: 14),
        textColor: UIColor.gray)
    
    
    /// 기록 보기 버튼
    
    
    
    /// 이미지뷰
    private lazy var imageView: UIImageView = UIImageView(
        image: UIImage(named: "cat"))
    
    private lazy var stackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [self.imageView,
                                                 self.diaryTextView])
        stv.axis = .vertical
        stv.spacing = 10
        stv.alignment = .fill
        stv.distribution = .fill
        
        return stv
    }()
    
    
    
    
    
    // MARK: - 프로퍼티
    private lazy var size = CGSize(width: self.view.frame.width, height: .infinity)
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configreUI()
        self.configureAutoLayout()
        self.configureAction()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.diaryTextView.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 노티피케이션
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.diaryTextView.resignFirstResponder()
        // 노티피케이션 삭제
        NotificationCenter.default.removeObserver(self)
    }
    
    
        
    
    
    // MARK: - 화면 설정
    private func configreUI() {
        self.navigationItem.title = "오늘 일기"
        
        self.diaryTextView.backgroundColor = UIColor.customWhite5
        self.diaryTextView.clipsToBounds = true
        self.diaryTextView.layer.cornerRadius = 10
    }
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.backgroundImg,
         self.dateView,
         self.scrollView,
         self.accessoryCustomView].forEach { view in
            self.view.addSubview(view)
        }
        self.diaryTextView.addSubview(self.placeholderLbl)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.stackView)
        
        // 배경화면
        self.backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 하단 악세서리 뷰 (스택뷰 (카메라/앨범/날짜))
        self.accessoryCustomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
//            make.height.equalTo(50)
        }
        // 날짜 뷰
        self.dateView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }
        // 스크롤뷰
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.dateView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.accessoryCustomView.snp.top)
        }
        // 컨텐트뷰
        self.contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.scrollView.contentLayoutGuide)
            make.width.equalTo(self.scrollView.frameLayoutGuide)
        }
        // 이미지뷰
        self.imageView.snp.makeConstraints { make in
            make.width.height.equalTo(self.imageView.snp.width)
        }
        // 텍스트뷰
        self.diaryTextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(270)
            make.height.lessThanOrEqualTo(1000)
        }
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
        // 플레이스 홀더
        self.placeholderLbl.snp.makeConstraints { make in
            make.top.equalTo(self.diaryTextView).offset(18)
            make.leading.equalTo(self.diaryTextView).offset(14)
        }
    }
    
    
    

    
    

    

    
    
    // MARK: - 액션 설정
    private func configureAction() {
        // 위로 스와이프
    let swipeUp = UISwipeGestureRecognizer(target: self,
                                           action: #selector(self.swipeUpAction))
        swipeUp.direction = .up
    self.scrollView.addGestureRecognizer(swipeUp)
        
        
        
    }
    
    @objc private func swipeUpAction() {
        print(#function)
        self.diaryTextView.resignFirstResponder()
    }
    
    
    
    
    
    
    
    
    
    
    
    private var keyboardShow: Bool = false
    
    
    
    
    
    // MARK: - 노티피케이션 액션
    @objc private func keyboardWillShow(_ notification: Notification) {
        // 악세서리뷰 올리기
        if self.keyboardShow == false {
            // 키보드 높이 가져오기
            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
            
            
            // 뷰 올리기
            self.view.frame.origin.y -= keyboardSize - 34
            
//            self.accessoryCustomView.frame.origin.y -= keyboardSize - 34
            
            
            self.keyboardShow = true
        }
    }
    @objc private func keyboardWillHide(_ notification: Notification) {
        if self.keyboardShow == true {
            self.view.frame.origin.y = 0
            self.keyboardShow = false
            
            
            // 키보드 높이 가져오기
//            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
//
//            self.accessoryCustomView.frame.origin.y += keyboardSize - 34
        }
    }

    
    
    

    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}



// MARK: - 악세서리 델리게이트
extension DetailWritingScreenController: AccessoryViewDelegate {
    func cameraBtnTapped() {
        print("Detail --- \(#function)")
    }

    func albumBtnTapped() {
        print("Detail --- \(#function)")
    }

    func sendBtnTapped() {
        print("Detail --- \(#function)")
        
        self.diaryTextView.resignFirstResponder()
    }
}








// MARK: - 스크롤뷰 델리게이트
extension DetailWritingScreenController: UIScrollViewDelegate {
    // 사진의 높이(맨 밑)에까지 올리면 자동으로 키보드가 내려가도록 설정
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.keyboardHide()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.keyboardHide()
    }
    
    private func keyboardHide() {
        if self.keyboardShow && scrollView.contentOffset.y < 1 {
            self.diaryTextView.resignFirstResponder()
        }
    }
}








// MARK: - 텍스트뷰 델리게이트
extension DetailWritingScreenController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        // 텍스트뷰에 텍스트의 개수가 0개라면
        if textView.text.count == 0 {
            // 플레이스홀더 띄우기
            self.placeholderLbl.isHidden = false
        // 텍스트뷰에 텍스트가 있다면
        } else {
            // 플레이스홀더 없애기
            self.placeholderLbl.isHidden = true
        }
        
        
        
        // 예상 높이 구하기
        let estimatedSize = textView.sizeThatFits(self.size).height
        
        // 텍스트뷰의 높이가 300보다 크다면
            // - 최소 높이가 300이기 때문
        if estimatedSize >= 300 {
            // 텍스트뷰의 제약 forEach
            textView.constraints.forEach{ (constraint) in
                // 높이 제약이라면
                if constraint.firstAttribute == .height {
                    // 높이 재설정
                    constraint.constant = estimatedSize
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print(textView.numberOfLine())
    }
}



















final class CustomScrollView: UIScrollView {
    /// 스크롤뷰 내부의 원하는 레이아웃 위치로 이동
    func scrollToView(view: UIView,
                      animated: Bool = true) {
        
        if let origin = view.superview {
            // scrollView로 부터 원하는 레이아웃(textField)의 거리를 구함
            let childStartPoint = origin.convert(view.frame.origin,
                                                 to: self)
            // (현재 높이) - (키보드 크기) - (텍스트뷰의 크기)
            let height: CGFloat = (self.frame.size.height) - view.frame.height
            
            let offset: CGFloat = height > 0
            ? childStartPoint.y - height // textView의 크기가 작음
            : childStartPoint.y + height // textView의 크기가 큼
            
            // 스크롤뷰 이동
            self.scrollRectToVisible(
                CGRect(x: 0,
                       y: offset,
                       width: 1,
                       height: self.frame.height),
                animated: animated)
        }
    }
}
