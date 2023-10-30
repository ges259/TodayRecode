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
    
    
    
    
    // MARK: - 프로퍼티
    /// 셀의 개수
    private var tableCellCount: Int = 0
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureAutoLayout()
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
        
        // ********** 오토레이아웃 설정 **********
        // 날짜뷰
        self.dateView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        self.separatorView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
        }
        // 테이블뷰
//        self.tableView.snp.makeConstraints { make in
//            make.height.greaterThanOrEqualTo(100)
//        }
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
            // 10이상
            make.bottom.equalToSuperview().offset(-40)
            
            // se
//            make.bottom.equalToSuperview()
        }
        // 컨테이너뷰
        self.containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}










// MARK: - 테이블뷰 데이터소스
extension RecodeCheckController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.tableCellCount
//        return 20
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.recodeTableCell,
            for: indexPath) as! RecodeTableViewCell
            cell.settingContext(recode: array[indexPath.row])
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
        // 10이상
        return .contentHeight(self.containerView.frame.height - 33)
        //se
//        return .contentHeight(self.containerView.frame.height)
    }
    /// 최소 사이즈
    var shortFormHeight: PanModalHeight {
        // 10이상
        return .contentHeight(self.containerView.frame.height - 33)
        
        
        // se
//        return .contentHeight(self.containerView.frame.height)
    }
    // 배경 색
    var panModalBackgroundColor: UIColor {
        return #colorLiteral(red: 0.3215686275, green: 0.3221649485, blue: 0.3221649485, alpha: 0.64)
    }
    
    var allowsExtendedPanScrolling: Bool {
        return true
    }
}
