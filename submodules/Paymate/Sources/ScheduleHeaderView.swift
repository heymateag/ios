//
//  ScheduleHeaderView.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 08/11/21.
//

import UIKit

open class ScheduleHeaderView: UIView {

    @IBOutlet var orderSelectionView: UIView!
    @IBOutlet var ordersBadge: UILabel!
    @IBOutlet var btnMyOrders: UIButton!
    @IBOutlet var offerSelectionView: UIView!
    @IBOutlet var badgeOffers: UILabel!
    @IBOutlet var btnMyOffers: UIButton!
    var onSegmentSelection:((_ isOrders:Bool,_ isOffers:Bool) -> Void)?
    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        badgeOffers?.layer.cornerRadius = 12.5
        badgeOffers?.clipsToBounds = true

        ordersBadge?.layer.cornerRadius = 12.5
        ordersBadge?.clipsToBounds = true
        
        btnMyOffers?.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.7), for: .normal)
        btnMyOffers?.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .selected)
        
        btnMyOrders?.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.7), for: .normal)
        btnMyOrders?.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .selected)
        
        btnMyOrders.addTarget(self, action: #selector(didSelectOrders), for: .touchUpInside)
        btnMyOffers.addTarget(self, action: #selector(didSelectOffers), for: .touchUpInside)
        didSelectOffers()
    }
    
    func updateOrdersCount(count:Int) {
        ordersBadge.text = "\(count)"
    }
    func updateOffersCount(count:Int) {
        badgeOffers.text = "\(count)"
    }
    
    @objc func didSelectOffers() {
        btnMyOffers?.isSelected = true
        btnMyOrders?.isSelected = false
        badgeOffers?.isHidden = false
        ordersBadge?.isHidden = true
        offerSelectionView?.isHidden = false
        orderSelectionView?.isHidden = true
        onSegmentSelection?(false,true)
    }
    
    @objc func didSelectOrders() {
        btnMyOffers?.isSelected = false
        btnMyOrders?.isSelected = true
        badgeOffers?.isHidden = true
        ordersBadge?.isHidden = false
        offerSelectionView?.isHidden = true
        orderSelectionView?.isHidden = false
        onSegmentSelection?(true,false)
    }
}
