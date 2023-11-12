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
    /// 배경 뷰
    private lazy var backgroundImg: UIImageView = UIImageView(
        image: UIImage.blueSky)
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
    /// 컨텐트뷰 (- 스크롤뷰)
    private lazy var contentView: UIView = UIView()
    
    /// 텍스트뷰
    lazy var diaryTextView: UITextView = {
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
    private let recodeShowBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.recodeShow,
        tintColor: UIColor.black,
        backgroundColor: UIColor.white)
    
    // 악세서리 뷰
    /// 카메라 버튼
    private let cameraBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.camera,
        tintColor: UIColor.btnGrayColor)
    /// 앨범 버튼
    private let albumBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.album,
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
    /// 키보드 내리기 버튼
    private let keyboardDownBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.keyboardDown,
        tintColor: UIColor.btnGrayColor)
    
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
        // 최대 5개 선택 가능
        imagePicker.settings.selection.max = 5
        
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        imagePicker.settings.theme.selectionFillColor = .white
        imagePicker.settings.theme.selectionStrokeColor = .black
        
        imagePicker.settings.preview.enabled = true
        
        // 버튼 설정
        imagePicker.title = "이미지 선택"
        imagePicker.doneButtonTitle = "선택완료"
        
        imagePicker.doneButton.tintColor = UIColor.black
        imagePicker.cancelButton.tintColor = UIColor.black
        
        return imagePicker
    }()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    /// 일기 모드 / 기록 모드를 알 수 있는 enum변수
    var detailViewMode: DetailViewMode?
    /// 델리게이트
    weak var delegate: DetailWritingScreenDelegate?
    
    
    /// 기록 확인 화면에서 오늘 기록을 볼 수 있게 하는 Record배열
    lazy var todayRecords: [Record] = []
    /// 셀을 클릭하여 상세작성 화면에 들어온 경우
    var selectedRecord: Record? {
        didSet {
            if let selectedRecord = selectedRecord {
                dump(selectedRecord)
            }
        }
    }
    
    
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
    /// 현재 콜렉션뷰의 페이지를 보여주는 변수
    private var currentPage: CGFloat = 0
    /// 키보드가 올라와있는지 확인하는 변수
    private var keyboardShow: Bool = false
    
    
    /// 콜렉션뷰의 넓이 (콜렉션뷰의 CGSize를 설정할 때 사용)
    private lazy var collectionViewWidth = self.collectionView.frame.width
    
    
    
    
    // 이미지 관련 배열
    private lazy var selectedAssets: [PHAsset] = []
    
    /// 모든 이미지
    private lazy var selectedImages: [UIImage] = [] {
        didSet {
            self.collectionView.reloadData()
            // MARK: - Fix
            self.collectionView.isHidden = self.selectedImages.count == 0
            ? true
            : false
        }
    }
    /// 추가된 이미지
    private lazy var addedImages: [UIImage] = []
    /// url_String을 저장하는 배열
    private var urlString: [String] = [] {
        didSet {
            dump(urlString)
        }
    }
    lazy var imageIsChanged: Bool = false
    
    
    
    private var createOrUpdate: () {
        // 뒤로가기
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
        self.configureNavBtn()      // 네비게이션바 오른쪽 버튼 및 타이틀 설정
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
    }
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    



// MARK: - 화면 설정
    
extension DetailWritingScreenController {
    
    // MARK: - UI 설정
    private func configreUI() {
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
        // 스크롤뷰
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.verticalStackView)
        // 컨테이너뷰
        self.accessoryCustomView.addSubview(self.horizontalStackView)
        self.accessoryCustomView.addSubview(self.keyboardDownBtn)
        
        
        // ********** 오토레이아웃 설정 **********
        // 배경화면
        self.backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
            make.bottom.equalToSuperview().offset(-10)
        }
        // 플레이스 홀더
        self.placeholderLbl.snp.makeConstraints { make in
            make.top.equalTo(self.diaryTextView).offset(18)
            make.leading.equalTo(self.diaryTextView).offset(14)
        }
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
        self.recodeShowBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-17)
            make.trailing.equalToSuperview().offset(-17)
            make.width.height.equalTo(58)
        }
        // 네비게이션 타이틀
        self.navTitle.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(200)
        }
    }
    
    
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.recodeShowBtn.addTarget(self, action: #selector(self.recodeShowBtnTapped), for: .touchUpInside)
        self.keyboardDownBtn.addTarget(self, action: #selector(self.keyboardDownBtnTapped), for: .touchUpInside)
        self.cameraBtn.addTarget(self, action: #selector(self.cameraBtnTapped), for: .touchUpInside)
        self.albumBtn.addTarget(self, action: #selector(self.albumBtnTapped), for: .touchUpInside)
    }
    
    
    
    // MARK: - 오른쪽 네비게이션바 설정
    private func configureNavBtn() {
        // ********** 네비게이션 오르쪽 버튼 설정 **********
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.option,
            style: .plain,
            target: self,
            action: .none)
        // 오른쪽 네비게이션 설정
        // 메뉴 액션 설정
        let addRecodeMenu = UIAction(title: "기록 추가", image: UIImage.plus) { _ in
            self.addRecodeBtnTapped()
        }
        let deleteMenu = UIAction(title: "삭제", image: UIImage.trash) { _ in
            self.deleteBtnTapped()
        }
        // 오른쪽 네비게이션 메뉴 버튼 설정
        self.navigationItem.rightBarButtonItem?.menu
        // 네비게이션 타이틀 및 메뉴 버튼 설정
            // (.record && 오늘) 인 경우에만 기록 추가 버튼 활성화
        = self.detailViewMode == .diary || !self.isToday
        // [삭제 버튼]
        ? UIMenu(children: [deleteMenu])
        // [기록 추가 버튼, 삭제 버튼]
        : UIMenu(children: [addRecodeMenu, deleteMenu])
        
        
        
        // ********** 네비게이션 왼쪽 버튼 설정 **********
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.back,
            style: .plain,
            target: self,
            action: #selector(self.leftNavBtnTapped))
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
            // 가져온 이미지 url저장
            self.urlString = currentRecode.imageUrl
            // url -> 이미지로 변환
            self.loadImage(imageUrl: currentRecode.imageUrl)

            
            
            
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
}
    
    









    
    
    



    
    
    
// MARK: - 액션 + 셀렉터
    
extension DetailWritingScreenController {
    
    // MARK: - 노티피케이션 액션
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
    /// 화면 내리기 + 스택뷰 간격 설정
    private func keyboardStateChanged(keyboard_Up: Bool,
                                      keyboardSize: CGFloat) {
        // ********** 키보드 올리는 상황 **********
        if keyboard_Up {
            // 화면 올리기
            self.view.frame.origin.y -= keyboardSize
            // 화면 올리는 만큼 스택뷰 간격을 넓혀 텍스트뷰가 가려지지 않게 설정
            self.verticalStackView.setCustomSpacing(keyboardSize - 33,
                                                    after: self.dateView)
        // ********** 키보드 내리는 상황 **********
        } else {
            // 화면 내리기
            self.view.frame.origin.y = 0
            // 스택뷰 간격 설정 (뷰를 올리면 키보드에 가려지는 현상 때문)
            self.verticalStackView.setCustomSpacing(7, after: self.dateView)
        }
        // ********** 모든 상황 **********
        // 네비게이션 타이틀(String) 설정
        self.setNavTitle(date: self.todayDate ?? Date(),
                         keyboard_Up: keyboard_Up)
        // 키보드 상태 바뀜 표시
        self.keyboardShow.toggle()
    }
    
    
    
    // MARK: - 기록 추가 버튼
    @objc private func addRecodeBtnTapped() {
        // 업데이트인지 생성인지 확인
        _ = self.detailViewMode == .record_CellTapped
        ? self.updateRecord_API()
        : self.createRecord_API()
        // 앞으로는 쭉 [생성]이기 때문에 플러스 버튼으로 바꿔줌 (플러스 버튼으로 들어온 상황 == 생성)
        self.detailViewMode = .record_plusBtn
        // 화면 초기화
        self.selectedRecord = nil
        self.diaryTextView.text = nil
        self.configureData()
    }
    
    
    
    // MARK: - 삭제 버튼
    @objc internal func deleteBtnTapped() {
        // 얼럿창 띄우기
        self.customAlert(
            withTitle: "정말 삭제 하시겠습니까?",
            firstBtnName: "삭제하기",
            firstBtnColor: UIColor.red) { _ in
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
    /// 카메라 버튼을 누르면
    @objc private func cameraBtnTapped() {
        print(#function)
    }
    /// 앨범 버튼을 누르면 이미지피커로 넘어간다.
    @objc private func albumBtnTapped() {
        self.imagePickerAction()
    }
    /// 기록 확인 버튼을 누르면 오늘 기록을 볼 수 있다.
    @objc private func recodeShowBtnTapped() {
        self.diaryTextView.resignFirstResponder()
        let recodeCheckVC = RecodeCheckController(recordArray: self.todayRecords)
            recodeCheckVC.modalPresentationStyle = .overFullScreen
        // 화면 전환
        self.presentPanModal(recodeCheckVC)
    }
    
    
    
    
    
    // MARK: - 네비게이션 타이틀 재설정
    /// 선택된 날짜에 따라 네비게이션 타이틀을 설정하는 메서드
    private func setNavTitle(date: Date = Date(), keyboard_Up: Bool) {
        let navEnum: NavTitleSetEnum = .M월d일
        
        let navMainTitle: String = self.detailViewMode == .diary
        ? navEnum.diary_String
        : navEnum.record_String
        
        if keyboard_Up {
            self.navTitle.attributedText = self.configureNavTitle(
                navMainTitle,
                navTitleSetEnum: navEnum,
                date: date)
        } else {
            self.navTitle.text = navMainTitle
        }
    }
    
    
    
    
    
    // MARK: - 이미지 액션
    private func imagePickerAction() {
        // 이미지가 5개면 더이상 추가 못 함
        self.presentImagePicker(self.imagePicker, select: {
            (asset) in
                // 사진 하나 선택할 때마다 실행되는 내용 쓰기
            print("select")
        }, deselect: {
            (asset) in
                // 선택했던 사진들 중 하나를 선택 해제할 때마다 실행되는 내용 쓰기
            print("deSelect")
        }, cancel: {
            (assets) in
                // Cancel 버튼 누르면 실행되는 내용
            print("cancel")
        }, finish: {
            (assets) in
                // Done 버튼 누르면 실행되는 내용
            print("done")
            
            _ = self.selectedImages.count + assets.count >= 6
            ? self.goAlert()
            : self.imagePlus(assets: assets)
        })
    }
    
    private func goAlert() {
        DispatchQueue.main.async {
            self.customAlert(
                alertStyle: .alert,
                withTitle: "이미지는 5개를 넘을 수 없습니다.") { _ in }
        }
    }
    
    private func imagePlus(assets: [PHAsset]) {
        // assets
        self.selectedAssets.removeAll()
        
        for i in assets {
            self.selectedAssets.append(i)
        }
        // PHAsset을 UIImage로 변환 후 저장
        let images = self.convertAssetToImage(selectedAssets: self.selectedAssets)
        
        self.imageIsChanged = true
        // 이미지 저장
        // -> 콜렉션뷰에 전달
        // -> 콜렉션뷰 리로드
        // 0개라면 콜렉션뷰 숨기기
        self.selectedImages.append(contentsOf: images)
        self.addedImages.append(contentsOf: images)
    }
    
    
    // MARK: - 화면 나가기 (+ API)
    @objc private func leftNavBtnTapped() {
        // 노티피케이션 삭제
        NotificationCenter.default.removeObserver(self)
        // 뒤로가기
        self.navigationController?.popViewController(animated: true)
        
        // 현재 모드 확인
        guard let mode = self.detailViewMode else { return }
        // 스위치문
        switch mode {
        // 플러스버튼을 통해 들어온 경우
        case .record_plusBtn:
            // 생성
            _ = self.addedImages.isEmpty
            ? self.createRecord_API()
            : self.imageUpload()
            break
            
        // 셀을 통해 들어온 경우
        case .record_CellTapped:
            // 업데이트
            _ = self.addedImages.isEmpty
            ? self.updateRecord_API()
            : self.imageUpload()
            break
            
        // 일기목록화면을 통해 들어온 경우
        case .diary:
            // 오늘인 경우만 저장
            guard self.isToday else { return }
            // 생성 or 업데이트
            _ = self.addedImages.isEmpty
            ? self.createOrUpdate
            : self.imageUpload()
            break
        }
    }
    
    
    
    private func deleteImage(page: Int) {
        if self.urlString.count > page {
            // url삭제
            self.urlString.remove(at: page)
            self.selectedImages.remove(at: page)
            
        // urlString이 존재
        } else if urlString.count != 0 {
            self.selectedImages.remove(at: page)
            let index = page - (self.urlString.count)
            self.addedImages.remove(at: index)
        // urlString이 존재X
        } else {
            self.selectedImages.remove(at: page)
            self.addedImages.remove(at: page)
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
                                       imageUrl: self.urlString) { result in
            switch result {
            case .success(_):
                print("데이터 삭제 성공")
                // 셀 삭제
                self.delegate?.deleteRecord(success: true)
                break
            case .failure(_):
                // Fix
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
                                       image: self.urlString) { result in
            switch result {
            case .success(let record):
                print("데이터 업데이트 성공")
                
                self.delegate?.updateRecord(record: record)
                break
            case .failure(_):
                // Fix
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
                                       image: self.urlString) { result in
            switch result {
            case .success(let record):
                print("데이터 생성 성공")
                // 셀 업데이트
                self.delegate?.createRocord(record: record)
                break
            case .failure(_):
                // Fix
                self.delegate?.createRocord(record: nil)
                break
            }
        }
    }
    
    
    // MARK: - 이미지 업로드
    private func imageUpload() {
        // 이미지 업로드
        ImageUploader.shared.uploadImage(image: self.addedImages) { urlStrings in
            // url_String 추가
            self.urlString.append(contentsOf: urlStrings)
            // 생성 or 업데이트
            self.createOrUpdate
        }
    }
    
    // MARK: - 이미지 로드
    private func loadImage(imageUrl: [String]) {
        ImageUploader.shared.loadImageView(with: imageUrl) { imgString in
            DispatchQueue.main.async {
                guard let imgString = imgString else { return }
                self.selectedImages = imgString
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImages.count
    }
    
    /// 아이템 표현?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    ///
    func cellDeleteBtnTapped() {
        
        self.imageIsChanged = true
        
        // 현재 페이지 타입캐스팅
        let page = Int(self.currentPage)
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
