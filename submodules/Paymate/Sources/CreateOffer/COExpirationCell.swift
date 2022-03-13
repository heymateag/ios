//
//  COExpirationCell.swift
//  GraphApp
//
//  Created by Heymate on 09/11/21.
//

import UIKit

class COExpirationCell: UITableViewCell {

    @IBOutlet var btnExpiry: UIButton!
    @IBOutlet weak var detailsSv: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsSv.isHidden = true
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 10

        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        btnExpiry.setTitle(Date.getScheduleDisplayFormat(date: futureDate ?? Date()), for: .normal)
//        btnExpiry.setTitle(Date.getScheduleDisplayFormat(date:futureDate?? Date()), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
