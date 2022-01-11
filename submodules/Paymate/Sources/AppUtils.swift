//
//  AppUtils.swift
//  TelegramSample
//
//  Created by Heymate on 19/09/21.
//

import Foundation
import UIKit

public struct AppUtils {
    
    static let sharedInstance = AppUtils()
    
    private static let LOGIN_TOKEN = "LOGIN_TOKEN"
    
    private static let FORMATTER_SCHEDULE_DATE = "E, MM.dd.yyyy"
    private static let FORMATTER_SCHEDULE_TIME = "HH:mm"
    private static let FORMATTER_EXPIRE_DATE = "MM-dd-yyyy"
    private static let FORMATTER_OFFER_DATE = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    private static let FORMATTER_OFFER_DISPLAY = "E MMM dd yyyy HH:mm"
    private static let LOGIN_PHONE = "Phone_number"
    
    static func COLOR_BLACK() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor(named: "COLOR_BLACK")!
        } else {
            return UIColor.black
        }
    }
    
    static func COLOR_GRAY4() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor(named: "COLOR_GRAY4")!
        } else {
            return UIColor.black
        }
    }
    static func COLOR_GRAY3() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor(named: "COLOR_GRAY3")!
        } else {
            return UIColor.black
        }
    }
    static func COLOR_BLUE() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor(named: "COLOR_BLUE")!
        } else {
            return UIColor.black
        }
    }
    static func COLOR_GREEN() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor(named: "COLOR_GREEN")!
        } else {
            return UIColor.black
        }
    }
    
    static func COLOR_LIGHT_GRAY() -> UIColor {
        return UIColor(red: 0.506, green: 0.525, blue: 0.541, alpha: 1)
    }
    static func COLOR_LIGHT_GRAY2() -> UIColor {
        return UIColor(red: 97/255, green: 101/255, blue: 104/255, alpha: 1)
    }
    static func COLOR_LIGHT_GRAY6() -> UIColor {
        return UIColor(red: 236/255, green: 237/255, blue: 241/255, alpha: 1)
    }
    static func COLOR_GREEN2() -> UIColor {
        return UIColor(red: 30/255, green: 117/255, blue: 12/255, alpha: 1)
    }
    static func COLOR_PRIMARY_GREEN() -> UIColor {
        return UIColor(red: 92/255, green: 176/255, blue: 80/255, alpha: 1)
    }
    
    static func COLOR_PRIMARY2() -> UIColor {
        return UIColor(red: 81/255, green: 125/255, blue: 162/255, alpha: 1)
    }
    
    static func COLOR_PRIMARY3() -> UIColor {
        return UIColor(red: 28/255, green: 147/255, blue: 227/255, alpha: 1)
    }
    
    static func COLOR_PRIMARY6() -> UIColor {
        return UIColor(red: 223/255, green: 242/255, blue: 252/255, alpha: 1)
    }
    static func COLOR_GREEN3() -> UIColor {
        return UIColor(red: 217/255, green: 247/255, blue: 197/255, alpha: 1)
    }

    static func COLOR_YELLOW() -> UIColor {
        return UIColor(red: 255/255, green: 181/255, blue: 49/255, alpha: 1)
    }
    static func COLOR_YELLOW5() -> UIColor {
        return UIColor(red: 255/255, green: 244/255, blue: 224/255, alpha: 1)
    }
    
        
    static func POPOVER_BACKGROUND() -> UIColor { return UIColor(red: 0, green: 0, blue: 0, alpha: 0.5) }
    
    static func APP_FONT(size:CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func APP_MEDIUM_FONT(size:CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    static func getScheduleDateAndTime(date:Date) -> (date:String,time:String) {
        var details = (date:"",time:"")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FORMATTER_SCHEDULE_DATE
        details.date = dateFormatter.string(from: date)
        dateFormatter.dateFormat = FORMATTER_SCHEDULE_TIME
        details.time = dateFormatter.string(from: date)
        return details
    }
    
    static func getDateByAdding(component:Calendar.Component,value:Int,toDate:Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: component, value: value, to: toDate) ?? Date()
    }
    
    static func getExpireDateView(_ date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FORMATTER_EXPIRE_DATE
        return dateFormatter.string(from: date)
    }
    
    static func getOfferDetailsViewDateFormat(string:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FORMATTER_OFFER_DATE
        if let date = dateFormatter.date(from: string) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = FORMATTER_OFFER_DISPLAY
            return displayFormatter.string(from: date)
        }
        return string
    }
    
    public static func saveLoginMobileNumber(_ number:String) {
        print("saved login \(number)")
        UserDefaults.standard.setValue(number, forKey: AppUtils.LOGIN_PHONE)
    }
    
    public static func getLoginPhoneNumber() -> String? {
        return UserDefaults.standard.value(forKey: LOGIN_PHONE) as? String
    }
    
    public static func getScheduledDateDisplay(milliSeconds:Double) -> String  {
        let date = Date(timeIntervalSince1970: TimeInterval((milliSeconds)))
//        print("date - \(date)")
        let FORMATTER_OFFER_DISPLAY = "E MMM dd yyyy HH:mm a"
        let formatter = DateFormatter()
        formatter.dateFormat = FORMATTER_OFFER_DISPLAY
        let converted = formatter.string(from: date)
//        print("converted \(converted)")
        return converted
    }
    
    public static func persistOfferDetails(_ offer:OfferDetails,offerId:String) {
        do {
            let data = try JSONEncoder().encode(offer)
            UserDefaults.standard.setValue(data, forKey: offerId)
        } catch {
            print("persistOfferDetails encode error \(error)")
        }
    }
    
    public static func getOfferDetails(id:String) -> OfferDetails? {
        do {
            if let data = UserDefaults.standard.data(forKey: id) {
                let decoder = try JSONDecoder().decode(OfferDetails.self, from: data)
                return decoder
            }
        } catch {
            print("getOfferDetails decode error \(error)")
        }
        return nil
    }
}

extension AppUtils {
    public static func saveLoginToken(token:String) {
        UserDefaults.standard.setValue(token, forKey: LOGIN_TOKEN)
    }
    
    public static func getLoginToken() -> String {
        return UserDefaults.standard.string(forKey: LOGIN_TOKEN) ?? ""
    }
}

extension AppUtils {

    private func appLabel() -> UILabel {
        let _label = UILabel()
        _label.text = ""
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.textColor = AppUtils.COLOR_BLACK()
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        _label.font = AppUtils.APP_FONT(size: 12)
        return _label
    }
    
    func getTitle2Label() -> UILabel {
        let label = appLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppUtils.APP_FONT(size: 16)
        return label
    }
    
    func getHeadingLabel() -> UILabel {
        let label = appLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppUtils.APP_FONT(size: 14)
        return label
    }
    
    func getSubHeadLabel() -> UILabel {
        let label = appLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppUtils.APP_FONT(size: 12)
        return label
    }
    
    func getTickMark() -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = AppUtils.COLOR_BLUE()
        btn.layer.cornerRadius = 4
        btn.isSelected = true
        btn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btn.setImage(UIImage(named: "tickMark"), for: .selected)
        btn.setImage(nil, for: .normal)
        return btn
    }
    
    func getRoundedButtonWithRadius(_ radius:CGFloat) -> UIButton {
        let _button = UIButton(type: .roundedRect)
        _button.isSelected = false
        _button.clipsToBounds = true
        _button.layer.cornerRadius = radius
        _button.titleLabel?.lineBreakMode = .byWordWrapping
        _button.titleLabel?.numberOfLines = 0
        _button.setTitleColor(UIColor.black, for: .normal)
        _button.translatesAutoresizingMaskIntoConstraints = false
        return _button
    }
    
    func getButtonWithLeftImageAndRightText(image:UIImage,title:String) -> UIButton {
        let _btn: UIButton = UIButton(type: .roundedRect)
        _btn.setImage(image, for: .normal)
        _btn.setTitle(title, for: .normal)
        _btn.setTitleColor(UIColor.black, for: .normal)
        _btn.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 16, bottom: 0.0, right: 0.0)
        _btn.contentHorizontalAlignment = .left
        return _btn
    }
    
    func getSectionHeaderView(title:String,parent:UIView) -> UIView {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: parent.frame.size.width, height: 44))
        v.backgroundColor = .white
        let _label = UILabel(frame: CGRect(x: 16, y: 8, width: v.frame.size.width, height: v.frame.size.height))
        _label.backgroundColor = .white
         _label.textColor = UIColor(red: 41/255, green: 169/255, blue: 235/255, alpha: 1.0)
        _label.font = UIFont.boldSystemFont(ofSize: 14.0)
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        _label.text = title
        v.addSubview(_label)
        return v
    }
    
    func getRadioButton(selected:Bool,title:String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "radio_selected"), for: .selected)
        btn.setImage(UIImage(named: "radio_unselected"), for: .normal)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(AppUtils.COLOR_BLUE(), for: .selected)
        btn.setTitleColor(AppUtils.COLOR_BLACK(), for: .normal)
        btn.isSelected = selected
        btn.titleLabel?.font = AppUtils.APP_FONT(size: 16)
        if #available(iOS 11.0, *) {
            btn.contentHorizontalAlignment = .leading
        } else {
            // Fallback on earlier versions
        }
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        return btn
    }
    
    
    func getRadioButtonWith(title:String,isSelected:Bool,right:String) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let radioButton = getRadioButton(selected:isSelected,title: title)
        radioButton.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        
        let rightLabel = AppUtils.sharedInstance.getTitle2Label()
        rightLabel.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        rightLabel.textAlignment = .right
        rightLabel.textColor = isSelected ? AppUtils.COLOR_BLUE() : AppUtils.COLOR_BLACK()
        rightLabel.text = "$\(right)"
        
        stackView.addArrangedSubview(radioButton)
        stackView.addArrangedSubview(rightLabel)
        
        return stackView
    }
}
