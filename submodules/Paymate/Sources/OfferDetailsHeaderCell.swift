//
//  OfferDetailsHeaderCell.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 06/11/21.
//

import UIKit

open class OfferDetailsHeaderCell: UITableViewCell {

    @IBOutlet var offerName: UILabel!
    @IBOutlet var offerCategory: UILabel!
    @IBOutlet var offerDescription: UILabel!
    @IBOutlet var offerCreated: UILabel!
    @IBOutlet var offerExpires: UILabel!
    
    @IBOutlet var offerSingle: RadioButton!
    @IBOutlet var offerSinglePrice: UILabel!
    @IBOutlet var offerSingleDetails: UILabel!
    
    @IBOutlet var offerSubscriptionDetails: UILabel!
    @IBOutlet var offerSubscriptionPrice: UILabel!
    @IBOutlet var offerSubscription: RadioButton!
    @IBOutlet var offerBundle: RadioButton!
    @IBOutlet var offerBundleDiscountView: UIView!
    @IBOutlet var offerBundleDiscount: UILabel!
    @IBOutlet var offerBundleDetails: UILabel!
    @IBOutlet var offerBundlePrice: UILabel!
    public var onOfferTypeSelection:((_ offerType:UserOffersListCell.OfferType,_ sender:UIButton) -> Void)?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        offerBundleDiscountView.roundedPaymateView(cornerRadius: 8)
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
        onOfferTypeSelection?(UserOffersListCell.OfferType.init(rawValue: sender.tag)!,sender)
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
    
    func configureOffer(_ offer:OfferDetails) {
        offerName?.text = offer.title
        offerCategory?.text = offer.category.main_cat
        offerDescription?.text = offer.description
        offerSinglePrice?.text = "$\(offer.pricing.price)"
        offerSingleDetails?.text = offer.pricing.rate_type
         
        offerCreated?.text = AppUtils.getOfferDetailsViewDateFormat(string: offer.createdAt)        
        offerExpires?.text = AppUtils.getOfferDetailsViewDateFormat(string: offer.updatedAt)
        
        let totalPrice = Int(offer.pricing.price) * (offer.pricing.bundle.count)
        let appliedPercentage = totalPrice - (((offer.pricing.bundle.discount_percent) / totalPrice)*100)
        offerBundlePrice?.text = "$\(appliedPercentage)"
        offerBundleDiscount?.text = "\(offer.pricing.bundle.discount_percent)% off"
        offerBundleDetails?.text = "\(offer.pricing.bundle.count) sessions"
        
        offerSubscriptionPrice?.text = "$\(offer.pricing.subscription.subscription_price)"
        offerSubscriptionDetails?.text = "\(offer.pricing.subscription.period) - Unlimited sessions"
    }

}
