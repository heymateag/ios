//
//  COLocationCell.swift
//  GraphApp
//
//  Created by Heymate on 08/11/21.
//

import UIKit

class COLocationCell: UITableViewCell {
    @IBOutlet weak var detailsSV: UIStackView!
    @IBOutlet var isOnlinecheckbox: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsSV.isHidden = true
        
        isOnlinecheckbox.roundedPaymateView(cornerRadius: 4)
        isOnlinecheckbox.configForCheckBox()
        
    }
    @IBAction func onIsOnline(_ sender: Any) {
        
    }

}
