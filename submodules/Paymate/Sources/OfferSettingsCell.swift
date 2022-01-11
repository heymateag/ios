//
//  OfferSettingsCell.swift
//  TelegramSample
//
//  Created by Heymate on 28/08/21.
//

import UIKit

enum OfferSettingCategory:Int {
    case Category=0
    case Location
    case Participant
    case Schedule
    case Pricing
    case PaymentTerms
    case Expiration
    case TandC
}
class OfferSettingsCell: UITableViewCell {

    var embeddedController:UIViewController?
    
    //expandableviews
    lazy var participantView:SettingsParticipantDetailView = {
       let _participant = SettingsParticipantDetailView()
        _participant.translatesAutoresizingMaskIntoConstraints = false
        return _participant
    }()
    
    lazy var scheduleView:SetingsScheduleDetailsView = {
        let _schedule = SetingsScheduleDetailsView()
        _schedule.translatesAutoresizingMaskIntoConstraints = false
        return _schedule
    }()
    
    lazy var priceView:SettingsPriceDetailView = {
        let _price = SettingsPriceDetailView()
        _price.translatesAutoresizingMaskIntoConstraints = false
        return _price
    }()
    
    lazy var paymentTerms:SettingPaymentTermsView = {
        let _payTerms = SettingPaymentTermsView()
        _payTerms.translatesAutoresizingMaskIntoConstraints = false
        return _payTerms
    }()
    
    lazy var categoryView:SettingsCategoryView = {
        let _category = SettingsCategoryView()
        _category.translatesAutoresizingMaskIntoConstraints = false
        return _category
    }()
    
    lazy var locationView:SettingsLocationView = {
        let _location = SettingsLocationView()
        _location.translatesAutoresizingMaskIntoConstraints = false
        return _location
    }()
    
    lazy var expirationView:SettingsExpirationView = {
        let _expire = SettingsExpirationView()
        _expire.translatesAutoresizingMaskIntoConstraints = false
        return _expire
    }()
    
    private lazy var parentView:UIView = {
       let _view = UIView()
        _view.backgroundColor = .clear
        return _view
    }()
    
    private lazy var leftImage:UIImageView = {
        let _imv = UIImageView()
        _imv.contentMode = .scaleAspectFit
        _imv.image = UIImage(named: "leftImage")
        return _imv
    }()
    
    private lazy var cellTitle:UILabel = {
       let _label = UILabel()
        _label.textColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
        _label.numberOfLines = 0
        _label.text = "Settings"
        _label.lineBreakMode = .byWordWrapping
        return _label
    }()
    
    private lazy var detailStackView:UIStackView = {
       let _stackView = UIStackView()
        _stackView.axis = .vertical
        _stackView.spacing = 4
        _stackView.distribution = .fill
        return _stackView
    }()
    
    private lazy var  bottomStackView:UIStackView = { // holds actual view when expanded
        let _stackView = UIStackView()
        _stackView.axis = .vertical
        _stackView.distribution = .fillEqually
        _stackView.spacing = 8
        return _stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setUI() {
        self.selectionStyle = .none
        contentView.addSubview(detailStackView)
        detailStackView.addArrangedSubview(parentView)
        
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        parentView.translatesAutoresizingMaskIntoConstraints = false
        leftImage.translatesAutoresizingMaskIntoConstraints = false
        cellTitle.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        parentView.addSubview(cellTitle)
        parentView.addSubview(leftImage)
                
        let imgConstraints = [
            leftImage.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 0),
            leftImage.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: 0),
            leftImage.widthAnchor.constraint(equalToConstant: 20),
            leftImage.heightAnchor.constraint(equalToConstant: 20),
            leftImage.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: 0)
        ]
        
        let titleConstraints = [
            cellTitle.leadingAnchor.constraint(equalTo: leftImage.trailingAnchor, constant: 28),
            cellTitle.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: 0),
            cellTitle.centerYAnchor.constraint(equalTo: leftImage.centerYAnchor, constant: 0)
        ]
        contentView.addBottomBorderWithColor(color: UIColor(red: 236/255, green: 237/255, blue: 241/255, alpha: 1), width: 1,xValue: 50)
        
        let detailConstraints = [
            detailStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            detailStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-16),
            detailStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            detailStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ]
        detailStackView.addArrangedSubview(bottomStackView)

        let parentHeight = parentView.heightAnchor.constraint(equalToConstant: 44)
        parentHeight.priority = .defaultHigh // so that it wont break constraints when view expanded
        NSLayoutConstraint.activate([parentHeight])
        NSLayoutConstraint.activate(detailConstraints)
        NSLayoutConstraint.activate(imgConstraints)
        NSLayoutConstraint.activate(titleConstraints)
    }
    
//    func configureFor(item:CreateOfferViewController.RowItem,category:OfferSettingCategory,controller:UIViewController) {
//        leftImage.image = UIImage(named: item.imageName)
//        cellTitle.text = item.title
//        self.embeddedController = controller
//        configureForSectionType(category)
//    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension OfferSettingsCell {
    func configureForSectionType(_ category:OfferSettingCategory) {
        bottomStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        switch category {
        case .Schedule:
           showScheduleDetails()
        case .Pricing:
            showPriceDetails()
        case .Category:
            showCategoryDetails()
        case .Participant:
            showParticipantDetails()
        case .Location:
            showLocationDetails()
        case .PaymentTerms:
            showPaymentTermsView()
        case .Expiration:
            showExpirationView()
        case .TandC: //nothing to do here
            break
        }
    }
    
    private func showScheduleDetails() {
        scheduleView.embedController = embeddedController
        bottomStackView.addArrangedSubview(scheduleView)
    }
    
    private func showPriceDetails() {
        bottomStackView.addArrangedSubview(priceView)
    }
    
    private func showCategoryDetails() {
        categoryView.embededController = embeddedController
        bottomStackView.addArrangedSubview(categoryView)
    }
    
    private func showParticipantDetails() {
        bottomStackView.addArrangedSubview(participantView)
    }
    
    private func showLocationDetails() {
        bottomStackView.addArrangedSubview(locationView)
    }
    
    private func showPaymentTermsView() {
        paymentTerms.embeddedController = embeddedController
        bottomStackView.addArrangedSubview(paymentTerms)
    }
    
    private func showExpirationView() {
        expirationView.embedController = embeddedController
        bottomStackView.addArrangedSubview(expirationView)
    }
}

extension OfferSettingsCell {
    var isDetailViewHidden: Bool {
        return bottomStackView.isHidden
    }

    func showDetailView() {
        bottomStackView.isHidden = false
    }

    func hideDetailView() {
        bottomStackView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isDetailViewHidden, selected {
            showDetailView()
        } else {
            hideDetailView()
        }
    }
}
