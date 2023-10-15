//
//  CustomTableView.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/15.
//

import UIKit

final class CustomTableView: UITableView {

    override var contentSize: CGSize {
      didSet { self.invalidateIntrinsicContentSize() }
    }
    
    /*
     intrinsic_Content_Size
        - 자신의 컨텐츠 사이즈에 따라서 결정되는 뷰 사이즈
            - ex) 레이블 (width와 height를 설정해주지 않아도 글자의 크기에 맞춰 크기가 결정 됨)
     */
    /*
     View의 컨텐츠 크기가 바뀌었을 때 instrinsicContentSize 프로퍼티를 통해 size를 갱신하고 그에 맞게 auto_Layout을 업데이트되도록 만들어주는 메서드
     내부 사이즈가 변할 때마다 intrinsicContentSize 프로퍼티가 호출 됨
     */
    override var intrinsicContentSize: CGSize {
//        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric,
                      height: self.contentSize.height)
    }
}
