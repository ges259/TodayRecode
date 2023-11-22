//
//  DiaryListCollectionViewCell.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/19.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - 레이아웃
    // ********** 공통 **********
    /// 이미지뷰
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.white_Base
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    
    // ********** DiaryList **********
    /// 이미지뷰 위를 덮는 white 색상 뷰
    private lazy var whiteCustomView: UIView = UIView.backgroundView(
        color: UIColor.white_Base)
    /// 날짜 레이블
    lazy var dateLbl: UILabel = {
        let lbl = UILabel.configureLbl(
            font: UIFont.boldSystemFont(ofSize: 30),
            textColor: UIColor.black)
        lbl.textAlignment = .center
        return lbl
    }()
    
    
    // ********** PhotoList **********
    /// 삭제 버튼
    private lazy var deleteBtn: UIButton = UIButton.buttonWithImage(
        image: UIImage.deleteBtn,
        tintColor: UIColor.lightGray)
    
    
    
    
    
    
    
    
    
    
    // MARK: - 프로퍼티
    var collectionViewEnum: CollectionViewEnum? {
        didSet { self.configureUIByEnum() }
    }
    
    weak var delegate: ImageCollectionViewDelegate?
    
    
    
    
    
    
    
    
    
    
    // MARK: - 라이프 사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.configureAutoLayout()
        self.configureAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    
    
    
    
    
    
    
    

// MARK: - 화면 설정

extension ImageCollectionViewCell {
    
    // MARK: - UI 설정
    private func configureUI() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    
    // MARK: - 오토레이아웃 설정
    private func configureAutoLayout() {
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Enum에 따른 오토레이아웃
    private func configureUIByEnum() {
        // 일기 목록 화면
        // Diary_List_Controller
        if self.collectionViewEnum == .diaryList {
            // 레이아웃 설정
            [self.whiteCustomView,
             self.dateLbl].forEach { view in
                // ********** addSubview 설정 **********
                self.addSubview(view)
                // ********** 오토레이아웃 설정 **********
                view.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        // 상세 작성 화면
        // Detail_Writing_Screen_Controller
        } else {
            self.addSubview(self.deleteBtn)
            self.deleteBtn.snp.makeConstraints { make in
                make.top.trailing.equalTo(self.imageView)
                make.width.height.equalTo(40)
            }
        }
    }
    
    // MARK: - 액션 설정
    private func configureAction() {
        self.deleteBtn.addTarget(self, action: #selector(self.deleteBtnTapped), for: .touchUpInside)
    }
}
    
 








// MARK: - 액션

extension ImageCollectionViewCell {
    
    // MARK: - 삭제 버튼 액션
    @objc private func deleteBtnTapped() {
        self.delegate?.cellDeleteBtnTapped()
    }
}
