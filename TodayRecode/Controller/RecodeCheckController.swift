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
//    private lazy var containerView: UIView = UIView.backgroundView(
//        color: UIColor.white)
    
    /// 날짜 표시해주는 뷰 (+ 레이블)
    private lazy var dateView: DateView = DateView()
    
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
                           self.tableView],
        axis: .vertical,
        spacing: 7,
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
        
        
        self.dateView.backgroundColor = .white
        self.tableView.backgroundColor = .white
        
        self.tableView.clipsToBounds = true
        self.tableView.layer.cornerRadius = 10
    }
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        // ********** addSubview 설정 **********
        self.view.addSubview(self.stackView)
        
        // ********** 오토레이아웃 설정 **********
        // 날짜뷰
        self.dateView.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        // 테이블뷰
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        // 스택뷰
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(7)
            make.trailing.equalToSuperview().offset(-7)
            make.bottom.lessThanOrEqualToSuperview().offset(-7)
        }
    }
}










// MARK: - 테이블뷰 데이터소스
extension RecodeCheckController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.tableCellCount
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.recodeTableCell,
            for: indexPath) as! RecodeTableViewCell
        
        return cell
    }
}










// MARK: - 판모달 설정
extension RecodeCheckController: PanModalPresentable {
    /// 스크롤뷰
    var panScrollable: UIScrollView? {
        return self.tableView
    }
    /// 최대 사이즈
    var longFormHeight: PanModalHeight {
        return .contentHeight(self.view.frame.height)
    }
    /// 최소 사이즈
    var shortFormHeight: PanModalHeight {
        return .contentHeight(self.view.frame.height)
    }
    
    var panModalBackgroundColor: UIColor {
        return #colorLiteral(red: 0.3215686275, green: 0.3221649485, blue: 0.3221649485, alpha: 0.64)
    }
}
