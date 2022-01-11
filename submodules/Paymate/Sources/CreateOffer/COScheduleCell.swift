//
//  COScheduleCell.swift
//  GraphApp
//
//  Created by Heymate on 09/11/21.
//

import UIKit

protocol ScheduleCellDelegate {
    func didDeleteSchedule(_ id:String)
}

class COScheduleCell: UITableViewCell {

    @IBOutlet var userSchedules: UIStackView!
    @IBOutlet weak var btnAddSchedule: UIButton!
    @IBOutlet weak var detailsSV: UIStackView!
    var dDelegate:ScheduleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailsSV.isHidden = true
    }
    
    private func getScheduleStackView(index:Int,schedule:CreateOfferTableViewController.Schedule) -> UIStackView {
        let schTitle = UIButton()
        schTitle.setTitle("Schedule \(index)", for: .normal)
        schTitle.titleLabel?.textColor = .black
        schTitle.setImage(UIImage(named: "close"), for: .normal)
        schTitle.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        schTitle.addTarget(self, action: #selector(didDeleteSchedule(sender:)), for: .touchUpInside)
        schTitle.contentHorizontalAlignment = .left
        schTitle.setTitleColor(.black, for: .normal)
        schTitle.titleLabel?.minimumScaleFactor = 0.5
        schTitle.titleLabel?.adjustsFontSizeToFitWidth = true
        schTitle.accessibilityLabel = schedule.scheduleId
        
        let fromSchedule = UIButton(type: .custom)
        fromSchedule.setTitleColor(AppUtils.COLOR_BLUE(), for: .normal)
        fromSchedule.titleLabel?.font = AppUtils.APP_FONT(size: 12)
        fromSchedule.setTitle("From: \(Date.getScheduleDisplayFormat(date: schedule.fromDate))", for: .normal)
        fromSchedule.contentHorizontalAlignment = .left

        let toSchedule = UIButton(type: .custom)
        toSchedule.setTitleColor(AppUtils.COLOR_BLUE(), for: .normal)
        toSchedule.titleLabel?.font = AppUtils.APP_FONT(size: 12)
        toSchedule.setTitle("To: \(Date.getScheduleDisplayFormat(date: schedule.toDate))", for: .normal)
        toSchedule.contentHorizontalAlignment = .left
        
        let stackView = UIStackView(arrangedSubviews: [schTitle,fromSchedule,toSchedule])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        return stackView
    }
    
    
    
    func addScheduleToView(_ schedule:CreateOfferTableViewController.Schedule,index:Int) {
        userSchedules.addArrangedSubview(getScheduleStackView(index: index, schedule: schedule))
    }

    
    @objc private func didDeleteSchedule(sender:UIButton) {
        if let id = sender.accessibilityLabel {
            dDelegate?.didDeleteSchedule(id)
        }
    }

}
