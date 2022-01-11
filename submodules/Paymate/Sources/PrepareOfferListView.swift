//
//  PrepareOfferListView.swift
//  _idx_Paymate_0EEE5C76_ios_min9.0
//
//  Created by Heymate on 29/10/21.
//

import UIKit

public class PrepareOfferListView:UITableViewCell {
    
//    private var btnBookNow: UIButton?
//    private var btnSeeMore: UIButton?
//    private var btnForwardOffer: UIButton?
//    private var btnShareOffer: UIButton?
//    private var offerSubscriptionDetails: UILabel?
//    private var offerSubscriptionPrice: UILabel?
//    private var offerSubscription: UIButton?
//    private var offerBundleDetails: UILabel?
//    private var offerBundlePrice: UILabel?
//    private var offerBundleDiscount: UILabel?
//    private var offerBundle: UIButton?
//    private var offerSingleDetails: UILabel?
//    private var offerSinglePrice: UILabel?
//    private var offerSingle: UIButton?
//    private var offerDescription: UILabel?
//    private var offerMode: UILabel?
//    private var offerCategory: UILabel?
//    private var offerName: UILabel?
//    private var rightStackView: UIStackView?
//    private var bundleOffView: UIView?
//    private var offerDetailsView: UIView?
    
    public static func prepareOfferViewFromCell(cell:UITableViewCell,offerDetails:OfferDetails?) -> (share:UIButton?,promote:UIButton?,seeMore:UIButton?,bookNow:UIButton?,single:UIButton?,bundle:UIButton?,subscription:UIButton?) {
        
        let singleViews = PrepareOfferListView.getSingleOfferViews(cell: cell)
        let bundleViews = PrepareOfferListView.getBundlefferViews(cell: cell)
        let subscriptViews = PrepareOfferListView.getSubscriptionOfferViews(cell: cell)
        print("singleViews \(singleViews)")
        
        let offerName = cell.viewWithTag(OfferTags.TagOfferName.rawValue) as? UILabel
        let offerCategory = cell.viewWithTag(OfferTags.TagOfferCategory.rawValue) as? UILabel
        let offerMode = cell.viewWithTag(OfferTags.TagOfferMode.rawValue) as? UILabel
        let offerDescription = cell.viewWithTag(OfferTags.TagOfferDescription.rawValue) as? UILabel
        
        let offerSingle = singleViews.radioBtn
        let offerSinglePrice = singleViews.price
        let offerSingleDetails = cell.viewWithTag(OfferTags.TagSingleDetails.rawValue) as? UILabel
        

        let offerBundle = bundleViews.radioBtn
        let offerBundlePrice = bundleViews.price
        let bundleOffView = cell.viewWithTag(OfferTags.TagOfferDiscountView.rawValue)
        print("bundleOffView \(bundleOffView)")
        bundleOffView?.layer.cornerRadius = 8
        
        let offerBundleDiscount = cell.viewWithTag(OfferTags.TagOfferDiscount.rawValue) as? UILabel
        let offerBundleDetails = cell.viewWithTag(OfferTags.TagBundleDetails.rawValue) as? UILabel
        
        let offerSubscription = subscriptViews.radioBtn
        let offerSubscriptionPrice = subscriptViews.price
        let offerSubscriptionDetails = cell.viewWithTag(OfferTags.TagSubDetails.rawValue) as? UILabel
        
        let btnShareOffer = cell.viewWithTag(OfferTags.TagOfferShare.rawValue) as? UIButton
        let btnForwardOffer = cell.viewWithTag(OfferTags.TagOfferForward.rawValue) as? UIButton
        
        let btnSeeMore = cell.viewWithTag(OfferTags.TagOfferSeeMore.rawValue) as? UIButton
        let btnBookNow = cell.viewWithTag(OfferTags.TagOfferBookNow.rawValue) as? UIButton
        
        btnSeeMore?.layer.cornerRadius = 8
        btnBookNow?.layer.cornerRadius = 8
        
        let corneredView = cell.viewWithTag(OfferTags.TagParentHolderView.rawValue)
        corneredView?.layer.cornerRadius = 8
        
        PrepareOfferListView.setRadioButtonAction(button: offerSingle,withImageChange: true)
        PrepareOfferListView.setRadioButtonAction(button: offerBundle,withImageChange: true)
        PrepareOfferListView.setRadioButtonAction(button: offerSubscription,withImageChange: true)
        
        
        offerSingle?.isSelected = true
        offerBundle?.isSelected = false
        offerSubscription?.isSelected = false
        
        
        //set offer
        if let offer = offerDetails {
            offerName?.text = offer.title
            offerCategory?.text = offer.category.main_cat
            offerMode?.text = "Online"
            offerDescription?.text = "Voluptatum dolorum impedit aut quis. Ipsum excepturi voluptatum quos inventore aut ea sunt molestiae impedit."
            offerSinglePrice?.text = "$\(offer.pricing.price)"
            offerSingleDetails?.text = offer.pricing.rate_type
             
            let totalPrice = Int(offer.pricing.price) * (offer.pricing.bundle.count)
            let appliedPercentage = totalPrice - (((offer.pricing.bundle.discount_percent) / totalPrice)*100)
            offerBundlePrice?.text = "$\(appliedPercentage)"
            offerBundleDiscount?.text = "\(offer.pricing.bundle.discount_percent)% off"
            offerBundleDetails?.text = "\(offer.pricing.bundle.count) sessions"
            
            offerSubscriptionPrice?.text = "$\(offer.pricing.subscription.subscription_price)"
            offerSubscriptionDetails?.text = "\(offer.pricing.subscription.period) - Unlimited sessions"
        }
        return (btnShareOffer,btnForwardOffer,btnSeeMore,btnBookNow,singleViews.radioBtn,bundleViews.radioBtn,subscriptViews.radioBtn)
    }
    
    static func getSingleOfferViews(cell:UITableViewCell) -> (radioBtn:UIButton?,price:UILabel?) {
        return (cell.viewWithTag(OfferTags.TagOfferSingle.rawValue) as? UIButton,cell.viewWithTag(OfferTags.TagOfferSinglePrice.rawValue) as? UILabel)
    }
    static func getBundlefferViews(cell:UITableViewCell) -> (radioBtn:UIButton?,price:UILabel?) {
        return (cell.viewWithTag(OfferTags.TagOfferBundle.rawValue) as? UIButton,cell.viewWithTag(OfferTags.TagBundlePrice.rawValue) as? UILabel)
    }
    static func getSubscriptionOfferViews(cell:UITableViewCell) -> (radioBtn:UIButton?,price:UILabel?) {
        return (cell.viewWithTag(OfferTags.TagSubscription.rawValue) as? UIButton,cell.viewWithTag(OfferTags.TagSubPrice.rawValue) as? UILabel)
    }
    
    
    static func didSelectOfferMode(sender:UIButton,cell:UITableViewCell) {
        let singleView = PrepareOfferListView.getSingleOfferViews(cell: cell)
        let bundles = PrepareOfferListView.getBundlefferViews(cell: cell)
        let subscripts = PrepareOfferListView.getSubscriptionOfferViews(cell: cell)
        
        if sender.tag == OfferTags.TagOfferSingle.rawValue {
            singleView.radioBtn?.isSelected = true
            bundles.radioBtn?.isSelected = false
            subscripts.radioBtn?.isSelected = false

            singleView.price?.textColor = AppUtils.COLOR_BLUE()
            bundles.price?.textColor = AppUtils.COLOR_BLACK()
            subscripts.price?.textColor = AppUtils.COLOR_BLACK()
        } else if sender.tag == OfferTags.TagOfferBundle.rawValue {
            singleView.radioBtn?.isSelected = false
            bundles.radioBtn?.isSelected = true
            subscripts.radioBtn?.isSelected = false

            singleView.price?.textColor = AppUtils.COLOR_BLACK()
            bundles.price?.textColor = AppUtils.COLOR_BLUE()
            subscripts.price?.textColor = AppUtils.COLOR_BLACK()
        } else if sender.tag == OfferTags.TagSubscription.rawValue {
            singleView.radioBtn?.isSelected = false
            bundles.radioBtn?.isSelected = false
            subscripts.radioBtn?.isSelected = true

            singleView.price?.textColor = AppUtils.COLOR_BLACK()
            bundles.price?.textColor = AppUtils.COLOR_BLACK()
            subscripts.price?.textColor = AppUtils.COLOR_BLUE()
        }
    }
    
    static func setRadioButtonAction(button:UIButton?,withImageChange:Bool) {
        button?.setImage(UIImage(named: "radio_unselected"), for: .normal)
        button?.setImage(UIImage(named: "radio_selected"), for: .selected)
        
        button?.setTitleColor(AppUtils.COLOR_PRIMARY3(), for: .selected)
        button?.setTitleColor(AppUtils.COLOR_BLACK(), for: .normal)
    }
}

extension PrepareOfferListView { //offer details
    
    static func prepareOfferDetailsViewFromCell(cell:UITableViewCell,offerDetails:OfferDetails?) -> (single:UIButton?,bundle:UIButton?,subscription:UIButton?) {
        
        let singleViews = PrepareOfferListView.getSingleOfferViews(cell: cell)
        let bundleViews = PrepareOfferListView.getBundlefferViews(cell: cell)
        let subscriptViews = PrepareOfferListView.getSubscriptionOfferViews(cell: cell)
        print("singleViews \(singleViews)")
        
        let offerName = cell.viewWithTag(OfferDetailsHeaderCellTags.TagOfferName.rawValue) as? UILabel
        let offerCategory = cell.viewWithTag(OfferDetailsHeaderCellTags.TagOfferCategory.rawValue) as? UILabel
        let offerDescription = cell.viewWithTag(OfferDetailsHeaderCellTags.TagOfferDescription.rawValue) as? UILabel
        
        let offerSingle = singleViews.radioBtn
        let offerSinglePrice = singleViews.price
        let offerSingleDetails = cell.viewWithTag(OfferTags.TagSingleDetails.rawValue) as? UILabel
        

        let offerBundle = bundleViews.radioBtn
        let offerBundlePrice = bundleViews.price
        let bundleOffView = cell.viewWithTag(OfferDetailsHeaderCellTags.TagOfferDiscountView.rawValue)
        print("bundleOffView \(bundleOffView)")
        bundleOffView?.layer.cornerRadius = 8
        
        let offerBundleDiscount = cell.viewWithTag(OfferDetailsHeaderCellTags.TagOfferDiscount.rawValue) as? UILabel
        let offerBundleDetails = cell.viewWithTag(OfferDetailsHeaderCellTags.TagBundleDetails.rawValue) as? UILabel
        
        let offerSubscription = subscriptViews.radioBtn
        let offerSubscriptionPrice = subscriptViews.price
        let offerSubscriptionDetails = cell.viewWithTag(OfferDetailsHeaderCellTags.TagSubDetails.rawValue) as? UILabel
        
        
        PrepareOfferListView.setRadioButtonAction(button: offerSingle,withImageChange: true)
        PrepareOfferListView.setRadioButtonAction(button: offerBundle,withImageChange: true)
        PrepareOfferListView.setRadioButtonAction(button: offerSubscription,withImageChange: true)
        
        
        offerSingle?.isSelected = true
        offerBundle?.isSelected = false
        offerSubscription?.isSelected = false
        
        
        //set offer
        if let offer = offerDetails {
            offerName?.text = offer.title
            offerCategory?.text = offer.category.main_cat
            offerDescription?.text = "Voluptatum dolorum impedit aut quis. Ipsum excepturi voluptatum quos inventore aut ea sunt molestiae impedit."
            offerSinglePrice?.text = "$\(offer.pricing.price)"
            offerSingleDetails?.text = offer.pricing.rate_type
             
            let createdDate = cell.viewWithTag(OfferDetailsHeaderCellTags.TadCreated.rawValue) as? UILabel
            createdDate?.text = AppUtils.getOfferDetailsViewDateFormat(string: offer.createdAt)
            
            let expirededDate = cell.viewWithTag(OfferDetailsHeaderCellTags.TadExpired.rawValue) as? UILabel
            expirededDate?.text = AppUtils.getOfferDetailsViewDateFormat(string: offer.updatedAt)
            
            let totalPrice = Int(offer.pricing.price) * (offer.pricing.bundle.count)
            let appliedPercentage = totalPrice - (((offer.pricing.bundle.discount_percent) / totalPrice)*100)
            offerBundlePrice?.text = "$\(appliedPercentage)"
            offerBundleDiscount?.text = "\(offer.pricing.bundle.discount_percent)% off"
            offerBundleDetails?.text = "\(offer.pricing.bundle.count) sessions"
            
            offerSubscriptionPrice?.text = "$\(offer.pricing.subscription.subscription_price)"
            offerSubscriptionDetails?.text = "\(offer.pricing.subscription.period) - Unlimited sessions"
        }
        return (singleViews.radioBtn,bundleViews.radioBtn,subscriptViews.radioBtn)
    }
    
    
    static func prepareOfferDetailsPaymentsView(cell:UITableViewCell,offerDetails:OfferDetails?,row:Int) {
        let leftTitle = cell.viewWithTag(OfferDetailsPaymentCell.TagTermTitle.rawValue) as? UILabel
        let rightTitle = cell.viewWithTag(OfferDetailsPaymentCell.TagTermsDetails.rawValue) as? UILabel

        guard let offer = offerDetails else {
            leftTitle?.text = ""
            rightTitle?.text = ""
            return
        }
        
        if row == 0 {
            leftTitle?.text = "Delays in start by < \(offer.payment_terms.delay_in_start.duration) mins"
            rightTitle?.text = "\(offer.payment_terms.delay_in_start.deposit)%"
        } else if row == 1 {
            let cancellation = offer.payment_terms.cancellation[row-1]
            leftTitle?.text = "Cancellation in \(cancellation.range)"
            rightTitle?.text = "\(offer.payment_terms.delay_in_start.deposit)%"
        } else if row == 2 {
            let cancellation = offer.payment_terms.cancellation[row-1]
            leftTitle?.text = "Cancellation in \(cancellation.range)"
            rightTitle?.text = "\(offer.payment_terms.delay_in_start.deposit)%"
        } else if row == 3 {
            let cancellation = offer.payment_terms.cancellation[row-1]
            leftTitle?.text = "Cancellation in \(cancellation.range)"
            rightTitle?.text = "\(offer.payment_terms.delay_in_start.deposit)%"
        }
    }

}
