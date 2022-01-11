//
//  COTermsCell.swift
//  GraphApp
//
//  Created by Heymate on 09/11/21.
//

import UIKit

class COPaymentTermsCell: UITableViewCell {

    @IBOutlet var cancelRangePercentage: UIButton!
    @IBOutlet var cancelHrEnd: UIButton!
    @IBOutlet var cancelHrStart: UIButton!
    @IBOutlet var cancellationHrsStartPercentage: UIButton!
    @IBOutlet var cancellationHrsStart: UIButton!
    @IBOutlet var depositPercentage: UIButton!
    @IBOutlet var delayStartPercentage: UIButton!
    @IBOutlet var delayInStartMins: UIButton!
    @IBOutlet weak var detailsSV: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsSV.isHidden = true
        // Initialization code
    }

    func configDelayInStart(term:CreateOfferTableViewController.PayTerm) {
        delayInStartMins.setTitle("\(term.constraintTime)", for: .normal)
        delayStartPercentage.setTitle("\(term.percentage)%", for: .normal)
    }
    
    func configDeposit(term:CreateOfferTableViewController.PayTerm) {
        depositPercentage.setTitle("\(term.percentage)%", for: .normal)
    }
    
    func configCancellationHours(term:CreateOfferTableViewController.PayTerm) {
        cancellationHrsStart.setTitle("\(term.constraintTime)", for: .normal)
        cancellationHrsStartPercentage.setTitle("\(term.percentage)%", for: .normal)
    }

    func configCancelRange(term:CreateOfferTableViewController.PayTerm) {
        cancelHrStart.setTitle("\(term.startHour)", for: .normal)
        cancelHrEnd.setTitle("\(term.endHour)", for: .normal)
        cancelRangePercentage.setTitle("\(term.percentage)%", for: .normal)
    }
    
}
