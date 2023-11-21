//
//  Protocol.swift
//  TodayRecode
//
//  Created by 계은성 on 2023/10/17.
//

import UIKit

protocol AuthenticationDelegate: AnyObject {
    func authenticationComplete()
}

protocol AccessoryViewDelegate: AnyObject {
    func cameraBtnTapped()
    func albumBtnTapped()
    func accessoryRightBtnTapped()
}


protocol DeleteAccountCheckDelegate: AnyObject {
    func accountDelete(mode: LoginMethod)
}




protocol EasyWritingScreenDelegate: AnyObject {
    func expansionBtnTapped(context: String?)
    func createRecord(record: Record?)
}

protocol DetailWritingScreenDelegate: AnyObject {
    func createRocord(record: Record?)
    func updateRecord(record: Record?)
    func deleteRecord(success: Bool)
}


protocol CalendarDelegate: AnyObject {
    func selectDate(date: Date)
    func heightChanged(height: CGFloat)
    func monthChanged(date: Date)
}



protocol ImageCollectionViewDelegate: AnyObject {
    func cellDeleteBtnTapped()
}

protocol CollectionViewDelegate: AnyObject {
    func itemDeleteBtnTapped(index: Int)
    func itemTapped(index: Int)
    func collectionViewScrolled(index: Int)
}
