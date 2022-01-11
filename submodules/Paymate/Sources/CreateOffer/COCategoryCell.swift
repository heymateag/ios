//
//  COCategoryCell.swift
//  GraphApp
//
//  Created by Heymate on 07/11/21.
//

import UIKit

class COCategoryCell: UITableViewCell {

    @IBOutlet var btnSubCategory: UIButton!
    @IBOutlet var btnCategory: UIButton!
    @IBOutlet weak var detailsStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsStackView.isHidden = true
        btnSubCategory.backgroundColor = .clear
        btnCategory.backgroundColor = .clear
//        btnSubCategory.decorateAsCategoryButton()
//        btnSubCategory.decorateAsCategoryButton()
        btnCategory.layer.borderColor = AppUtils.COLOR_GREEN().cgColor
        btnCategory.layer.borderWidth = 1
        btnCategory.layer.cornerRadius = 8
        
        btnCategory.setTitleColor(AppUtils.COLOR_BLACK(), for: .normal)
        btnSubCategory.setTitleColor(AppUtils.COLOR_BLACK(), for: .normal)
        
        
        btnSubCategory.layer.borderColor = AppUtils.COLOR_GREEN().cgColor
        btnSubCategory.layer.borderWidth = 1
        btnSubCategory.layer.cornerRadius = 8
        
        
    }
    
    func updateSelection(category:CategoryModel?,subCategory:CategoryModel?) {
        btnCategory.setTitle(category?.name ?? "Tap to Choose", for: .normal)
        btnSubCategory.setTitle(subCategory?.name ?? "Tap to Choose", for: .normal)
//        btnCategory.isSelected = true
//        btnSubCategory.isSelected = true
    }
    
}
