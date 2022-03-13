//
//  AppUtils.swift
//  TelegramSample
//
//  Created by Heymate on 19/09/21.
//

import Foundation
import UIKit
import TelegramCore
import web3swift
import WalletConnectSwift
import BigInt

public struct AppUtils {
    
    public static var sharedInstance = AppUtils()
    
    private static let LOGIN_TOKEN = "LOGIN_TOKEN"
    
    private static let FORMATTER_SCHEDULE_DATE = "E, MM.dd.yyyy"
    private static let FORMATTER_SCHEDULE_TIME = "HH:mm"
    private static let FORMATTER_EXPIRE_DATE = "MM-dd-yyyy"
    private static let FORMATTER_OFFER_DATE = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    private static let FORMATTER_OFFER_DISPLAY = "E MMM dd yyyy HH:mm"
    private static let LOGIN_PHONE = "Phone_number"
    private static let WC_SERVICE_HANDLER = "wcurl"
    private static let DEFAULT_CURRENCY = "Default_currency"
    public static let EURCurrency = "eur"
    public static let USDCurrency = "usd"
    private var _shouldPasteOffer = false
    private var _pasteOfferURL = ""
    
    public static let europeCodes:[String] = ["+30","+31","+32","+33","+36","+39","+40","+41","+43","+44","+45","+46","+48","+49","+298","+350","+352","+353","+354","+355","+356","+357","+358","+359","+370","+371","+372","+373","+375","+376","+377","+378","+379","+380","+381","+382","+383","+385","+386","+387","+389","+420","+421","+423"]
    
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

    
    static func COLOR_GREEN5() -> UIColor {
        return UIColor(red: 30/255, green: 117/255, blue: 12/255, alpha: 1)
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
    
    public static func getCurrencyOnMobileNumber() -> String {
        var currency = USDCurrency
        if let number = getLoginPhoneNumber() {
            if number.count > 3 {
                let countryCodeUpto3 = number.prefix(upTo: number.index(number.startIndex, offsetBy: 4))
                print("code \(countryCodeUpto3)")
                if europeCodes.contains(String(countryCodeUpto3)) {
                    print("its euro code")
//                    return "EUR"
                    currency = EURCurrency
                    return currency
                } else {
                    print("non euro code")
                }
                let countryCodeUpto2 = number.prefix(upTo: number.index(number.startIndex, offsetBy: 3))
                print("code \(countryCodeUpto2)")
                if europeCodes.contains(String(countryCodeUpto2)) {
                    print("its euro code")
                    currency = EURCurrency
                } else {
                    print("non euro code")
                }
            }
        }
        return currency
    }
    
    public mutating func setPasteOfferMode(paste:Bool,offerID:String) {
        _shouldPasteOffer = paste
        _pasteOfferURL = offerID
    }
    
    public func shouldPasteOffer() -> (paste:Bool,offerURL:String) {
        return (_shouldPasteOffer,_pasteOfferURL)
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
    public static func identifyURL(offer:String) -> URL? {
            do {
                let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let matches = detector.matches(in: offer, options: [], range: NSRange(location: 0, length: offer.utf16.count))
                return matches.first?.url
            } catch {
                print("identifyURL error  \(error)")
            }
            return nil
        }
    
    public static func saveWeb3Url(url:String?) {
        print("save web3 url \(url)")
        UserDefaults.standard.setValue(url, forKey: AppUtils.WC_SERVICE_HANDLER)
    }
    
    public static func getWeb3URL() -> String? {
        return UserDefaults.standard.string(forKey: AppUtils.WC_SERVICE_HANDLER)
    }
    
    public static func saveDefaultCurrency(_ currency:String)  {
        print("default currency \(currency)")
        UserDefaults.standard.setValue(currency, forKey: DEFAULT_CURRENCY)
    }
    
    public static func getDefaultCurrency() -> String? {
        return UserDefaults.standard.value(forKey: DEFAULT_CURRENCY) as? String
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
        let FORMATTER_OFFER_DISPLAY = "E MMM dd yyyy HH:mm"
        let formatter = DateFormatter()
        formatter.dateFormat = FORMATTER_OFFER_DISPLAY
        formatter.locale = Calendar.current.locale
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
    public static func hasLowBalance() -> String {

            

            let defaultCurrency = AppUtils.getDefaultCurrency()

            var stableToken = ""

            if defaultCurrency == "eur" {

                stableToken = Constants.StableTokenEUR

            } else if defaultCurrency == "usd" {

                stableToken = Constants.StableToken

            }

            

            let contractAddress = EthereumAddress(stableToken)

            let address = (WalletManager.currentAccount?.address)!

            let celoAddress = EthereumAddress(address)

            let bundlePath = Bundle.main.path(forResource: "stable_token_contracts", ofType: "json")

            let jsonString = try! String(contentsOfFile: bundlePath!)

            

            let contract = WalletManager.web3Net.contract(jsonString, at: contractAddress, abiVersion: 2)!



            var options = TransactionOptions.defaultOptions

            options.from = celoAddress

            options.gasPrice = .automatic

            options.gasLimit = .automatic

            let method = "balanceOf"

            let tx = contract.read(

                method,

                parameters: [address] as [AnyObject],

                extraData: Data(),

                transactionOptions: options)!

            let tokenBalance = try! tx.call()

            let balanceBigUInt = tokenBalance["0"] as! BigUInt

            let balanceString = Web3.Utils.formatToEthereumUnits(balanceBigUInt, toUnits: .eth, decimals: 3)!

            

            return "\(balanceString)"

        }




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

public class Logger {
    static func deleteLogFile() {

            guard let logFile = logFile else {

                return

            }

            do {

                let fileExists = FileManager.default.fileExists(atPath: logFile.path)

                if fileExists {

                    print("fileExists true")

                    do {

//                        if FileManager.default.isDeletableFile(atPath: logFile.path) {

                            try FileManager.default.removeItem(at: logFile)
                        HUDManager.shared.showSuccess(text: "File Deleted Successfully")
                            print("file deleted")

//                        }

                    } catch {

                        print("exeception read \(error)")

                    }

                } else {
                   
                    print("file dont exist")

                }

            } catch {

                print("exeception read \(error)")

            }

        }

    static var logFile: URL? {
//        guard let documentsDirectory = getAppBundle().bundleURL.first else { return nil }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MM-yyyy"
//        let dateString = formatter.string(from: Date())
//        let fileName = "\(dateString).log"
        let baseAppBundleId = Bundle.main.bundleIdentifier!
        let appGroupName = "group.\(baseAppBundleId)"
        if let maybeAppGroupUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName) {
            let fileName = "Heymate.log"
            return maybeAppGroupUrl.appendingPathComponent(fileName)
        }
        return nil
    }
    
    static func getLogMessages() -> String {
        guard let logFile = logFile else {
            return ""
        }
        
        do {
            let fileExists = FileManager.default.fileExists(atPath: logFile.path)
            if fileExists {
                print("fileExists true")
                let data = try Data.init(contentsOf: logFile)
                return String.init(data: data, encoding: .utf8) ?? "NA"
            } else {
                print("dont exist")
            }
        } catch {
            print("exeception read \(error)")
        }
        return ""
    }
    
    static func getFileSize() -> String {
        guard let logFile = logFile else {
            return "NA"
        }
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: logFile.path)
            print("filesize \(attr)")
            if let fileSize = attr[FileAttributeKey.size] as? UInt64 {
                print("insize \(fileSize)")
                return "\((fileSize/1024)/1024) MB"
            }
        } catch {
            print("file size error \(error)")
        }
        return "NA"
    }

 public static func logCodableData(_ data:Data) {
        guard let logFile = logFile else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        guard var d = (timestamp + " Locale: \(Locale.current.identifier): \n").data(using: String.Encoding.utf8) else { return }
        
        if FileManager.default.fileExists(atPath: logFile.path) {
            do {
                d.append(data)
                let fileHandle = try FileHandle(forWritingTo: logFile)
//                var existingData = try Data(contentsOf: logFile)
//                existingData.append(d)
                print("handled file")
                fileHandle.seekToEndOfFile()
                fileHandle.write(d)
                fileHandle.closeFile()
            } catch {
                print("file cant handle \(error)")
            }
        } else {
            do {
//                let encoded = try JSONEncoder().encode(data)
                try data.write(to: logFile, options: .atomicWrite)
            } catch {
                print("new file error \(error)")
            }
        }
    }
    
    public static func log(_ message: String) {
        guard let logFile = logFile else {
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        guard let data = (timestamp + " Locale: \(Locale.current.identifier): " + message + "\n").data(using: String.Encoding.utf8) else { return }
        
        if FileManager.default.fileExists(atPath: logFile.path) {
            do {
                let fileHandle = try FileHandle(forWritingTo: logFile)
//                var existingData = try Data(contentsOf: logFile)
//                existingData.append(data)
                print("handled file")
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            } catch {
                print("file cant handle \(error)")
            }
        } else {
            do {
                try data.write(to: logFile, options: .atomicWrite)
            } catch {
                print("new file error \(error)")
            }
        }
    }
}
