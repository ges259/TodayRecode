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
    
    /// safeArea뷰
    private lazy var whiteView: UIView = UIView.backgroundView(
        color: UIColor.white)
    
    /// 하단 악세서리 뷰
    private lazy var accessoryCustomView: InputAccessoryCustomView = {
        let view = InputAccessoryCustomView()
            view.delegate = self
        return view
    }()
    
    
    /// 날짜 표시해주는 뷰 (+ 레이블)
    private let dateView: DateView = DateView()
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configreUI()
        self.configureAutoLayout()
    }
    
    
    
    
    
    
    
    
    // MARK: - 화면 설정
    private func configreUI() {
        
    }
    
    
    
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        [self.backgroundImg,
         self.accessoryCustomView,
         self.dateView].forEach { view in
            self.view.addSubview(view)
        }
        // 배경화면
        self.backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 스택뷰 (카메라/앨범/날짜)
        self.accessoryCustomView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        // 날짜 뷰
        self.dateView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(35)
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
    }
}
