//
//  Protocol.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//

import Foundation



protocol AccessoryViewDelegate: AnyObject {
    func cameraBtnTapped()
    func albumBtnTapped()
    func accessoryRightBtnTapped()
}






protocol EasyWritingScreenDelegate: AnyObject {
    func expansionBtnTapped(context: String?)
    func createRecord(record: Record)
}

protocol DetailWritingScreenDelegate: AnyObject {
    func createRocord(record: Record)
    func updateRecord(context: String, image: String?)
    func deleteRecord()
}


protocol CalendarDelegate: AnyObject {
    func selectDate(date: Date)
    func heightChanged(height: CGFloat)
    func monthChanged(date: Date)
}



protocol ImageCollectionViewDelegate: AnyObject {
    func deleteBtnTapped()
}

protocol CollectionViewDelegate: AnyObject {
    func itemDeleteBtnTapped(index: Int)
    func itemTapped()
    func collectionViewScrolled()
}
