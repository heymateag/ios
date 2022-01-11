//
//  SettingsPriceDetailView.swift
//  TelegramSample
//
//  Created by Heymate on 14/09/21.
//

import UIKit
import Combine

class SettingsPriceDetailView: UIView {
    
    enum FieldTag:Int {
        case FixedPricePerSession  = 100,BundleSession,BundleDiscount,SubscriptionPerMonth
    }
    
    private var priceModel:PriceModel = PriceModel(fixed: PriceModel.FixedPrice(pricePersession: 0),
                                              bundle: PriceModel.Bundle(noOfSessions: 0, discount: 0),
                                              subscription: PriceModel.Subscription(pricePerMonth: 0))
//    var viewModelChanges = PassthroughSubject<PriceModel,Never>()
    var modelChanges:((PriceModel) -> Void)?
    
    private lazy var priceStackView:UIStackView = {
        let _stackView = UIStackView()
        _stackView.axis = .vertical
        _stackView.distribution = .fill
//        _stackView.alignment = .leading
        _stackView.spacing = 16
       return _stackView
    }()
    
    private var checkBox:UIButton = {
        let _button = UIButton()
        _button.translatesAutoresizingMaskIntoConstraints = false
        _button.setImage(UIImage(named: "tickMark"), for: .normal)
        let width = _button.widthAnchor.constraint(equalToConstant: 20)
        let height = _button.heightAnchor.constraint(equalToConstant: 20)
        height.priority = .defaultHigh
        width.priority = .defaultHigh
        NSLayoutConstraint.activate([width,height])
        _button.setImage(nil, for: .normal)
        _button.layer.cornerRadius = 4
        _button.isSelected = true
        _button.backgroundColor = AppUtils.COLOR_BLUE()
        return _button
    }()
    
    private lazy var appLabel:UILabel = {
        let _label = UILabel()
        _label.text = ""
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.textColor = AppUtils.COLOR_BLACK()
        _label.font = AppUtils.APP_FONT(size: 12)
        return _label
    }()
    
    private lazy var headingLabel:UILabel = {
        let _label = appLabel
        _label.font = AppUtils.APP_FONT(size: 14)
        return _label
    }()

    private lazy var subHeading:UILabel = {
        let _label = appLabel
        _label.font = AppUtils.APP_FONT(size: 12)
        return _label
    }()
    
    private lazy var unlimitedLabel:UILabel = {
        var paragraphStyle = NSMutableParagraphStyle()
        let _label = UILabel()
        let subString = "Subscription"
        let _subscription = NSMutableAttributedString(string: subString, attributes: [NSMutableAttributedString.Key.font:AppUtils.APP_FONT(size: 14)])
        _subscription.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUtils.COLOR_BLACK(), range: NSRange(location:0,length:subString.count-1))

        let unlimited = " (Unlimited session)"
        let _unlimited = NSMutableAttributedString(string: unlimited, attributes: [NSMutableAttributedString.Key.font:AppUtils.APP_FONT(size: 12)])
        _unlimited.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUtils.COLOR_GRAY3(), range: NSRange(location:0,length:unlimited.count-1))

        var commnAttributed = NSMutableAttributedString(attributedString: _subscription)
        commnAttributed.append(_unlimited)
        _label.attributedText = commnAttributed
        
        _label.textAlignment = .left
        return _label
    }()
   
    private lazy var borderedTextField:UITextField = {
        let _field = UITextField()
        let width = _field.widthAnchor.constraint(equalToConstant: 50)
        width.priority = .defaultHigh
        NSLayoutConstraint.activate([width])
        _field.borderStyle = .line
        _field.translatesAutoresizingMaskIntoConstraints = false
        var stroke = UIView()
        stroke.bounds = _field.bounds.insetBy(dx: -0.5, dy: -0.5)
        stroke.center = _field.center
        _field.addSubview(stroke)
        _field.bounds = _field.bounds.insetBy(dx: -0.5, dy: -0.5)
        stroke.layer.borderWidth = 1
        stroke.layer.borderColor = UIColor(red: 0.702, green: 0.702, blue: 0.702, alpha: 1).cgColor
        return _field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func commonInit() {
        
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
//        priceHeading.translatesAutoresizingMaskIntoConstraints = false
//        priceSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(priceStackView)
        let stackConstraints = [
            priceStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 32),
            priceStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 0),
            priceStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            priceStackView.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(stackConstraints)

        //fixed
        
        
        let heading =  UILabel()
        heading.translatesAutoresizingMaskIntoConstraints = false
        heading.font = AppUtils.APP_FONT(size: 14)
        heading.textColor = AppUtils.COLOR_BLACK()
        heading.text = "Fix Price"
        
        let priceEntrySV = UIStackView()
        priceEntrySV.translatesAutoresizingMaskIntoConstraints = false
        priceEntrySV.axis = .horizontal
        priceEntrySV.alignment = .leading
        priceEntrySV.distribution = .fill
        priceEntrySV.spacing = 8
        
        
        let priceLabel = UILabel()
        let dollorSign = "  $  "
        let _dollorMutable = NSMutableAttributedString(string: dollorSign,attributes: [NSMutableAttributedString.Key.font:AppUtils.APP_FONT(size: 14)])
        _dollorMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUtils.COLOR_BLUE(), range: NSRange(location:0,length:dollorSign.count-1))
        
        
        let session = " Per session"
        let _sessionMutable = NSMutableAttributedString(string: session,attributes: [NSMutableAttributedString.Key.font:AppUtils.APP_FONT(size: 12)])
        _sessionMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUtils.COLOR_BLACK(), range: NSRange(location:0,length:session.count-1))
        
        let sessionString = NSMutableAttributedString(attributedString: _dollorMutable)
        sessionString.append(_sessionMutable)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.attributedText = sessionString
        
        let fixedPriceField = UITextField()
        fixedPriceField.borderStyle = .none
        fixedPriceField.translatesAutoresizingMaskIntoConstraints = false
        let fieldWidth = fixedPriceField.widthAnchor.constraint(equalToConstant: 50)
        fixedPriceField.tag = FieldTag.FixedPricePerSession.rawValue
        fixedPriceField.addTarget(self, action: #selector(onInputEdited), for: .editingChanged)
        fieldWidth.priority = .defaultHigh
        
        NSLayoutConstraint.activate([fieldWidth])
        priceEntrySV.addArrangedSubview(fixedPriceField)
        priceEntrySV.addArrangedSubview(priceLabel)
        
        priceStackView.addArrangedSubview(heading)
        priceStackView.addArrangedSubview(priceEntrySV)
        
        SettingsPriceDetailView.getBorder(field: fixedPriceField)

        //
        
        //Bundle
        
        let bundleSV = UIStackView()
        bundleSV.axis = .vertical
        bundleSV.distribution = .fill
        bundleSV.alignment = .leading
        bundleSV.spacing = 16
        bundleSV.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bundleSV)

        let bundleConstraints = [
            bundleSV.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 32),
            bundleSV.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 0),
            bundleSV.topAnchor.constraint(equalTo: priceStackView.bottomAnchor, constant: 16)
        ]
        NSLayoutConstraint.activate(bundleConstraints)

        let checkBoxSV = UIStackView()
        checkBoxSV.axis = .horizontal
        checkBoxSV.distribution = .fill
        checkBoxSV.alignment = .leading
        checkBoxSV.spacing = 8
        checkBoxSV.translatesAutoresizingMaskIntoConstraints = false
        
        
        checkBoxSV.addArrangedSubview(getTickMark())
        let bundle = UILabel()
        bundle.translatesAutoresizingMaskIntoConstraints = false
        bundle.text = "Bundle"
        bundle.textColor = AppUtils.COLOR_BLACK()
        bundle.font = AppUtils.APP_FONT(size: 14)
        checkBoxSV.addArrangedSubview(bundle)
        
        
        let inputSV = UIStackView()
        inputSV.axis = .horizontal
        inputSV.distribution = .fill
        inputSV.translatesAutoresizingMaskIntoConstraints = false
        inputSV.spacing = 16

        let sessions = UILabel()
        sessions.font = AppUtils.APP_FONT(size: 12)
        sessions.translatesAutoresizingMaskIntoConstraints = false
        sessions.text = "Session"

        let discount = UILabel()
        discount.translatesAutoresizingMaskIntoConstraints = false
        discount.font = AppUtils.APP_FONT(size: 12)
        discount.text = "Discount"

        let sessionField = UITextField()
        sessionField.translatesAutoresizingMaskIntoConstraints = false
        sessionField.borderStyle = .none
        sessionField.tag = FieldTag.BundleSession.rawValue
        sessionField.addTarget(self, action: #selector(onInputEdited), for: .editingChanged)
        let width = sessionField.widthAnchor.constraint(equalToConstant: 50)
        width.priority = .defaultHigh
        NSLayoutConstraint.activate([width])
        inputSV.addArrangedSubview(sessionField)
        inputSV.addArrangedSubview(sessions)
        SettingsPriceDetailView.getBorder(field: sessionField)


        let discField = UITextField()
        discField.translatesAutoresizingMaskIntoConstraints = false
        discField.borderStyle = .none
        discField.tag = FieldTag.BundleDiscount.rawValue
        discField.addTarget(self, action: #selector(onInputEdited), for: .editingChanged)
        let width2 = discField.widthAnchor.constraint(equalToConstant: 50)
        width2.priority = .defaultHigh
        NSLayoutConstraint.activate([width2])
        SettingsPriceDetailView.getBorder(field: discField)

        inputSV.addArrangedSubview(discField)
        inputSV.addArrangedSubview(discount)

        bundleSV.addArrangedSubview(checkBoxSV)
        bundleSV.addArrangedSubview(inputSV)
//
////        priceStackView.addArrangedSubview(bundleSV)
////
//
//////
//////        //subscription
        let subscriptSV = UIStackView()
        subscriptSV.axis = .vertical
        subscriptSV.distribution = .fill
//        subscriptSV.alignment = .leading
        subscriptSV.spacing = 16
        subscriptSV.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subscriptSV)

        let bottomConstraint = subscriptSV.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        bottomConstraint.priority = .defaultHigh
        let subscriptConstraints = [
            subscriptSV.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 32),
            subscriptSV.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 0),
            subscriptSV.topAnchor.constraint(equalTo: bundleSV.bottomAnchor, constant: 16),
            bottomConstraint
//            subscriptSV.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(subscriptConstraints)


        let subscrptHeading = UIStackView()
        subscrptHeading.axis = .horizontal
        subscrptHeading.distribution = .fillProportionally
//        subscrptHeading.alignment = .leading
        subscrptHeading.spacing = 8
        subscrptHeading.translatesAutoresizingMaskIntoConstraints = false


        let subscrCheckBox = getTickMark()
        unlimitedLabel.translatesAutoresizingMaskIntoConstraints = false

        subscrptHeading.addArrangedSubview(subscrCheckBox)
        subscrptHeading.addArrangedSubview(unlimitedLabel)

        let subscrEntrySV = UIStackView()
        subscrEntrySV.axis = .horizontal
        subscrEntrySV.distribution = .fill
        subscrEntrySV.spacing = 8
        subscrEntrySV.translatesAutoresizingMaskIntoConstraints = false

        
        let dollorSign2 = "  $  "
        let _dollorMutable2 = NSMutableAttributedString(string: dollorSign2,attributes: [NSMutableAttributedString.Key.font:AppUtils.APP_FONT(size: 12)])
        _dollorMutable2.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUtils.COLOR_BLACK(), range: NSRange(location:0,length:dollorSign2.count-1))
        let subMutableString = NSMutableAttributedString(attributedString: _dollorMutable2)

        let perMonth = "Per month"
        let _perMonthMutable = NSMutableAttributedString(string: perMonth,attributes: [NSMutableAttributedString.Key.font:AppUtils.APP_FONT(size: 12)])
        _perMonthMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: AppUtils.COLOR_BLACK(), range: NSRange(location:0,length:perMonth.count-1))
        subMutableString.append(_perMonthMutable)
        
        let subscrPrice = UILabel()
        subscrPrice.attributedText = subMutableString
        subscrPrice.translatesAutoresizingMaskIntoConstraints = false

        let subscriptPriceField = UITextField()
        subscriptPriceField.borderStyle = .none
        let width3 = subscriptPriceField.widthAnchor.constraint(equalToConstant: 50)
        subscriptPriceField.tag = FieldTag.SubscriptionPerMonth.rawValue
        subscriptPriceField.addTarget(self, action: #selector(onInputEdited), for: .editingChanged)
        subscriptPriceField.translatesAutoresizingMaskIntoConstraints = false
        width3.priority = .defaultHigh
        NSLayoutConstraint.activate([width3])
        SettingsPriceDetailView.getBorder(field: subscriptPriceField)

        subscrEntrySV.addArrangedSubview(subscriptPriceField)
        subscrEntrySV.addArrangedSubview(subscrPrice)

        subscriptSV.addArrangedSubview(subscrptHeading)
        subscriptSV.addArrangedSubview(subscrEntrySV)

        
    }
    
    private func getTickMark() -> UIView {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppUtils.COLOR_BLUE()
        view.layer.cornerRadius = 4
       
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.isSelected = true
        view.setImage(UIImage(named: "tickMark"), for: .selected)
        view.setImage(nil, for: .normal)
        view.addTarget(self, action: #selector(onCheckBox), for: .touchUpInside)
        return view
    }
    
    static func getBorder(field:UIView){
        let border = CALayer()
        border.backgroundColor = AppUtils.COLOR_GRAY4().cgColor
        border.frame = CGRect(x: 0, y: 17, width: 50, height: 1)
        field.layer.addSublayer(border)
    }
    
    @objc func onCheckBox(btn:UIButton) {
        btn.isSelected = !btn.isSelected
    }
}

extension SettingsPriceDetailView {
    @objc func onInputEdited(field:UITextField) {
        if let text = field.text {
            switch field.tag {
                case FieldTag.FixedPricePerSession.rawValue:
                    if let floatValue = Float(text) {
                        priceModel.fixed.pricePersession = floatValue
                    }
                case FieldTag.BundleSession.rawValue:
                    if let intValue = Int(text) {
                        priceModel.bundle.noOfSessions = intValue
                    }
                    break
                case FieldTag.BundleDiscount.rawValue:
                    if let intValue = Int(text) {
                        priceModel.bundle.discount = intValue
                    }
                    break
                case FieldTag.SubscriptionPerMonth.rawValue:
                    if let floatValue = Float(text) {
                        priceModel.subscription.pricePerMonth = floatValue
                    }
                    break
                default : break
            }
//            viewModelChanges.send(priceModel)
            modelChanges?(priceModel)
        }
    }
    
    @objc func onBundleCheck(button:UIButton) {
        button.isSelected = !button.isSelected
        priceModel.bundle.isChecked = button.isSelected
//        viewModelChanges.send(priceModel)
        modelChanges?(priceModel)
    }
    
    @objc func onSubscriptionCheck(button:UIButton) {
        button.isSelected = !button.isSelected
        priceModel.subscription.isChecked = button.isSelected
//        viewModelChanges.send(priceModel)
        modelChanges?(priceModel)
    }
    
}
