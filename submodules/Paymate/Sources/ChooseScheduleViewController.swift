//
//  ChooseScheduleViewController.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 07/11/21.
//

import UIKit

open class ChooseScheduleViewController: UIViewController {

    @IBOutlet var scheduleTableView: UITableView!
    public var onConfirmSchedule:((_ schedule:OfferDetailsSchedule) -> Void)?
    open var mSchedules:[OfferDetailsSchedule] = []
    open var currentSelectedScheduleId:String?
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTableView.register(UINib(nibName: "ChooseScheduleCell", bundle: Bundle.main), forCellReuseIdentifier: "ChooseScheduleCell")
//        scheduleTableView.roundedPaymateView(cornerRadius: 8)
    }

    @IBAction func onCancelNavBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChooseScheduleViewController:UITableViewDelegate,UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mSchedules.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseScheduleCell") as? ChooseScheduleCell {
            let _schedule = mSchedules[indexPath.row]
            if currentSelectedScheduleId != nil,_schedule.id == currentSelectedScheduleId {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            cell.showSchedule(mSchedules[indexPath.row])
            return cell
        }
        return UITableViewCell(frame: .zero)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {[unowned self] in
            self.onConfirmSchedule?(self.mSchedules[indexPath.row])
        }
//        onCancelNavBtn(tableView)
    }
    
    @objc func onChooseSchedule(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if let cell = sender.superview?.superview as? ChooseScheduleCell,let path = scheduleTableView.indexPath(for: cell) {
            onConfirmSchedule?(mSchedules[path.row])
            onCancelNavBtn(sender)
        }
    }
}
