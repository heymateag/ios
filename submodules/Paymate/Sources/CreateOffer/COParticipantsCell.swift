//
//  COParticipantsCell.swift
//  GraphApp
//
//  Created by Heymate on 08/11/21.
//

import UIKit

class COParticipantsCell: UITableViewCell {

    @IBOutlet var noofUsersField: UITextField!
    @IBOutlet var unlimitedBtn: UIButton!
    @IBOutlet var noOfParticField: UITextField!
    @IBOutlet weak var detailsSV: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsSV.isHidden = true
        noOfParticField.borderStyle = .none
        noOfParticField.addBottomBorder()
        
        unlimitedBtn.roundedPaymateView(cornerRadius: 4)
        unlimitedBtn.setImage(UIImage(named: "tickMark"), for: .selected)
        unlimitedBtn.setImage(nil, for: .normal)
        unlimitedBtn.isSelected = false
    }

    func configParticipantsSelection() {
        if unlimitedBtn.isSelected {
            noofUsersField.text = ""
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
