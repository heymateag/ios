//
//  COTermsCell.swift
//  GraphApp
//
//  Created by Heymate on 09/11/21.
//

import UIKit

class COTermsCell: UITableViewCell {

    @IBOutlet var termsLabel: UILabel!
    @IBOutlet weak var detailsSv: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsSv.isHidden = true
        
    }

    func configTerms(_ terms:String) {
        termsLabel.text = terms
    }

}
