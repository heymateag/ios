//
//  ScheduleOptionsTableViewController.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 15/11/21.
//

import UIKit

class ScheduleOptionsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 250, height: 250)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell")
        cell?.selectionStyle = .none
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "optionsCell")
        }
        if indexPath.row == 0 {
            cell?.textLabel?.text = "View details"
        } else {
            cell?.textLabel?.text = "Cancel"
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }

}
