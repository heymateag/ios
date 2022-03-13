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
        setCheckBoxToUnSelected()
    }

    func configParticipantsSelection() {
        if unlimitedBtn.isSelected {
            noofUsersField.text = ""
            unlimitedBtn.layer.borderWidth = 0
            unlimitedBtn.backgroundColor = UIColor(red: 84/255, green: 167/255, blue: 229/255, alpha: 1)
        } else {
            setCheckBoxToUnSelected()
        }
    }
    
    private func setCheckBoxToUnSelected() {
        unlimitedBtn.backgroundColor = .clear
        unlimitedBtn.layer.borderColor = UIColor.gray.cgColor
        unlimitedBtn.layer.borderWidth = 1.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
