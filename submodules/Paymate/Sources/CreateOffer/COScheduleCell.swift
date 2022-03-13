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
        let schTitle = UIButton(type: .custom)
        schTitle.setTitle(nil, for: .normal)
//        schTitle.setTitle("Schedule \(index)", for: .normal)
        schTitle.titleLabel?.textColor = .black
        schTitle.setImage(UIImage(named: "close"), for: .normal)
        schTitle.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        schTitle.addTarget(self, action: #selector(didDeleteSchedule(sender:)), for: .touchUpInside)
        schTitle.contentHorizontalAlignment = .left
        schTitle.tintColor = UIColor.red
        let btnConstraints:[NSLayoutConstraint] = [
            schTitle.widthAnchor.constraint(equalToConstant: 20),
            schTitle.heightAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(btnConstraints)
//        schTitle.addConstraint(NSLayoutConstraint())
//        schTitle.setTitleColor(.black, for: .normal)
//        schTitle.titleLabel?.minimumScaleFactor = 0.5
//        schTitle.titleLabel?.adjustsFontSizeToFitWidth = true
        schTitle.accessibilityLabel = schedule.scheduleId
        
        let fromSchedule = UIButton(type: .custom)
        fromSchedule.setTitleColor(AppUtils.COLOR_BLUE(), for: .normal)
        fromSchedule.titleLabel?.font = AppUtils.APP_FONT(size: 12)
        fromSchedule.setTitle("\(Date.getShortHandSchedule(date: schedule.fromDate))", for: .normal)
//        fromSchedule.setTitle("From: \(Date.getScheduleDisplayFormat(date: schedule.fromDate))", for: .normal)
        fromSchedule.contentHorizontalAlignment = .left
        fromSchedule.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let toSchedule = UIButton(type: .custom)
        toSchedule.setTitleColor(AppUtils.COLOR_BLUE(), for: .normal)
        toSchedule.titleLabel?.font = AppUtils.APP_FONT(size: 12)
        toSchedule.setTitle("\(Date.getShortHandSchedule(date: schedule.toDate))", for: .normal)
//        toSchedule.setTitle("To: \(Date.getScheduleDisplayFormat(date: schedule.toDate))", for: .normal)
        toSchedule.contentHorizontalAlignment = .center
        fromSchedule.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let stackView = UIStackView(arrangedSubviews: [fromSchedule,toSchedule,schTitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .fill
//        let svConstraints:[NSLayoutConstraint] = [
//            stackView.leadingAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutXAxisAnchor>#>, constant: <#T##CGFloat#>)
//            schTitle.heightAnchor.constraint(equalToConstant: 20)
//        ]
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
