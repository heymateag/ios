//
//  ChooseScheduleCell.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 07/11/21.
//

import UIKit

class ChooseScheduleCell: UITableViewCell {

    @IBOutlet var scheduleFrom: UILabel!
    @IBOutlet var scheduleTo: UILabel!
    open override func awakeFromNib() {
        super.awakeFromNib()
    }

    func showSchedule(_ schedule:OfferDetailsSchedule) {
        scheduleFrom.isHidden = false
        scheduleTo.isHidden = false
        
        if let milliSecs = Double(schedule.form_time) {
            scheduleFrom.text = "From: \(AppUtils.getScheduledDateDisplay(milliSeconds: milliSecs))"
        } else {
            scheduleFrom.isHidden = true
        }
        if let milliSecs = Double(schedule.to_time) {
            scheduleTo.text = "To: \(AppUtils.getScheduledDateDisplay(milliSeconds: milliSecs))"
        } else {
            scheduleTo.isHidden = true
        }
    }
}
