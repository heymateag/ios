//
//  OfferDetailsTnCCell.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 06/11/21.
//

import UIKit

open class OfferDetailsTnCCell: UITableViewCell {
    @IBOutlet var offerTerms: UILabel!
    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onSeemoreTerms(_ sender: Any) {
    }
    
    func configureOffer(_ offer:OfferDetails) {
        offerTerms.text = offer.term_condition
        if offer.term_condition.isEmpty {
        }
    }
}
