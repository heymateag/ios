//
//  RadioButton.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 06/11/21.
//

import UIKit

open class RadioButton:UIButton {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setImage(UIImage(named: "radio_unselected"), for: .normal)
        self.setImage(UIImage(named: "radio_selected"), for: .selected)
        
        self.setTitleColor(AppUtils.COLOR_PRIMARY3(), for: .selected)
        self.setTitleColor(AppUtils.COLOR_BLACK(), for: .normal)
    }
}
