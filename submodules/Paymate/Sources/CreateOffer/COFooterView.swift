//
//  COFooterView.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 14/11/21.
//

import UIKit

class COFooterView: UIView {

    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnPromote: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnSave.roundedPaymateView(cornerRadius: 8)
        btnPromote.roundedPaymateView(cornerRadius: 8)
    }
    
}
