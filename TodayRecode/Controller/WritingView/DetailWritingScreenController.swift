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
        image: UIImage.blueSky)
    
    
    // MARK: - Fix
    /// 이미지뷰
    private lazy var imageView: UIImageView = UIImageView(
        image: UIImage(named: "cat"))
    
//    private lazy var imageView: ImageCollectionView = {
//        let collectionView = ImageCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//        return collectionView
//    }()
//
    
    
    
    
    
    /// 시간을 나타내주는 뷰
    private lazy var bottomAccessoryView: InputAccessoryCustomView = {
        let view = InputAccessoryCustomView()
            view.delegate = self
            view.backgroundColor = UIColor.customWhite5
        return view
    }()
    
    /// 날짜 표시해주는 뷰 (+ 레이블)
    private lazy var dateView: DateView = DateView()
    
    /// 스크롤뷰
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
            scrollView.delegate = self
            scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    /// 컨텐트뷰 (- 스크롤뷰)
    private lazy var contentView: UIView = UIView()
    
    /// 텍스트뷰
    private lazy var diaryTextView: UITextView = {
        let tv = UITextView.configureTV(fontSize: 14)
            tv.delegate = self
            tv.backgroundColor = UIColor.customWhite5
            tv.textContainerInset = UIEdgeInsets(top: 18, left: 10, bottom: 18, right: 10)
            tv.isScrollEnabled = false
            // 인풋 악세사리뷰 넣기 -> 키보드가 올라올 때 같이 올라옴
            tv.inputAccessoryView = self.accessoryCustomView
        return tv
    }()
    
    /// 플레이스홀더 레이블
    private let placeholderLbl: UILabel = UILabel.configureLbl(
        text: "오늘 무슨 일이 있었지?",
        font: UIFont.systemFont(ofSize: 14),
        textColor: UIColor.gray)
    
    /// 스크롤뷰 내부 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.dateView,
                           self.imageView,
                           self.diaryTextView,
                           self.bottomAccessoryView],
        axis: .vertical,
        spacing: 10,
        alignment: .fill,
        distribution: .fill)

    /// 기록 확인 버튼
    private let recodeShowBtn: UIButton = UIButton.configureBtn(
        image: UIImage.recodeShow,
        tintColor: UIColor.black,
        backgroundColor: UIColor.white)
    
    /// 인풋 악세서리 뷰 (키보드 올라올 때 같이 생기는뷰)
    private lazy var accessoryCustomView: InputAccessoryCustomView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        
        let view = InputAccessoryCustomView(frame: frame)
            view.currentWritingScreen = .detailWritingScreen
            view.delegate = self
            view.backgroundColor = .white
        return view
    }()
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    // 텍스트뷰의 높이를 바꿀 때 사용
    private lazy var size = CGSize(width: self.view.frame.width, height: .infinity)
    /// 키보드가 올라와있는지 확인하는 변수
    private var keyboardShow: Bool = false
    /// 뷰의 높이 (기록 확인 버튼 위치를 옮길 때 사용)
    private lazy var viewHeight: CGFloat = self.view.frame.height
    /// safeArea 설정
    private lazy var safeArea: CGFloat = 49
    
    
    /*
     - DetailEditMode
        - writingMode (수정 모드)
        - safeMode (저장 모드)
     */
    /// 수정모드 / 저장모드를 알 수 있는 enum변수
    var detailEditMode: DetailEditMode? {
        // 네비게이션 이미지 설정
        didSet { self.configureNavRightBtn() }
    }
    /*
     - DetailViewMode
        - diary (일기 모드)
        - recode (기록 모드)
     */
    /// 일기 모드 / 기록 모드를 알 수 있는 enum변수
    var detailViewMode: DetailViewMode? {
        didSet {
            // 타이틀 레이블 설정
            self.navigationItem.title = self.detailViewMode == .diary
            ? "오늘 일기"
            : "오늘 기록"
        }
    }
    
    
    
    
    
    
    
    
    
    
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
        // cornerRadius 설정
        [self.imageView,
         self.diaryTextView,
         self.bottomAccessoryView].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
        self.recodeShowBtn.clipsToBounds = true
        self.recodeShowBtn.layer.cornerRadius = 50 / 2
    }
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubViews 설정 **********
        [self.backgroundImg,
         self.scrollView,
         self.recodeShowBtn].forEach { view in
            self.view.addSubview(view)
        }
        self.diaryTextView.addSubview(self.placeholderLbl)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.stackView)
        
        
        // ********** 오토레이아웃 설정 **********
        // 배경화면
        self.backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 날짜 뷰
        self.dateView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        // 스크롤뷰
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
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
        // 바텀 악세서리 뷰
        self.bottomAccessoryView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(11)
            make.trailing.equalToSuperview().offset(-11)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
        // 플레이스 홀더
        self.placeholderLbl.snp.makeConstraints { make in
            make.top.equalTo(self.diaryTextView).offset(18)
            make.leading.equalTo(self.diaryTextView).offset(14)
        }
        
        // ********** 프레임 설정 **********
        // 기록 확인 버튼
        self.recodeShowBtn.frame = CGRect(x: self.view.frame.width - 53 - 15,
                                          y: self.viewHeight - self.safeArea - 53,
                                          width: 53,
                                          height: 53)
    }
    
    
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.recodeShowBtn.addTarget(self, action: #selector(self.recodeShowBtnTapped), for: .touchUpInside)
    }
    
    
    
    // MARK: - 오른쪽 네비게이션바 설정
    private func configureNavRightBtn() {
        // 오른쪽 네비게이션 버튼 생성
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: self.navRightBtnImg(currentEditMode: self.detailEditMode),
            style: .done,
            target: self,
            action: #selector(self.navRightBtnTapped))
    }
    
    
    
    // MARK: - 네비게이션바 이미지 설정
    /// 모드에 따라 오른쪽 네비게이션 버튼 이미지 반환하는 변수
    private func navRightBtnImg(currentEditMode: DetailEditMode?) -> UIImage? {
        return currentEditMode == .writingMode
        ? UIImage.check // 수정 모드라면 -> 체크마크
        : UIImage.option // 저장 모드라면 -> 옵션
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - 노티피케이션 액션
    @objc private func keyboardWillShow(_ notification: Notification) {
        // 키보드 높이 가져오기
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        
        // 키보드가 올라와 있는 상태
        if !self.keyboardShow {
            // 기록 확인 버튼 위로 올리기
            // 바텀 악세서리뷰 숨기기
            self.bottomAccessoryViewIsHidden(true, keyboardSize: keyboardSize)
            self.keyboardShow = true
        }
    }
    @objc private func keyboardWillHide(_ notification: Notification) {
        // 키보드 높이 가져오기
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        // 키보드가 올라와있다면
        if self.keyboardShow {
            // 기록 확인 버튼 내리기
            // 바텀 악세서리뷰 보이게 하기
            self.bottomAccessoryViewIsHidden(false, keyboardSize: keyboardSize)
            self.keyboardShow = false
        }
    }
    /// 하단 악세서리뷰 isHidden 설정
    /// 기록 확인 버튼 위치 변경
    private func bottomAccessoryViewIsHidden(_ isHidden: Bool, keyboardSize: CGFloat) {
        // 키보드 올리는 상황 -> 바텀 악세서리뷰 없애기
        if isHidden {
            // [기록 확인 버튼] 키보드에 맞춰 올리기
            self.recodeShowBtn.frame.origin.y = self.viewHeight - keyboardSize - 53 - 10
            
            // ********** 바텀 악세서리뷰 위치 설정 **********
            // 부드러운 애니메이션을 위한 설정
            self.bottomAccessoryView.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                // 스택뷰의 spacing 거리를 늘려서 스크롤할 수 있는 공간 만들기
                self.stackView.setCustomSpacing(keyboardSize - 50 - 34, after: self.diaryTextView)
            }
            
            
            
        // 키보드 내리는 상황 -> 바텀 악세서리뷰 보이게 하기
        } else {
            // [기록 확인 버튼] 키보드에 맞춰 내리기
            // self.viewHeight - 53 - 45 - self.safeArea
            self.recodeShowBtn.frame.origin.y = self.viewHeight - self.safeArea - 53
            
            // ********** 바텀 악세서리뷰 위치 설정 **********
            // 스택뷰의 spacing 원상복구
            self.stackView.setCustomSpacing(10, after: self.diaryTextView)
            // 부드러운 애니메이션을 위한 설정
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                UIView.animate(withDuration: 0.3) {
                    self.bottomAccessoryView.alpha = 1
                }
            }
        }
    }
    
    
    
    // MARK: - 네비게이션 아이템 액션
    /// 오른쪽 네비게이션 버튼을 누르면
    @objc private func navRightBtnTapped() {
        // 수정 모드라면 -> 저장 모드로 바꾸기
        if self.detailEditMode == .writingMode {
            self.navigationItem.rightBarButtonItem?.image = self.navRightBtnImg(currentEditMode: .saveMode)
            self.detailEditMode = .saveMode
            
        // 저장 모드라면
            // ->
                // -> 수정 모드로 바꾸기
                // -> 삭제
        } else {
            self.navigationItem.rightBarButtonItem?.image = self.navRightBtnImg(currentEditMode: .writingMode)
            self.detailEditMode = .writingMode
        }
    }
    
    
    
    // MARK: - 기록 확인 버튼 액션
    @objc private func recodeShowBtnTapped() {
        self.imageView.isHidden = true
    }
}




















// MARK: - 악세서리 델리게이트
extension DetailWritingScreenController: AccessoryViewDelegate {
    /// 카메라 버튼이 눌리면 호출 됨
    func cameraBtnTapped() {
        print("Detail --- \(#function)")
    }
    
    /// 앨범 버튼이 눌리면 호출 됨
    func albumBtnTapped() {
        print("Detail --- \(#function)")
    }
    
    /// (키보드 닫기) 버튼이 눌리면 호출 됨
    func accessoryRightBtnTapped() {
        print("Detail --- \(#function)")
        self.diaryTextView.resignFirstResponder()
    }
}










// MARK: - 스크롤뷰 델리게이트
extension DetailWritingScreenController: UIScrollViewDelegate {
    /// /// 스크롤이 끝났을 때 호출
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.keyboardHide()
    }
    
    /// 사진의 높이(맨 밑)에까지 올리면 자동으로 키보드가 내려가도록 설정
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.keyboardHide()
    }
    
    /// 스크뷰 오프셋이 1보다 작으면 키보드 내리기
    private func keyboardHide() {
        if self.keyboardShow && scrollView.contentOffset.y < 1 {
            self.diaryTextView.resignFirstResponder()
        }
    }
}










// MARK: - 텍스트뷰 델리게이트
extension DetailWritingScreenController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // ********** 플레이스 홀더 설정 **********
        self.placeholderLbl.isHidden = textView.text.count == 0
        ? false // 텍스트뷰에 텍스트의 개수가 0개라면 ---> 플레이스홀더 띄우기
        : true // 텍스트뷰에 텍스트가 있다면 ---> 플레이스홀더 없애기
        
        // ********** 키보드 높이 설정 **********
        self.configureKeyboardHeight()
        
    
        /*
         1. line을 구해서 -> offset을 구해서 그만큼 내리기
         */
        // 텍스트뷰의 크기
//        print(textView.textContainer.size.height)
        //        print(textView.selectedTextRange)
    }
    
    
    
    /// 키보드 높이 설정
    private func configureKeyboardHeight() {
        // 예상 높이 구하기
        let estimatedSize = self.diaryTextView.sizeThatFits(self.size).height
        // 텍스트뷰의 높이가 300보다 크다면 (- 최소 높이가 300이기 때문)
        if estimatedSize >= 300 {
            // 텍스트뷰의 제약 forEach
            self.diaryTextView.constraints.forEach{ (constraint) in
                // 높이 제약이라면
                if constraint.firstAttribute == .height {
                    // 높이 재설정
                    constraint.constant = estimatedSize
                }
            }
        }
    }
}
