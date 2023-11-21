//
//  DetailWritingScreenController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/14.
//

import UIKit
import SnapKit
import PanModal

import BSImagePicker
import Photos

final class DetailWritingScreenController: UIViewController {
    
    // MARK: - 레이아웃
    /// 네비게이션 타이틀 레이블
    private lazy var navTitle: UILabel = UILabel.navTitleLbl()
    
    /// 콜렉션뷰
    private lazy var collectionView: CustomCollectionView = {
        let collectionView = CustomCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        return collectionView
    }()
    
    /// 날짜 표시해주는 뷰 (+ 레이블)
    private lazy var dateView: DateView = DateView()
    
    /// 스크롤뷰
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    /// 컨텐트뷰 (- 스크롤뷰 관련 뷰)
    private lazy var contentView: UIView = UIView()
    
    /// 텍스트뷰
    lazy var diaryTextView: UITextView = {
        let tv = UITextView.configureTV(fontSize: 14)
        tv.delegate = self
        tv.backgroundColor = UIColor.white_Base
        tv.textContainerInset = UIEdgeInsets(top: 18, left: 10, bottom: 18, right: 10)
        tv.isScrollEnabled = false
        // 인풋 악세사리뷰 넣기 -> 키보드가 올라올 때 같이 올라옴
        tv.inputAccessoryView = self.accessoryCustomView
        return tv
    }()
    /// 텍스트뷰의 높이 제약
    private var stackViewHeight: NSLayoutConstraint?
    /// 플레이스홀더 레이블
    private lazy var placeholderLbl: UILabel = UILabel.configureLbl(
        text: "오늘 무슨 일이 있었지?",
        font: UIFont.systemFont(ofSize: 14),
        textColor: UIColor.gray)
    
    /// 스크롤뷰 내부 스택뷰
    private lazy var verticalStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.dateView,
                           self.collectionView,
                           self.diaryTextView],
        axis: .vertical,
        spacing: 7,
        alignment: .fill,
        distribution: .fill)
    
    /// 기록 확인 버튼
    private let recordShowBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.recodeShow,
        tintColor: UIColor.white,
        backgroundColor: UIColor.blue_Point)
    
    // 악세서리 뷰
    /// 앨범 버튼
    private let albumBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.album,
        tintColor: UIColor.gray_Accessoroy)
    /// 날짜 레이블
    private lazy var dateLbl: UILabel = UILabel.configureLbl(
        font: UIFont.systemFont(ofSize: 13),
        textColor: UIColor.gray_Accessoroy)
    /// 스택뷰
    private lazy var horizontalStackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.albumBtn,
                           self.dateLbl],
        axis: .horizontal,
        spacing: 12,
        alignment: .center,
        distribution: .fill)
    
    /// 키보드 내리기 버튼
    private let keyboardDownBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.keyboardDown,
        tintColor: UIColor.gray_Accessoroy)
    
    /// 키보드가 올라오면 보이는 악세서리 컨테이너뷰
    private lazy var accessoryCustomView: UIView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        let view = UIView(frame: frame)
        view.backgroundColor = .white
        return view
    }()
    
    // 앨범
    /// 앨범 버튼 누르면 이미지피커가 나옴
    private lazy var imagePicker: ImagePickerController = {
        let imagePicker = ImagePickerController()
        
        imagePicker.modalPresentationStyle = .fullScreen
        
        
        // 최대 선택할 수 있는 개수 설정
        imagePicker.settings.selection.max
        = self.detailViewMode == .diary
        ? 5 // 일기라면 -> 최대 5개 선택 가능
        : 3 // 기록이라면 -> 최대 3개 선택 가능
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]

        imagePicker.settings.theme.selectionFillColor = .white
        imagePicker.settings.theme.selectionStrokeColor = .lightGray

        imagePicker.settings.preview.enabled = true
        // 버튼 설정
        imagePicker.title = "이미지 선택"
        imagePicker.doneButtonTitle = "선택완료"
        // 버튼 글자 색상
        imagePicker.doneButton.tintColor = UIColor.black
        imagePicker.cancelButton.tintColor = UIColor.black
        
        imagePicker.settings.theme.backgroundColor = UIColor.blue_Base
//        imagePicker.settings.selection.unselectOnReachingMax = true
        
        return imagePicker
    }()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    // ********** 기본? 변수들 **********
    /// 일기 모드 / 기록 모드를 알 수 있는 enum변수
    var detailViewMode: DetailViewMode?
    /// 델리게이트
    weak var delegate: DetailWritingScreenDelegate?
    
    
    // ********** 데이터 **********
    /// 기록 확인 화면에서 오늘 기록을 볼 수 있게 하는 Record배열
    lazy var todayRecords: [Record] = []
    /// 셀을 클릭하여 상세작성 화면에 들어온 경우
    var selectedRecord: Record?
    
    
    // ********** 날짜 관련 변수들 **********
    /// DB에 저장할 날짜를 표시
    lazy var todayDate: Date? = Date()
    // 오늘인지 아닌지를 판단하는 변수
    private var isToday: Bool {
        // 일기 목록 화면의 달력에 선택된 날짜
        let selectedDate = self.todayDate?.reset_time()
        // 현재 날짜
        let today = Date().reset_time()
        return selectedDate == today
    }
    
    
    // ********** 상황에 따라 필요한 변수들 **********
    /// 현재 콜렉션뷰의 페이지를 보여주는 변수
    private var currentPage: CGFloat = 0
    /// 키보드가 올라와있는지 확인하는 변수
    private var keyboardShow: Bool = false
    
    
    /// 콜렉션뷰의 넓이 (콜렉션뷰의 CGSize를 설정할 때 사용)
    private lazy var collectionViewWidth = self.collectionView.frame.width
    
    
    // ********** 이미지 - 이전 화면에서 가져온 이미지 데이터 **********
    /// 이전 화면에서 가져온 데이터, (--- 저장할 때도 이 변수를 사용)
    private var imageDictionary: [String: String] = [:]
    /// url_String을 저장하는 배열
    private var savedUrl: [String] = []
    
    
    // ********** 앨범 이미지 **********
    // 이미지 관련 배열
    private lazy var selectedAssets: [PHAsset] = []
    /// 모든 이미지, 앨범에서 추가하면 이 변수에 추가 됨
    private lazy var selectedImages: [UIImage] = [] {
        didSet { self.collectionView.reloadData() }
    }
    
    
    // ********** 이미지 - DB 저장 관련 변수들 **********
    /// 추가된 이미지
    private lazy var addedImages: [UIImage] = [] {
        didSet { self.imageIsChanged = true }
    }
    private lazy var willDeleteImage: [String: String] = [:] {
        didSet { self.imageIsChanged = true }
    }
    /// 이미지가 추가되거나 삭제되면 true로 바뀜, true-> 데이터 저장
    private lazy var imageIsChanged: Bool = false
    /// 현재 데이터를 생성해야할 지 수정해야할 지 결정하는 변수
    private var createOrUpdate: () {
        // selectedRecord가 nil인지 판단
        return self.selectedRecord == nil
        // selectedRecord가 없는 경우(셀) -> 생성
        ? self.createRecord_API()
        // selectedRecord가 있는 경우(플러스버튼) -> 업데이트
        : self.updateRecord_API()
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configreUI()           // UI 설정
        self.configureAutoLayout()  // 오토레이아웃 설정
        self.configureAction()      // 액션 설정
        self.configureData()        // 텍스트 및 시간, 이미지 등 설정
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 노티피케이션 생성 (-삭제는 왼쪽 네비게이션 버튼을 눌러야 함)
        // 키보드 올라올 때
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        // 키보드 내려갈 때
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // (일기 목록 화면에서 들어온 상황 && 오늘) == true 이라면
        if self.detailViewMode == .diary,
           !self.isToday {
            // 수정 불가능하도록 설정
            self.diaryTextView.isEditable = false
            // 더블클릭하면 화면이 올라가는 상황 방지
            self.diaryTextView.isSelectable = false
        } else {
            // 화면에 들어오면 키보드 올리기
             self.diaryTextView.becomeFirstResponder()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 화면을 나가면 키보드 내리기
        self.diaryTextView.resignFirstResponder()
        
        if DataUpdate.dataUpdateStart {
            self.popViewController()
        }
    }
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    



// MARK: - 화면 설정
    
extension DetailWritingScreenController {
    
    // MARK: - UI 설정
    private func configreUI() {
        // 배경 색상 설정
        self.view.backgroundColor = UIColor.blue_Base
        // 네비게이션 타이틀뷰(View) 설정
        self.navigationItem.titleView = self.navTitle
        // 네비게이션 타이틀(String) 설정
        self.setNavTitle(keyboard_Up: false)
        
        // cornerRadius 설정
        [self.collectionView,
         self.diaryTextView].forEach { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
        self.recordShowBtn.clipsToBounds = true
        self.recordShowBtn.layer.cornerRadius = 65 / 2
    }
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubViews 설정 **********
        // 뷰
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.recordShowBtn)
        // 텍스트뷰
        self.diaryTextView.addSubview(self.placeholderLbl)
        // 스크롤뷰
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.verticalStackView)
        // 컨테이너뷰
        self.accessoryCustomView.addSubview(self.horizontalStackView)
        self.accessoryCustomView.addSubview(self.keyboardDownBtn)
        
        
        // ********** 오토레이아웃 설정 **********
        // 날짜 뷰
        self.dateView.snp.makeConstraints { make in
            make.height.equalTo(35)
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
        self.collectionView.snp.makeConstraints { make in
            make.width.height.equalTo(self.collectionView.snp.width)
        }
        // 텍스트뷰
        self.diaryTextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(270)
        }
        // 스택뷰
        self.verticalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(11)
            make.trailing.equalToSuperview().offset(-11)
        }
        self.stackViewHeight = self.verticalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        self.stackViewHeight?.isActive = true
        // 플레이스 홀더
        self.placeholderLbl.snp.makeConstraints { make in
            make.top.equalTo(self.diaryTextView).offset(18)
            make.leading.equalTo(self.diaryTextView).offset(14)
        }
        // 앨범 버튼
        self.albumBtn.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        // 날짜 레이블
        self.dateLbl.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        // 키보드 내리기 버튼
        self.keyboardDownBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        // 스택뷰 (카메라/앨범/날짜 / 보내기)
        self.horizontalStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
        }
        // 기록 확인 버튼 설정
        self.recordShowBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.bottom).offset(-40)
            make.trailing.equalToSuperview().offset(-17)
            make.width.height.equalTo(65)
        }
        // 네비게이션 타이틀
        self.navTitle.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(200)
        }
    }
    
    
    
    // MARK: - 액션 설정
    private func configureAction() {
        // 셀렉터 설정
        self.recordShowBtn.addTarget(self, action: #selector(self.recodeShowBtnTapped), for: .touchUpInside)
        self.keyboardDownBtn.addTarget(self, action: #selector(self.keyboardDownBtnTapped), for: .touchUpInside)
        self.albumBtn.addTarget(self, action: #selector(self.albumBtnTapped), for: .touchUpInside)
        
        // 네비게이션 오르쪽 버튼 설정
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.trash,
            style: .plain,
            target: self,
            action: #selector(self.deleteBtnTapped))
        // 네비게이션 왼쪽 버튼 설정
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.back,
            style: .plain,
            target: self,
            action: #selector(self.leftNavBtnTapped))
        
        // 스와이프로 뒤로가기 설정
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    
    // MARK: - 날짜 및 텍스트 설정
    /// 셀을 클릭하여 상세작성화면에 들어온 경우 데이터 설정
    private func configureData() {
        // 메인화면 or 일기 목록 화면에서 셀(아이템)을 클릭하여 들어온경우
        if let currentRecode = self.selectedRecord {
            // ********** 텍스트 **********
            // 텍스트뷰에 텍스트 넣기
            self.diaryTextView.text = currentRecode.context
            self.placeholderLbl.isHidden = true
            
            // ********** 시간 **********
            // 해당 데이터의 날짜를 저장
            self.todayDate = currentRecode.date
            // 날짜뷰에 기록(Record)의 시간 표시
            self.dateView.configureDate(selectedDate: currentRecode.date)
            // 시간뷰에 기록(Record)의 시간 표시
            self.dateLbl.text = Date.DateLabelString(date: currentRecode.date)
            // ********** 이미지 (콜렉션뷰) **********
            self.configureImage(record: currentRecode)
            
            
            
        // 플러스버튼을 통해 들어온 경우
        } else {
            // ********** 텍스트 **********
            // esayWriting뷰에서 텍스를 가져왔다면 -> 플레이스 홀더 없애기
            if self.diaryTextView.text != "" {
                self.placeholderLbl.isHidden = true
            }
            // ********** 시간 **********
            // 날짜뷰에 현재 시간 표시
            self.dateView.configureDate()
            // 시간뷰에 기록(Record)의 시간 표시
            self.dateLbl.text = Date.DateLabelString(date: Date())
        }
    }
    
    
    
    // MARK: - 이미지 설정
    private func configureImage(record: Record) {
        // Record 데이터에 이미지가 있다면
        if !record.imageUrl.isEmpty {
            // 딕셔너리 형태로 저장
            self.imageDictionary = record.imageUrl
            // url만 가져오기
            record.imageUrl.forEach { (key: String, value: String) in
                // url저장
                self.savedUrl.append(value)
            }
            // url -> 이미지로 변환 -> selectedImages에 저장 -> 화면에 이미지 보임
            self.loadImage(imageUrl: self.savedUrl)
        }
    }
}
    
    









    
    
    



    
    
    
// MARK: - 셀렉터
    
extension DetailWritingScreenController {
    
    // MARK: - 노티피케이션 셀렉터
    /// 키보드가 올라올 때
    @objc private func keyboardWillShow(_ notification: Notification) {
        // 키보드 높이 가져오기
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        
        // 키보드가 올라와 있는 상태라면
        // 화면 내리기 + 스택뷰 간격 설정
        if !self.keyboardShow {
            self.keyboardStateChanged(keyboard_Up: true,
                                      keyboardSize: keyboardSize)
        }
    }
    /// 키보드가 내려갈 때
    @objc private func keyboardWillHide(_ notification: Notification) {
        // 키보드 높이 가져오기
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        
        // 키보드가 올라와있는 상태라면
        // 화면 내리기 + 스택뷰 간격 설정
        if self.keyboardShow {
            self.keyboardStateChanged(keyboard_Up: false,
                                      keyboardSize: keyboardSize)
        }
    }
    
    // MARK: - 기록 삭제 버튼
    @objc internal func deleteBtnTapped() {
        // 얼럿창 띄우기
        self.customAlert(alertStyle: .actionSheet,
                         alertEnum: .deleteRecord,
                         firstBtnColor: .red) { _ in
            // 레코드 데이터가 있다면
            // 플러스 버튼으로 들어온 경우 X
            if self.selectedRecord != nil {
                self.deleteRecord_API()
            }
            // 뒤로가기
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - 버튼 액션
    /// 키보드 내리기 버튼을 누르면 텍스트뷰 resign
    @objc private func keyboardDownBtnTapped() {
        self.diaryTextView.resignFirstResponder()
    }
    
    /// 앨범 버튼을 누르면 이미지피커로 넘어간다.
    @objc private func albumBtnTapped() {
        self.imagePickerAction()
    }
    
    /// 기록 확인 버튼을 누르면 오늘 기록을 볼 수 있다.
    @objc private func recodeShowBtnTapped() {
        let recodeCheckVC = RecordCheckController(recordArray: self.todayRecords)
            recodeCheckVC.modalPresentationStyle = .overFullScreen
        // 화면 전환
        self.presentPanModal(recodeCheckVC)
    }
    
    // MARK: - 화면 나가기 버튼
    @objc private func leftNavBtnTapped() {
        // 뒤로가기
        self.navigationController?.popViewController(animated: true)
    }
}
    
    
    


    




// MARK: - 액션
    
extension DetailWritingScreenController {
    
    // MARK: - 노티피케이션 액션
    /// 화면 내리기 + 스택뷰 간격 설정
    private func keyboardStateChanged(keyboard_Up: Bool,
                                      keyboardSize: CGFloat) {
        // ********** 키보드 올리는 상황 **********
        if keyboard_Up {
            // 아이폰 종류 확인
            // 스택뷰 스크롤이 되도록 설정
            self.stackViewHeight?.constant = UIDevice.current.isiPhoneSE
            ? -(keyboardSize + 10) // se or 8
            : -(keyboardSize - 20) // 10이상
            
            // 기록 보기 버튼 위로 올리기
            self.recordShowBtn.frame.origin.y -= keyboardSize - 30
            // 날짜뷰 안 보이도록 설정
            self.dateView.alpha = 0
            self.dateView.isHidden = true
            
        // ********** 키보드 내리는 상황 **********
        } else {
            // 스택뷰 스크롤 안 되도록 설정
            self.stackViewHeight?.constant = -10
            // 기록 보기 버튼 아래로 내리기
            self.recordShowBtn.frame.origin.y += keyboardSize - 30
            // 날짜뷰 보이도록 설정
            self.dateView.alpha = 1
            self.dateView.isHidden = false
        }
        
        // ********** 모든 상황 **********
        // 뷰 다시 그리기 (스택뷰 바텀 앵커 변경)
        self.view.layoutIfNeeded()
        // 네비게이션 타이틀(String) 설정
        self.setNavTitle(date: self.todayDate ?? Date(),
                         keyboard_Up: keyboard_Up)
        // 키보드 상태 바뀜 표시
        self.keyboardShow.toggle()
    }
    
    // MARK: - 네비게이션 타이틀 재설정
    /// 선택된 날짜에 따라 네비게이션 타이틀을 설정하는 메서드
    private func setNavTitle(date: Date = Date(), keyboard_Up: Bool) {
        let navEnum: NavTitleSetEnum = .M월d일
        
        let navMainTitle: String = self.detailViewMode == .diary
        ? navEnum.diary_String // 기록 화면이라면
        : navEnum.record_String // 일기 화면이라면
        
        // 키보드가 올라간 상황
        if keyboard_Up {
            self.navTitle.attributedText = self.configureNavTitle(
                navMainTitle,
                navTitleSetEnum: navEnum,
                date: date)
        // 키보드가 내려간 상황
        } else {
            self.navTitle.text = navMainTitle
        }
    }
    
    // MARK: - 뒤로갈 때 실행되는 액션
    private func popViewController() {
        // 노티피케이션 삭제
        NotificationCenter.default.removeObserver(self)
        // 삭제할 이미지가 있다면
        if !self.willDeleteImage.isEmpty {
            // 이미지 삭제
            ImageUploader.shared.deleteImage(imageDictionary: self.willDeleteImage)
        }
        
        // 저장할(추가된) 이미지가 있다면
        if !self.addedImages.isEmpty {
            // 이미지가 바뀌면 시간이 오래걸리기 때문에 -> 로딩뷰를 띄우기 위한 설정
            DataUpdate.imageDataUpdate = true
            // 이미지 업로드 -> 생성 또는 업데이트
            self.imageUpload()
            return
        }
        
        // 현재 모드 확인
        guard let mode = self.detailViewMode else { return }
        // 스위치문
        switch mode {
            // 플러스버튼을 통해 들어온 경우
        case .record_plusBtn:
            // 생성
            self.createRecord_API()
            break
            
            // 셀을 통해 들어온 경우
        case .record_CellTapped:
            // 업데이트
            self.updateRecord_API()
            break
            
            // 일기목록화면을 통해 들어온 경우
        case .diary:
            // 오늘인 경우만 저장
            guard self.isToday else { return }
            // 생성 or 업데이트
            self.createOrUpdate
            break
        }
    }
    
    // MARK: - 이미지 액션
    private func imagePickerAction() {
        // 이미지가 5개면 더이상 추가 못 함
        self.presentImagePicker(self.imagePicker, select: {
            (asset) in
            // 사진 하나 선택할 때마다 실행되는 내용 쓰기
            return
        }, deselect: {
            (asset) in
            // 선택했던 사진들 중 하나를 선택 해제할 때마다 실행되는 내용 쓰기
            return
        }, cancel: {
            (assets) in
            // Cancel 버튼 누르면 실행되는 내용
            return
        }, finish: {
            (assets) in
            // Done 버튼 누르면 실행되는 내용
            // 이미 가지고 있던 사진 + 새로 선택한 사진이 6개 이상이라면
            _ = self.selectedImages.count + assets.count >= 6
            // 6개 이상 -> 경고문 띄우기
            ? self.limit5Image_Alert()
            // 5개 이하 -> 이미지 추가
            : self.imagePlus(assets: assets)
            
            // 앨범뷰에서 선택되었던 사진들 선택 해제
            self.selectedAssets.forEach { asset in
                self.imagePicker.deselect(asset: asset)
            }
            return
        })
    }
    
    // MARK: - 콜렉션뷰 이미지 개수 제한
    private func limit5Image_Alert() {
        DispatchQueue.main.async {
            self.customAlert(alertEnum: .limit5Image) { _ in }
        }
    }
    
    // MARK: - 콜렉션뷰 이미지 추가
    private func imagePlus(assets: [PHAsset]) {
        // assets 모두 삭제
        self.selectedAssets.removeAll()
        // selectedAssets에 추가
        for i in assets {
            self.selectedAssets.append(i)
        }
        // PHAsset을 UIImage로 변환 후 저장
        let images = self.convertAssetToImage(selectedAssets: self.selectedAssets)
        // 이미지 저장
        // -> 콜렉션뷰에 전달
        // -> 콜렉션뷰 리로드
        // 0개라면 콜렉션뷰 숨기기
        self.selectedImages.append(contentsOf: images)
        // '추가된 이미지 배열'에 이미지 추가 -> DB에 저장할 이미지들
        self.addedImages.append(contentsOf: images)
    }
    
    // MARK: - 콜렉션뷰 이미지 삭제
    private func deleteImage(page: Int) {
        // page에 따라 달라짐.
        if self.savedUrl.count > page {
            // url삭제
            self.imageDelete(index: page)
            self.savedUrl.remove(at: page)
            self.selectedImages.remove(at: page)
            
        // urlString이 존재
        } else if savedUrl.count != 0 {
            self.selectedImages.remove(at: page)
            let index = page - (self.savedUrl.count)
            self.addedImages.remove(at: index)
            
        // urlString이 존재X
        } else {
            self.selectedImages.remove(at: page)
            self.addedImages.remove(at: page)
        }
    }
    
    // MARK: - 이미지 삭제
    /// 이전 화면에서 가져온 이미지를 삭제할 때 불리는 메서드
    private func imageDelete(index: Int) {
        // 이미지 딕셔너리에서 value값(url) 중 삭제할 url과 맞는 것을 찾아냄
        self.imageDictionary.forEach { (key: String, value: String) in
            // 찾아냈다면
            if value == self.savedUrl[index] {
                // '삭제할 이미지 배열'에 저장 -> 화면 나갈 때 이미지 삭제 진행
                self.willDeleteImage[key] = value
                // 딕셔너리에서 삭제
                self.imageDictionary.removeValue(forKey: key)
            }
        }
    }
}










// MARK: - API

extension DetailWritingScreenController {
    
    // MARK: - 삭제
    private func deleteRecord_API() {
        // 문서ID 가져오기
        guard let documentID = self.selectedRecord?.documentID else { return }
        // DB - 삭제
        Record_API.shared.deleteRecord(documentID: documentID,
                                       imageDictionary: self.imageDictionary) { result in
            switch result {
            case .success(_):
                // 셀 삭제
                self.delegate?.deleteRecord(success: true)
                break
            case .failure(_):
                self.delegate?.deleteRecord(success: false)
                break
            }
        }
    }
    
    // MARK: - 업데이트
    private func updateRecord_API() {
        // 텍스트뷰가 처음 들어왔을 때와 비교해 바뀌지 않으면 저장X
        // 화면에 들어올 때 데이터를 가지고 들어왔다면
        // 타입 옵셔널바인딩 (.diary or .record_cellTapped)
        guard self.selectedRecord?.context != self.diaryTextView.text
              || self.imageIsChanged,
              let selectedRecord = selectedRecord,
              let writing_Type = self.detailViewMode else { return }
        
        // DB + 셀 업데이트
        Record_API.shared.updateRecord(writing_Type: writing_Type,
                                       record: selectedRecord,
                                       context: self.diaryTextView.text,
                                       imageDictionary: self.imageDictionary) { result in
            switch result {
            case .success(let record):
                self.delegate?.updateRecord(record: record)
                break
            case .failure(_):
                self.delegate?.updateRecord(record: nil)
                break
            }
        }
    }
    
    // MARK: - 생성
    private func createRecord_API() {
        // 텍스트뷰가 빈칸인 경우 생성X
        // 오늘 날짜 및 타입 - 옵셔널바인딩
        guard self.diaryTextView.text != ""
                || !self.addedImages.isEmpty,
              let date = self.todayDate, // 날짜 가져오기
              let writing_Type = self.detailViewMode else { return }
        // DB에 데이터 생성
        Record_API.shared.createRecord(writing_Type: writing_Type,
                                       date: date,
                                       context: self.diaryTextView.text,
                                       imageDictionary: self.imageDictionary) { result in
            switch result {
            case .success(let record):
                // 셀 업데이트
                self.delegate?.createRocord(record: record)
                break
            case .failure(_):
                self.delegate?.createRocord(record: nil)
                break
            }
        }
    }
    
    // MARK: - 기록 가져오기
    func fetchRecords_API(date: Date = Date()) {
        Record_API.shared.fetchRecode(writing_Type: .record_CellTapped,
                                      date: date) { result in
            switch result {
            case .success(let recordArray):
                self.todayRecords = recordArray
            case .failure(_):
                self.customAlert(alertEnum: .fetchError) { _ in }
                break
            }
        }
    }
    
    // MARK: - 이미지 업로드
    private func imageUpload() {
        // 이미지 업로드
        ImageUploader.shared.uploadImage(image: self.addedImages) { imageDictionary in
            // 받아온 이미지 딕셔너리를 모두 저장
            imageDictionary.forEach { (key: String, value: String) in
                // 이미지 딕셔너리에 저장 -> 화면 나갈 때 해당 딕셔너리 저장
                self.imageDictionary[key] = value
            }
            // 생성 or 업데이트
            self.createOrUpdate
        }
    }
    

    
    
    // MARK: - 이미지 로드
    private func loadImage(imageUrl: [String]) {
        // 이미지를 로드
        ImageUploader.shared.loadImageView(with: imageUrl) { images in
            DispatchQueue.main.async {
                guard let images = images else { return }
                // 로드한 이미지를 저장 -> 화면에 보이도록 함
                self.selectedImages = images
            }
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
    }
}










// MARK: - 콜렉션뷰 델리게이트
extension DetailWritingScreenController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /// 아이템 개수
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        // 셀의 개수가 0이라면 -> 콜렉션뷰 숨기기
        self.collectionView.isHidden = self.selectedImages.count == 0
        ? true
        : false
        // 셀의 개수 설정
        return self.selectedImages.count
    }
    
    /// 아이템 표현?
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.imageListCollectionViewCell,
            for: indexPath) as! ImageCollectionViewCell
            cell.delegate = self
            // 상세 작성 화면
            cell.collectionViewEnum = .photoList
            // 이미지 넣기
            cell.imageView.image = self.selectedImages[indexPath.row]
        return cell
    }
    
    /// 아이템간 좌우 간격
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    /// 아이템 크기 설정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewWidth,
                      height: self.collectionViewWidth)
    }
}



extension DetailWritingScreenController: ImageCollectionViewDelegate {
    /// 이미지 우상단 삭제 버튼을 눌리면 불리는 메서드
    func cellDeleteBtnTapped() {
        // 현재 페이지 타입캐스팅
        let page = Int(self.currentPage)
        // 이미지 삭제
        self.deleteImage(page: page)
        // 배열의 마지막이라면, 첫번째 페이지가 아니라면
        if page == self.selectedImages.count
            && page != 0 {
            // -> 현재 페이지 -1
            self.currentPage -= 1
        }
    }
}








// MARK: - 콜렉션뷰 스클로뷰
extension DetailWritingScreenController {
    /// 콜렉션뷰에서 스크롤이 끝났을 때
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView, // 스크롤뷰(컬렉션뷰)
        withVelocity velocity: CGPoint, // 스크롤하다 터치 해제 시 속도
        targetContentOffset: UnsafeMutablePointer<CGPoint>) // 스크롤 속도가 줄어들어 정지될 때 예상되는 위치
    {
        // 현재 x의 offset위치
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        // 스크롤뷰의 크기 + 왼쪽 insets값
        let cellWidth = self.collectionViewWidth + 20
        
        // 스크롤한 위치값
        var index = scrolledOffsetX / cellWidth
        
        // 이동하는 위치 가져오기
        let scrolledX = scrollView.contentOffset.x
        let pointeeX = targetContentOffset.pointee.x
        
        // 어디서 어디로 스크롤하는지 확인
        if scrolledX > pointeeX {
            // 왼쪽 -> 오른쪽으로 갈 때 자연스럽게
            index = floor(index)
        } else if scrolledX < pointeeX {
            // 오른쪽 -> 왼쪽으로 갈 때 자연스럽게
            index = ceil(index)
        } else {
            index = round(index)
        }
        
        
        // 한 페이지씩 움직일 수 있도록 설정
        // 페이지 이동 (+델리게이트)
        if self.currentPage > index {
            self.currentPage -= 1
        } else if currentPage < index {
            self.currentPage += 1
        }
        
        // 현재 페이지 저장
        index = self.currentPage
        // 스크롤 속도가 줄어들어 정지될 때 예상되는 위치 설정
        // 즉, 멈출 페이지
        targetContentOffset.pointee = CGPoint(
            x: index * cellWidth - scrollView.contentInset.left,
            y: scrollView.contentInset.top)
    }
}










// MARK: - 스와이프로 뒤로가기
extension DetailWritingScreenController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer)
    -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
