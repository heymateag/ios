//
//  PaymateExtensions.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 06/11/21.
//

import UIKit

extension UIView {
    func roundedPaymateView(cornerRadius:CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }
    
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = AppUtils.COLOR_GRAY4().cgColor
        layer.addSublayer(bottomLine)
    }
}

extension UIButton {
    func decorateAsCategoryButton() {
        self.setBackGroundColor(color: AppUtils.COLOR_BLUE(), state: .normal)
        self.setBackGroundColor(color: AppUtils.COLOR_GREEN(), state: .selected)
        self.isSelected = false
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.numberOfLines = 0
        self.setTitleColor(UIColor.white, for: .selected)
        self.setTitleColor(AppUtils.COLOR_GREEN(), for: .normal)
    }
    
    func configForCheckBox() {
        self.roundedPaymateView(cornerRadius: 4)
        self.setImage(UIImage(named: "tickMark"), for: .selected)
        self.setImage(nil, for: .normal)
        
    }
}

extension DateFormatter {
    static func scheduleDateFormatter() -> String {
        return "E MMM dd yyyy HH:mm a"
    }
    
    static func expireDateFormatter() -> String {
        return "yyyy-MM-dd"
    }
    
    static func currentTimeStamp() -> String {
        return  "yyyyMMddHHmmssSSS"
    }
}

extension Date {
    
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970).rounded())
    }
    
    static func getDateFromMilliSeconds(seconds:Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval((seconds)))
    }
    
    static func getClassRunningStatus(milliSeconds:Int) ->(completed:Bool,inFuture:Bool) {
        let date = Date.getDateFromMilliSeconds(seconds: milliSeconds)
        let result = date.compare(Date())
        let isPast = result == .orderedDescending
        let isFuture = result == .orderedAscending
        return (isPast,isFuture)
    }
    
    static func getDifferentComponents(date1:Date,date2:Date) -> DateComponents {
        return Calendar.current.dateComponents([.hour,.minute,.second], from: date1, to: date2)
    }
    
    static func getScheduleDisplayFormat(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.scheduleDateFormatter()
        return formatter.string(from: date)
    }
    
    static func getExpiryDisplayFormat(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.expireDateFormatter()
        return formatter.string(from: date)
    }
    
    static func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.currentTimeStamp()
        return formatter.string(from: Date())
    }
    
    static func getUnixTimestampInMillis() -> Double {
        return NSDate().timeIntervalSince1970
    }
}
