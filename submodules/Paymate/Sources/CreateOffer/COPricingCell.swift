//
//  COPricingCell.swift
//  GraphApp
//
//  Created by Heymate on 09/11/21.
//

import UIKit

class COPricingCell: UITableViewCell {

    @IBOutlet var subscriptionCheckbox: UIButton!
    @IBOutlet var bundleCheckbox: UIButton!
    @IBOutlet var subscField: InputField!
    @IBOutlet var bundleDiscField: InputField!
    @IBOutlet var bundleSessionsField: InputField!
    @IBOutlet var fixPriceField: InputField!
    @IBOutlet weak var detailsSv: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsSv.isHidden = true
        
        bundleCheckbox.configForCheckBox()
        subscriptionCheckbox.configForCheckBox()
        
        bundleCheckbox.isSelected = false
        subscriptionCheckbox.isSelected = false
        
        subscField.borderStyle = .none
        fixPriceField.borderStyle = .none
        bundleDiscField.borderStyle = .none
        bundleSessionsField.borderStyle = .none
        
        subscField.addBottomBorder()
        fixPriceField.addBottomBorder()
        bundleSessionsField.addBottomBorder()
        bundleDiscField.addBottomBorder()
        
        
    }
}
