//
//  CreateOfferTableViewController.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 09/11/21.
//

import UIKit

class CreateOfferTableViewController: UITableViewController,PaymateNavigationBar,PaymateServiceErrorhandler {
    
    enum OfferSections:Int,CaseIterable {
        case Images=0,Settings
    }
    
    enum OfferImageSectionRows:Int,CaseIterable {
        case Images = 0
        case Title
        case Description
    }
    
    enum OfferRowIndex:Int,CaseIterable {
        case Category = 0,Location,Participant,Schedule,Pricing,PaymentTerms,Expiration,TnC
        
        static func getCell(row:Self) -> IndexPath {
            switch row {
                case .Category:
                    return IndexPath(row: CreateOfferTableViewController.OfferRowIndex.Category.rawValue, section: OfferSections.Settings.rawValue)
                case .Location:
                    return IndexPath(row: CreateOfferTableViewController.OfferRowIndex.Location.rawValue, section: OfferSections.Settings.rawValue)
                case .Schedule:
                        return IndexPath(row: CreateOfferTableViewController.OfferRowIndex.Schedule.rawValue, section: OfferSections.Settings.rawValue)
                case .Participant:
                    return IndexPath(row: CreateOfferTableViewController.OfferRowIndex.Participant.rawValue, section: OfferSections.Settings.rawValue)
                case .Pricing:
                    return IndexPath(row: CreateOfferTableViewController.OfferRowIndex.Pricing.rawValue, section: OfferSections.Settings.rawValue)
                case .PaymentTerms:
                    return IndexPath(row: CreateOfferTableViewController.OfferRowIndex.PaymentTerms.rawValue, section: OfferSections.Settings.rawValue)
                case .Expiration:
                    return IndexPath(row: CreateOfferTableViewController.OfferRowIndex.Expiration.rawValue, section: OfferSections.Settings.rawValue)
                case .TnC:
                    return IndexPath(row: CreateOfferTableViewController.OfferRowIndex.TnC.rawValue, section: OfferSections.Settings.rawValue)
            }
        }
    }
    
    enum PaytermType:Int {
        case DelayInStartMins=100,DelayInStartPercentage,DepositPercentage,CancellationHours,CancellationHrsPercentage,CancellationStartHrs,CancellationEndHrs,CancellationRangePercentage
    }
    
    //images
    var offerImages:[OfferImageModel] = []
    var offerTitle = ""
    var offerDescription = ""
    
    //category
    var selectedCategory:CategoryModel?
    var selectedSubCategory:CategoryModel?
    //location
    var isOnlineMeeting = true    
    //schedule
    var offerSchedules:[Schedule] = []
    //participants
    var isUnlimitedParticipants = false
    var noOfParticipants:String = "0"
    //price
    var isBundleSelected = false
    var isSubscriptionSelected = false
    var bundleSessions = ""
    var bundleDiscount = ""
    var subscriptionPricePerMonth = ""
    var fixedPrice = ""
    //pay terms
    var currentInputSelection:PaytermType = .DelayInStartMins
    var payTermDelayStartMins = PayTerm(percentage: 30, constraintTime: 20)
    var payTermDeposit = PayTerm(percentage: 30, constraintTime: 0)
    var payTermCancelHrs = PayTerm(percentage: 30, constraintTime: 2)
    var payTermCancelRange = PayTerm(percentage: 30, constraintTime: 0)
    //terms
    var termsAndConditions = ""
    //expire
    var isExpireDatePicker = false
    var expireDate = Date()
    
    private var noOfSchedules = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emptyView = UIView()
        emptyView.backgroundColor = .clear
        tableView.tableFooterView = emptyView
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "COCategoryCell", bundle: nil), forCellReuseIdentifier: "COCategoryCell")
        tableView.register(UINib(nibName: "COLocationCell", bundle: nil), forCellReuseIdentifier: "COLocationCell")
        tableView.register(UINib(nibName: "COParticipantsCell", bundle: nil), forCellReuseIdentifier: "COParticipantsCell")
        tableView.register(UINib(nibName: "COScheduleCell", bundle: nil), forCellReuseIdentifier: "COScheduleCell")
        tableView.register(UINib(nibName: "COPricingCell", bundle: nil), forCellReuseIdentifier: "COPricingCell")
        tableView.register(UINib(nibName: "COPaymentTermsCell", bundle: nil), forCellReuseIdentifier: "COPaymentTermsCell")
        tableView.register(UINib(nibName: "COExpirationCell", bundle: nil), forCellReuseIdentifier: "COExpirationCell")
        tableView.register(UINib(nibName: "COTermsCell", bundle: nil), forCellReuseIdentifier: "COTermsCell")
        tableView.register(OffersImagesCell.self, forCellReuseIdentifier: "OffersImagesCell")
        tableView.register(OffersInputCell.self, forCellReuseIdentifier: "OffersInputCell")
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTableTap))
//        tableView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarWithType(navType: .NavCenterTitleWithBackButton, centerTitle: "Create Offer", leftSelector: #selector(onBack), rightSelector: nil)
    }
    
    @objc private func onBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func onTableTap() {
        tableView.endEditing(true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return OfferSections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == OfferSections.Images.rawValue ? OfferImageSectionRows.allCases.count : OfferRowIndex.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        v.backgroundColor = .white
        let _label = UILabel(frame: CGRect(x: 16, y: 8, width: v.frame.size.width, height: v.frame.size.height))
        _label.backgroundColor = .white
         _label.textColor = UIColor(red: 0.161, green: 0.663, blue: 0.922, alpha: 1)
        _label.font = UIFont.boldSystemFont(ofSize: 14.0)
        _label.numberOfLines = 0
        _label.lineBreakMode = .byWordWrapping
        if section == OfferSections.Images.rawValue {
            _label.text = "Offer Details"
        } else {
            _label.text = "Offer Settings"
        }
        v.addSubview(_label)
        return v
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == OfferSections.Images.rawValue {
            if indexPath.row == OfferImageSectionRows.Images.rawValue,let cell = tableView.dequeueReusableCell(withIdentifier: "OffersImagesCell") as? OffersImagesCell {
                initializeOfferImages(cell: cell)
                return cell
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: "OffersInputCell") as? OffersInputCell {
                if indexPath.row == OfferImageSectionRows.Title.rawValue {
                    cell.inputField.text = offerTitle
                    cell.inputField.tag = OfferImageSectionRows.Title.rawValue
                    cell.showRightCounterLabel()
                } else if indexPath.row == OfferImageSectionRows.Description.rawValue {
                    cell.inputField.text = offerDescription
                    cell.inputField.tag = OfferImageSectionRows.Description.rawValue
                }
                cell.inputField.addTarget(self, action: #selector(offerDetailsEdited), for: .editingChanged)
                return cell
            }
        } else {
            if indexPath.row == OfferRowIndex.Category.rawValue, let cell = tableView.dequeueReusableCell(withIdentifier: "COCategoryCell") as? COCategoryCell {
                self.initializeCategoryActions(cell: cell)
                return cell
            } else if indexPath.row == OfferRowIndex.Location.rawValue, let cell = tableView.dequeueReusableCell(withIdentifier: "COLocationCell") as? COLocationCell {
                initializeLocation(cell: cell)
                return cell
            } else if indexPath.row == OfferRowIndex.Participant.rawValue, let cell = tableView.dequeueReusableCell(withIdentifier: "COParticipantsCell") as? COParticipantsCell {
                initializeParticipantsViews(cell:cell)
                return cell
            } else if indexPath.row == OfferRowIndex.Schedule.rawValue, let cell = tableView.dequeueReusableCell(withIdentifier: "COScheduleCell") as? COScheduleCell {
                self.initializeScheduleViews(cell: cell)
                return cell
            } else if indexPath.row == OfferRowIndex.Pricing.rawValue, let cell = tableView.dequeueReusableCell(withIdentifier: "COPricingCell") as? COPricingCell {
                self.initializePriceView(cell: cell)
                return cell
            } else if indexPath.row == OfferRowIndex.PaymentTerms.rawValue, let cell = tableView.dequeueReusableCell(withIdentifier: "COPaymentTermsCell") as? COPaymentTermsCell {
                initializePayterms(cell: cell)
                return cell
            } else if indexPath.row == OfferRowIndex.Expiration.rawValue, let cell = tableView.dequeueReusableCell(withIdentifier: "COExpirationCell") as? COExpirationCell {
                initializeExpiration(cell: cell)
                return cell
            } else if indexPath.row == OfferRowIndex.TnC.rawValue, let cell = tableView.dequeueReusableCell(withIdentifier: "COTermsCell") as? COTermsCell {
                initializeTerms(cell: cell)
                return cell
            }
        }
        return UITableViewCell(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if indexPath.section == OfferSections.Settings.rawValue {
            if indexPath.row == OfferRowIndex.Category.rawValue {
                (tableView.cellForRow(at: indexPath) as! COCategoryCell).detailsStackView.isHidden = true
            } else if indexPath.row == OfferRowIndex.Location.rawValue {
                (tableView.cellForRow(at: indexPath) as! COLocationCell).detailsSV.isHidden = true
            } else if indexPath.row == OfferRowIndex.Participant.rawValue {
                (tableView.cellForRow(at: indexPath) as! COParticipantsCell).detailsSV.isHidden = true
            } else if indexPath.row == OfferRowIndex.Schedule.rawValue {
                (tableView.cellForRow(at: indexPath) as! COScheduleCell).detailsSV.isHidden = true
            } else if indexPath.row == OfferRowIndex.Pricing.rawValue {
                (tableView.cellForRow(at: indexPath) as! COPricingCell).detailsSv.isHidden = true
                resetPricingViews(cell: (tableView.cellForRow(at: indexPath) as! COPricingCell))
            } else if indexPath.row == OfferRowIndex.PaymentTerms.rawValue {
                (tableView.cellForRow(at: indexPath) as! COPaymentTermsCell).detailsSV.isHidden = true
            } else if indexPath.row == OfferRowIndex.Expiration.rawValue {
                (tableView.cellForRow(at: indexPath) as! COExpirationCell).detailsSv.isHidden = true
            }  else if indexPath.row == OfferRowIndex.TnC.rawValue {
                (tableView.cellForRow(at: indexPath) as! COTermsCell).detailsSv.isHidden = true
            }
            UIView.animate(withDuration: 0.3) {
                if #available(iOS 11.0, *) {
                    tableView.performBatchUpdates(nil)
                } else {

                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == OfferSections.Settings.rawValue {
            if indexPath.row == OfferRowIndex.Category.rawValue {
                (tableView.cellForRow(at: indexPath) as! COCategoryCell).detailsStackView.isHidden = false
            } else if indexPath.row == OfferRowIndex.Location.rawValue {
                (tableView.cellForRow(at: indexPath) as! COLocationCell).detailsSV.isHidden = false
            } else if indexPath.row == OfferRowIndex.Participant.rawValue {
                (tableView.cellForRow(at: indexPath) as! COParticipantsCell).detailsSV.isHidden = false
            } else if indexPath.row == OfferRowIndex.Schedule.rawValue {
                (tableView.cellForRow(at: indexPath) as! COScheduleCell).detailsSV.isHidden = false
            } else if indexPath.row == OfferRowIndex.Pricing.rawValue {
                (tableView.cellForRow(at: indexPath) as! COPricingCell).detailsSv.isHidden = false
            } else if indexPath.row == OfferRowIndex.PaymentTerms.rawValue {
                (tableView.cellForRow(at: indexPath) as! COPaymentTermsCell).detailsSV.isHidden = false
            } else if indexPath.row == OfferRowIndex.Expiration.rawValue {
                (tableView.cellForRow(at: indexPath) as! COExpirationCell).detailsSv.isHidden = false
            } else if indexPath.row == OfferRowIndex.TnC.rawValue {
                (tableView.cellForRow(at: indexPath) as! COTermsCell).detailsSv.isHidden = false
                showTermsController()
            }
            UIView.animate(withDuration: 0.3) {
                if #available(iOS 11.0, *) {
                    tableView.performBatchUpdates(nil)
                } else {

                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == OfferSections.Settings.rawValue {
            return UITableView.automaticDimension
        }
        if indexPath.row == OfferImageSectionRows.Images.rawValue { return 140 }
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == OfferSections.Images.rawValue ? 16 : UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == OfferSections.Images.rawValue {
            let v = UIView()
            v.backgroundColor = AppUtils.COLOR_LIGHT_GRAY6()
            return v
        }
        if section == OfferSections.Settings.rawValue,let v = Bundle.main.loadNibNamed("COFooterView", owner: self, options: nil)?.first as? COFooterView {
            v.btnSave.addTarget(self, action: #selector(onOfferSave), for: .touchUpInside)
            v.btnPromote.addTarget(self, action: #selector(onPromote), for: .touchUpInside)
            return v
        }
        return nil
    }
    
    @objc private func onOfferSave() {
        print("onOfferSave")
        let category = OfferCategory(main_cat: selectedCategory?.name ?? "", sub_cat: selectedSubCategory?.name ?? "")
        var schedules:[CreateOfferRequest.OfferSchedule] = []
        for schedule in offerSchedules {
            schedules.append(CreateOfferRequest.OfferSchedule(form_time: "\(schedule.fromDate.millisecondsSince1970)", to_time: "\(schedule.toDate.millisecondsSince1970)"))
        }
        let bundlePrice = OfferPricing.OfferBundle.init(count: Int(bundleSessions)!, discount_percent: Int(bundleDiscount)!, signature: "")
        let subPrice = OfferPricing.OfferSubscription.init(period: "Per month", subscription_price: Int(subscriptionPricePerMonth)!, signature: "")
        let pricing = OfferPricing(rate_type: "Per Item", price: Int(fixedPrice)!, currency: "USD", signature: "", bundle: bundlePrice, subscription: subPrice)
        
        let delayStart = OfferPaymentTerms.DelayInStart(duration: payTermDelayStartMins.constraintTime, deposit: payTermDelayStartMins.percentage)
        let cancelHours = OfferPaymentTerms.Cancellation(range: payTermCancelHrs.constraintTime, penalty: payTermCancelHrs.percentage)
        let cancelRange = OfferPaymentTerms.Cancellation(range: payTermCancelHrs.endHour, penalty: payTermCancelHrs.percentage)
        
        let terms = OfferPaymentTerms(delay_in_start: delayStart, cancellation: [cancelHours,cancelRange])
        
        let createOffer = CreateOfferRequest(title: offerTitle, description: offerDescription, category: category, location: OfferLocation(lat: "0", long: "0"), schedules: schedules, pricing: pricing, payment_terms: terms, term_condition: termsAndConditions, simple_share: "simple or referral ? skip for now", participants: Int(noOfParticipants)!)
        print("createOffer \(createOffer)")
        RappleActivityIndicatorView.startAnimating()
        PeyServiceController.shared.createOffer(request: createOffer) {[weak self] (result, _) in
            RappleActivityIndicatorView.stopAnimation()
            switch result {
                case .success(let response):
                    print("response \(response)")
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print("error \(error)")
            }
        }
    }
    
    @objc private func onPromote() {
        
    }

    @objc private func offerDetailsEdited(field:UITextField) {
        if field.tag == OfferImageSectionRows.Title.rawValue {
            offerTitle = field.text ?? ""
        } else if field.tag == OfferImageSectionRows.Description.rawValue {
            offerDescription = field.text ?? ""
        }
    }
    
}
