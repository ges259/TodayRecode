//
//  RecodeCheckController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/23.
//

import UIKit
import SnapKit
import PanModal

final class RecordCheckController: UIViewController {
    
    // MARK: - 레이아웃
    private lazy var containerView: UIView = UIView.backgroundView(
        color: UIColor.white)
    
    /// 날짜 표시해주는 뷰 (+ 레이블)
    private lazy var dateView: DateView = DateView()
    
    private lazy var separatorView: UIView = UIView.backgroundView(
        color: UIColor.lightGray)
    
    /// 테이블뷰
    private lazy var tableView: RecordTableView = {
        let tableView = RecordTableView()
            tableView.dataSource = self
            tableView.delegate = self
        return tableView
    }()
    
    /// 스택뷰
    private lazy var stackView: UIStackView = UIStackView.configureStackView(
        arrangedSubviews: [self.dateView,
                           self.separatorView,
                           self.tableView],
        axis: .vertical,
        spacing: 3,
        alignment: .fill,
        distribution: .fill)
    
    /// Record데이터가 없을 때 보이는 뷰
    private lazy var noDataView: NoRecordDataView = {
        let view = NoRecordDataView(
            frame: .zero,
            nodataEnum: .record_Check)
            view.backgroundColor = .white_Base
        return view
    }()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    var todayRecordArray = [Record]()
    
    lazy var todayDate: Date? = Date()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
    }
    init(recordArray: [Record]) {
        self.todayRecordArray = recordArray
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
    
    
    
    
    
    
    


// MARK: - 화면 설정

extension RecordCheckController {
    
    // MARK: - UI설정
    private func configureUI() {
        // 날짜 설정
        if let today = self.todayDate {
            self.dateView.configureDate(selectedDate: today)
        }
        
        // cornerRadius
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 15
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.stackView)
        
        
        // ********** 오토레이아웃 설정 **********
        // 오늘 기록이 없다면 -> NoDataView를 띄워야 함
        // 오늘 기록이 있다면 -> 모든 셀의 높이만큼 테이블뷰 높이 설정
        if self.todayRecordArray.count == 0 {
            // 데이터가 없을 때 나오는 레이블
            self.containerView.addSubview(self.noDataView)
            self.noDataView.snp.makeConstraints { make in
                make.top.leading.trailing.equalTo(self.tableView)
                make.height.equalTo(300)
            }
        }
        // 테이블뷰
        self.tableView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(300)
        }
        // 날짜뷰
        self.dateView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        self.separatorView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
        }
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
        }
        // 스택뷰 바텀앵커 분기처리
        self.configureStackViewBottomAchor()
        // 컨테이너뷰
        self.containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualTo(self.view.snp.bottom)
        }
    }
    
    // MARK: - 오토레이아웃 분기처리
    private func configureStackViewBottomAchor() {
        // 아이폰 종류 확인
        if UIDevice.current.isiPhoneSE {
            // se or 8
            self.stackView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
        } else {
            // 10이상
            self.stackView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -20).isActive = true
        }
    }
}










// MARK: - 테이블뷰 데이터소스
extension RecordCheckController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        self.noDataView.isHidden = self.todayRecordArray.count == 0
        ? false
        : true
        
        return self.todayRecordArray.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.recodeTableCell,
            for: indexPath) as! RecordTableViewCell
        
            cell.cellRecord = self.todayRecordArray[indexPath.row]
        return cell
    }
}




 





// MARK: - 판모달 설정
extension RecordCheckController: PanModalPresentable {
    /// 스크롤뷰
    var panScrollable: UIScrollView? {
        return self.tableView
    }
    /// 최대 사이즈
    var longFormHeight: PanModalHeight {
        self.view.layoutIfNeeded()
        
        // 아이폰 종류 확인
        return UIDevice.current.isiPhoneSE
        ? .contentHeight(self.containerView.frame.height) //se or 8
        : .contentHeight(self.containerView.frame.height - 33) // 10이상
    }
    /// 최소 사이즈
    var shortFormHeight: PanModalHeight {
        self.view.layoutIfNeeded()
        // 아이폰 종류 확인
        return UIDevice.current.isiPhoneSE
        ? .contentHeight(self.containerView.frame.height) //se or 8
        : .contentHeight(self.containerView.frame.height - 33) // 10이상
    }
    // 배경 색
    var panModalBackgroundColor: UIColor {
        return #colorLiteral(red: 0.3215686275, green: 0.3221649485, blue: 0.3221649485, alpha: 0.64)
    }
    /// 상단 인디케이터 없애기
    var showDragIndicator: Bool {
        return false
    }
}
