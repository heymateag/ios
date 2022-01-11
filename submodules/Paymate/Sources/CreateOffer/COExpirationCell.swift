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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
