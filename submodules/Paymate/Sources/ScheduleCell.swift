//
//  ScheduleCell.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 06/11/21.
//

import UIKit

open class ScheduleCell: UITableViewCell {

    @IBOutlet var meetingActionBtn: UIButton!
    @IBOutlet var meetingTimeStatus: UILabel!
    @IBOutlet var meetingStatusImage: UIImageView!
    @IBOutlet var scheduleStatus: UILabel!
    @IBOutlet var scheduleStatusView: UIView!
    @IBOutlet var offerCategory: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userAvatar: UIImageView!
    @IBOutlet var mtngActionView: UIView!
    @IBOutlet var bottomStackView: UIStackView!
    @IBOutlet var btnMoreOptions: UIButton!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        mtngActionView.roundedPaymateView(cornerRadius: 4)
        scheduleStatusView.roundedPaymateView(cornerRadius: 10)
    }

    func configureForOffer(_ schedule:OfferDetails) {
        userName.text = schedule.title
    }

    func configureForOrder(_ order:MyOrder) {
        userName.text = order.offer?.title
        offerCategory.text = "\(order.offer?.category.main_cat ?? "")-\(order.offer?.category.sub_cat ?? "")"
        scheduleStatus.text = order.status
        let colorCodes = ScheduleCell.getColorCodesForStatus(status: order.status ?? "")
        scheduleStatusView.backgroundColor = colorCodes.backgroundColor
        scheduleStatus.textColor = colorCodes.textColor
        bottomStackView.isHidden = false
        
//        var startDate = Date()
//        var endDate = Date()
//        if let start = order.time_slot?.form_time,let intStart = Int(start) {
//            startDate = Date.getDateFromMilliSeconds(seconds: intStart)
//        }
//        if let end = order.time_slot?.to_time,let intEnd = Int(end) {
//            endDate = Date.getDateFromMilliSeconds(seconds: intEnd)
//        }
//        let today = Date()
//        if today.compare(startDate) == .orderedAscending {//meeting about to start
//            meetingActionBtn.isEnabled = false
//            mtngActionView.alpha = 0.6
//        } else if today.compare(startDate) == .orderedDescending,today.compare(endDate) == .orderedDescending { //in progress
//            meetingStatusImage.image = UIImage(named: "inprogress")
//            let components = Date.getDifferentComponents(date1: today, date2: endDate)
//            meetingTimeStatus.text = "\(components.hour ?? 00):\(components.minute ?? 00):\(components.second ?? 00) remains"
//            meetingActionBtn.setTitle("Join", for: .normal)
//        } else if today.compare(endDate) == .orderedAscending { //finished
//            bottomStackView.isHidden = true
//        }
//
//        if order.status ?? "" == "finished" {
//
//        }
    }
    
    static func getColorCodesForStatus(status:String) -> (backgroundColor:UIColor,textColor:UIColor) {
        if status.lowercased() == "pending" {
            return (AppUtils.COLOR_YELLOW5(),AppUtils.COLOR_YELLOW())
        } else if status.lowercased().contains("progress") {
            return (AppUtils.COLOR_PRIMARY6(),AppUtils.COLOR_PRIMARY3())
        } else if status.lowercased() == "finished" {
            return (AppUtils.COLOR_LIGHT_GRAY6(),AppUtils.COLOR_LIGHT_GRAY2())
        }
        return (AppUtils.COLOR_GREEN3(),AppUtils.COLOR_GREEN2())
    }
    
}
