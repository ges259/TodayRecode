//
//  CustomTableView.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/15.
//

import UIKit

final class RecodeTableView: UITableView {
    
    // MARK: - 라이프사이클
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - 테이블뷰 크기 설정
    override var contentSize: CGSize {
      didSet { self.invalidateIntrinsicContentSize() }
    }
    /*
     - intrinsic_Content_Size
        - 자신의 컨텐츠 사이즈에 따라서 결정되는 뷰 사이즈
            - ex) 레이블 (width와 height를 설정해주지 않아도 글자의 크기에 맞춰 크기가 결정 됨)
     - view의 컨텐츠 크기가 바뀌었을 때 instrinsicContentSize 프로퍼티를 통해 size를 갱신하고 그에 맞게 auto_Layout을 업데이트되도록 만들어주는 메서드
     결론 -> 내부 사이즈가 변할 때마다 intrinsicContentSize 프로퍼티가 호출 됨
     */
    override var intrinsicContentSize: CGSize {
//        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric,
                      height: self.contentSize.height)
    }
    
    
    
    // MARK: - 화면 설정
    private func configureUI() {
        self.register(RecodeTableViewCell.self,
                      forCellReuseIdentifier: Identifier.recodeTableCell)
        // 배경 색상 설정
        self.backgroundColor = UIColor.clear
        // 바운스 되지 않게 설정
        self.bounces = false
        // 스크롤바 없애기
        self.showsVerticalScrollIndicator = false
        // 테이블뷰 셀간 구분선 없애기
        self.separatorStyle = .none
        // 테이블뷰가 스크롤되지 않도록 설정(스크롤뷰가 대신 스크롤 됨)
//        self.isScrollEnabled = false
        // 테이블뷰 높이 설정
        self.estimatedRowHeight = 200
        self.rowHeight = UITableView.automaticDimension
    }
}
