//
//  UserOffersListCell.swift
//  _idx_Paymate_EDBCBEF6_ios_min9.0
//
//  Created by Heymate on 02/11/21.
//

import UIKit


public class UserOffersListCell: UITableViewCell {

    public enum OfferType:Int {
        case Single = 200,Bundle,Subscription
    }
    
    @IBOutlet var roundedSeperator: UIView!
    @IBOutlet var rightStackView: UIStackView!
    @IBOutlet var offerDetailsParentView: UIView!
    @IBOutlet var offerSubscriptionDetails: UILabel!
    @IBOutlet var offerSubscriptionPrice: UILabel!
    @IBOutlet var offerSubscription: RadioButton!
    @IBOutlet var offerBundle: RadioButton!
    @IBOutlet var offerBundleDiscountView: UIView!
    @IBOutlet var offerBundleDiscount: UILabel!
    @IBOutlet var offerBundleDetails: UILabel!
    @IBOutlet var offerBundlePrice: UILabel!
    @IBOutlet var offerSingle: RadioButton!
    @IBOutlet var offerSinglePrice: UILabel!
    @IBOutlet var offerSignleDetails: UILabel!
    @IBOutlet var offerDescription: UILabel!
    @IBOutlet var meetingMode: UILabel!
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var offerName: UILabel!
    @IBOutlet var leftEmptyView: UIView!
    @IBOutlet var rightEmptyView: UIView!
    @IBOutlet var progressBarParentView: UIView!
    @IBOutlet var btnShareOffer: UIButton!
    @IBOutlet var btnSeeDetails: UIButton!
    @IBOutlet public var btnBookNow: UIButton!
    @IBOutlet var btnsRightTempView: UIView!
    @IBOutlet var btnsLeftTempView: UIView!
    
    public var onOfferTypeSelection:((_ offerType:UserOffersListCell.OfferType,_ sender:UIButton) -> Void)?

    
    public override func awakeFromNib() {
        super.awakeFromNib()
        btnSeeDetails.roundedPaymateView(cornerRadius: 8)
        btnBookNow.roundedPaymateView(cornerRadius: 8)
        offerDetailsParentView.roundedPaymateView(cornerRadius: 8)
        offerBundleDiscountView.roundedPaymateView(cornerRadius: 8)
        roundedSeperator.roundedPaymateView(cornerRadius: 3)
        setInitialSelection()
        
    }
    
    private func setInitialSelection() {
        offerSingle.isSelected = true
        offerBundle.isSelected = false
        offerSubscription.isSelected = false
        
        offerSinglePrice.textColor = AppUtils.COLOR_PRIMARY3()
        offerBundlePrice.textColor = AppUtils.COLOR_BLACK()
        offerSubscriptionPrice.textColor = AppUtils.COLOR_BLACK()
    }
    
    @IBAction func onOfferType(_ sender: UIButton) {
        if sender.isSelected { return }
        sender.isSelected = !sender.isSelected
        onOfferTypeSelection?(OfferType.init(rawValue: sender.tag)!,sender)
        if sender.tag == 200 { //single
            setInitialSelection()
        } else if sender.tag == 201 { //Bundle
            offerSingle.isSelected = false
            offerSubscription.isSelected = false
            
            offerSinglePrice.textColor = AppUtils.COLOR_BLACK()
            offerBundlePrice.textColor = AppUtils.COLOR_PRIMARY3()
            offerSubscriptionPrice.textColor = AppUtils.COLOR_BLACK()
            
        } else if sender.tag == 202 { //subscription
            offerBundle.isSelected = false
            offerSingle.isSelected = false
            
            offerSinglePrice.textColor = AppUtils.COLOR_BLACK()
            offerBundlePrice.textColor = AppUtils.COLOR_BLACK()
            offerSubscriptionPrice.textColor = AppUtils.COLOR_PRIMARY3()
        }
    }
    
    public func configureOffer(_ offer:OfferDetails) {
        offerName?.text = offer.title
        categoryName?.text = offer.category.main_cat
        offerDescription?.text = offer.description
        offerSinglePrice?.text = "$\(offer.pricing.price)"
        offerSignleDetails?.text = offer.pricing.rate_type
         
        let totalPrice = Int(offer.pricing.price) * (offer.pricing.bundle.count)
        let appliedPercentage = totalPrice - (((offer.pricing.bundle.discount_percent) / totalPrice)*100)
        offerBundlePrice?.text = "$\(appliedPercentage)"
        offerBundleDiscount?.text = "\(offer.pricing.bundle.discount_percent)% off"
        offerBundleDetails?.text = "\(offer.pricing.bundle.count) sessions"
        
        offerSubscriptionPrice?.text = "$\(offer.pricing.subscription.subscription_price)"
        offerSubscriptionDetails?.text = "\(offer.pricing.subscription.period) - Unlimited sessions"
    }
    
    public func hideProgressBar(isHide:Bool) {
        progressBarParentView.isHidden = isHide
    }
    
    public func setOfferForSentMessage(isSent:Bool) {
        progressBarParentView.isHidden = false
        if isSent {
            rightEmptyView.isHidden = true
            leftEmptyView.isHidden = false
            rightStackView.isHidden = true
            btnsRightTempView.isHidden = true
            btnsLeftTempView.isHidden = false
        } else {
            rightEmptyView.isHidden = false
            leftEmptyView.isHidden = true
            rightStackView.isHidden = true
            btnsRightTempView.isHidden = false
            btnsLeftTempView.isHidden = true
        }
    }
    
    public func hideRightView() {
        self.rightStackView.isHidden = true
        self.btnSeeDetails.isHidden = true
//        self.btnsRightTempView.isHidden = true
    }
    
    
    @IBAction func onShareOffer(_ sender: Any) {

    }
    
    @IBAction func onForwardOffer(_ sender: Any) {
    }
}
