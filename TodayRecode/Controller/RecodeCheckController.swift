//
//  RecodeCheckController.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/23.
//

import UIKit
import SnapKit
import PanModal

final class RecodeCheckController: UIViewController {
    
    // MARK: - 레이아웃
    private lazy var containerView: UIView = UIView.backgroundView(
        color: UIColor.white)
    
    /// 날짜 표시해주는 뷰 (+ 레이블)
    private lazy var dateView: DateView = DateView()
    
    private lazy var separatorView: UIView = UIView.backgroundView(
        color: UIColor.lightGray)
    
    /// 테이블뷰
    private lazy var tableView: RecodeTableView = {
        let tableView = RecodeTableView()
            tableView.register(RecodeTableViewCell.self,
                               forCellReuseIdentifier: Identifier.recodeTableCell)
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
            view.backgroundColor = .customWhite5
        return view
    }()
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    
    var todayRecordArray = [Record]() {
        didSet {
            if let todayRecodes = self.todayRecordArray.first {
                self.dateView.configureDate(selectedDate: todayRecodes.date)
            }
        }
    }
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureDevice()
    }
}
    
    
    
    
    
    
    
    


// MARK: - 화면 설정

extension RecodeCheckController {
    
    // MARK: - UI설정
    private func configureUI(){
        self.view.backgroundColor = .clear
        
        
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 15
    }
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.stackView)
        self.containerView.addSubview(self.noDataView)
        
        // ********** 오토레이아웃 설정 **********
        // 날짜뷰
        self.dateView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        self.separatorView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
        }
        // 테이블뷰
        self.tableView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(300)
        }
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
        }
        // 컨테이너뷰
        self.containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        // 데이터가 없을 때 나오는 레이블
        self.noDataView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.tableView)
            make.height.equalTo(300)
        }
    }
    
    
    private func configureDevice() {
        // 아이폰 종류 확인
        if UIDevice.current.isiPhoneSE {
            //se or 8
            self.stackView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
        } else {
            // 10이상
            self.stackView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -40).isActive = true
        }
    }
}










// MARK: - 테이블뷰 데이터소스
extension RecodeCheckController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        self.noDataView.isHidden = self.todayRecordArray.count == 0
        ? false
        : true
        
        return self.todayRecordArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.recodeTableCell,
            for: indexPath) as! RecodeTableViewCell
        
        
        cell.cellRecord = self.todayRecordArray[indexPath.row]
        
        return cell
    }
}










// MARK: - 스크롤뷰
extension RecodeCheckController {
    // 스크롤이 끝났을 때
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y == 0 {
            self.dismiss(animated: true)
        }
    }
}




 





// MARK: - 판모달 설정
extension RecodeCheckController: PanModalPresentable {
    /// 스크롤뷰
    var panScrollable: UIScrollView? {
        return nil
    }
    /// 최대 사이즈
    var longFormHeight: PanModalHeight {
        // 아이폰 종류 확인
        return UIDevice.current.isiPhoneSE
        ? .contentHeight(self.containerView.frame.height) //se or 8
        : .contentHeight(self.containerView.frame.height - 33) // 10이상
    }
    /// 최소 사이즈
    var shortFormHeight: PanModalHeight {
        // 아이폰 종류 확인
        return UIDevice.current.isiPhoneSE
        ? .contentHeight(self.containerView.frame.height) //se or 8
        : .contentHeight(self.containerView.frame.height - 33) // 10이상
    }
    // 배경 색
    var panModalBackgroundColor: UIColor {
        return #colorLiteral(red: 0.3215686275, green: 0.3221649485, blue: 0.3221649485, alpha: 0.64)
    }
    
    var allowsExtendedPanScrolling: Bool {
        return true
    }
}
