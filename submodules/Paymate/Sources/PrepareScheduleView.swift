//
//  PrepareScheduleView.swift
//  _idx_Paymate_CC5DF701_ios_min9.0
//
//  Created by Heymate on 31/10/21.
//

import UIKit

class PrepareScheduleHeaderView {
    private var myOffersBtn:UIButton?
    private var myOffersBadge:UILabel?
    private var myOfferSelection:UIView?
    
    private var myOrdersBtn:UIButton?
    private var myOrdersBadge:UILabel?
    private var myOrderSelection:UIView?
    
    private var scheduleRange:UILabel?
    private var filterButton:UIButton?
    
    
    func prepareScheduleHeaderView(view:UIView) -> (offersBtn:UIButton?,ordersBtn:UIButton?) {
        myOffersBtn = view.viewWithTag(ScheduleHeaderViewTags.MyOffersBtn.rawValue) as? UIButton
        myOffersBadge = view.viewWithTag(ScheduleHeaderViewTags.MyOffersBadge.rawValue) as? UILabel
        myOfferSelection  = view.viewWithTag(ScheduleHeaderViewTags.MyOffersBorderView.rawValue)
        
        myOrdersBtn = view.viewWithTag(ScheduleHeaderViewTags.MyOrdersBtn.rawValue) as? UIButton
        myOrdersBadge = view.viewWithTag(ScheduleHeaderViewTags.MyOrdersBadge.rawValue) as? UILabel
        myOrderSelection  = view.viewWithTag(ScheduleHeaderViewTags.MyOrdersBorderView.rawValue)
        
        scheduleRange = view.viewWithTag(ScheduleHeaderViewTags.TimeLineRange.rawValue) as? UILabel
        filterButton = view.viewWithTag(ScheduleHeaderViewTags.FilterBtn.rawValue) as? UIButton
        
        myOffersBadge?.layer.cornerRadius = 15
        myOffersBadge?.clipsToBounds = true

        myOrdersBadge?.layer.cornerRadius = 15
        myOrdersBadge?.clipsToBounds = true
        
        myOffersBtn?.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.7), for: .normal)
        myOffersBtn?.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .selected)
        
        myOrdersBtn?.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.7), for: .normal)
        myOrdersBtn?.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .selected)
        
        
        return (myOffersBtn,myOrdersBtn)
    }
    
    func updateOffers(count:Int) {
        myOffersBadge?.isHidden = false
        myOffersBadge?.text = "\(count)"
    }
    
    func updateOrders(count:Int) {
        myOrdersBadge?.isHidden = false
        myOrdersBadge?.text = "\(count)"
    }
    
    func didSelectOffers() {
        myOffersBtn?.isSelected = true
        myOrdersBtn?.isSelected = false
        myOffersBadge?.isHidden = false
        myOrdersBadge?.isHidden = true
        myOfferSelection?.isHidden = false
        myOrderSelection?.isHidden = true
    }
    
    func didSelectOrders() {
        myOffersBtn?.isSelected = false
        myOrdersBtn?.isSelected = true
        myOffersBadge?.isHidden = true
        myOrdersBadge?.isHidden = false
        myOfferSelection?.isHidden = true
        myOrderSelection?.isHidden = false
    }
    
}



class ScheduleListView {
    
    
    static func prepareViewForOrderCell(_ cell:UITableViewCell,schedule:MyOrder) {
        let _ = cell.viewWithTag(ScheduleCellTags.AvatarImage.rawValue) as? UIImageView
        let name = cell.viewWithTag(ScheduleCellTags.Name.rawValue) as? UILabel
        let offercategory = cell.viewWithTag(ScheduleCellTags.OfferDetails.rawValue) as? UILabel
        let statusView = cell.viewWithTag(ScheduleCellTags.StatusLableView.rawValue)
        statusView?.layer.cornerRadius = 10
        statusView?.clipsToBounds = true
        
        let confirmBtn = cell.viewWithTag(ScheduleCellTags.ConfirmationBtn.rawValue) as? UIButton
        confirmBtn?.layer.cornerRadius = 4
        confirmBtn?.setTitle("Join", for: .normal)
        
        let statusOfOffer = cell.viewWithTag(ScheduleCellTags.StatusLabel.rawValue) as? UILabel
        statusOfOffer?.text = schedule.status
        name?.text = schedule.offer?.title
        offercategory?.text = schedule.offer?.category.main_cat
//        avatar?.image =
    }

    static func prepareViewForOfferCell(_ cell:UITableViewCell,schedule:OfferDetails) {
        let _ = cell.viewWithTag(ScheduleCellTags.AvatarImage.rawValue) as? UIImageView
        let name = cell.viewWithTag(ScheduleCellTags.Name.rawValue) as? UILabel
        let offercategory = cell.viewWithTag(ScheduleCellTags.OfferDetails.rawValue) as? UILabel
        let statusView = cell.viewWithTag(ScheduleCellTags.StatusLableView.rawValue)
        statusView?.layer.cornerRadius = 10
        statusView?.clipsToBounds = true
        
        let confirmBtn = cell.viewWithTag(ScheduleCellTags.ConfirmationBtn.rawValue) as? UIButton
        confirmBtn?.layer.cornerRadius = 4
        
        let statusOfOffer = cell.viewWithTag(ScheduleCellTags.StatusLabel.rawValue) as? UILabel
        statusOfOffer?.text = schedule.is_online_meeting ?? false ? "Online" : "Offline"
        name?.text = schedule.title
        offercategory?.text = schedule.category.main_cat
//        avatar?.image =
    }
}
