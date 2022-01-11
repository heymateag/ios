//
//  OfferDetailsTermsCell.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 06/11/21.
//

import UIKit

open class OfferDetailsTermsCell:UITableViewCell {
    
    @IBOutlet var penality: UILabel!
    @IBOutlet var termName: UILabel!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureTerms(offer:OfferDetails,row:Int) {
        if row == 0 {
            termName?.text = "Delays in start by < \(offer.payment_terms.delay_in_start.duration) mins"
            penality?.text = "\(offer.payment_terms.delay_in_start.deposit)%"
        } else if row == 1 {
            let cancellation = offer.payment_terms.cancellation[row-1]
            termName?.text = "Cancellation in \(cancellation.range)"
            penality?.text = "\(offer.payment_terms.delay_in_start.deposit)%"
        } else if row == 2 {
            let cancellation = offer.payment_terms.cancellation[row-1]
            termName?.text = "Cancellation in \(cancellation.range)"
            penality?.text = "\(offer.payment_terms.delay_in_start.deposit)%"
        } else if row == 3 {
            let cancellation = offer.payment_terms.cancellation[row-1]
            termName?.text = "Cancellation in \(cancellation.range)"
            penality?.text = "\(offer.payment_terms.delay_in_start.deposit)%"
        }
    }
}
