//
//  SettingsCategoryView.swift
//  TelegramSample
//
//  Created by Heymate on 14/09/21.
//

import UIKit
//import Combine

class SettingsCategoryView: UIView {

    var embededController:UIViewController?
    private var model:CategorySelectionModel = CategorySelectionModel(category: nil, subCategory: nil)
//    var viewModelChanges = PassthroughSubject<CategorySelectionModel,Never>()
    var modelChanges:((CategorySelectionModel) -> Void)?
    
    private lazy var categoryStackView:UIStackView = {
        let _stackView = UIStackView()
        _stackView.axis = .horizontal
        _stackView.distribution = .fillEqually
        _stackView.alignment = .center
        _stackView.translatesAutoresizingMaskIntoConstraints = false
        _stackView.spacing = 16
        return _stackView
    }()
    
    private lazy var categoryButton:UIButton = {
        let _button = AppUtils.sharedInstance.getRoundedButtonWithRadius(8)
        _button.layer.borderColor = AppUtils.COLOR_GREEN().cgColor
        _button.layer.borderWidth = 3
        _button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        _button.addTarget(self, action: #selector(onShowCategory), for: .touchUpInside)
        _button.isHidden = true
        return _button
    }()
    
    private lazy var subCategoryButton:UIButton = {
        let _button = AppUtils.sharedInstance.getRoundedButtonWithRadius(8)
        _button.layer.borderColor = AppUtils.COLOR_GREEN().cgColor
        _button.layer.borderWidth = 3
        _button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        _button.addTarget(self, action: #selector(onShowCategory), for: .touchUpInside)
        _button.isHidden = true
        return _button
    }()
    
    private lazy var chooseCategoryBtn:UIButton = {
        let _button = AppUtils.sharedInstance.getRoundedButtonWithRadius(8)
//        _button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        _button.setTitle("Choose category", for: .normal)
        _button.addTarget(self, action: #selector(onShowCategory), for: .touchUpInside)
        return _button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("embededController \(embededController)")
        showSelectedCategories()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func showSelectedCategories() {
        addSubview(categoryStackView)
        let stackConstraints = [
            categoryStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 32),
            categoryStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 0),
            categoryStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            categoryStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        ]
        
        
        categoryStackView.addArrangedSubview(chooseCategoryBtn)
        categoryStackView.addArrangedSubview(categoryButton)
        categoryStackView.addArrangedSubview(subCategoryButton)
        
        NSLayoutConstraint.activate(stackConstraints)
    }
      
    @objc func onShowCategory() {
        let controller = CategoryHomeViewController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        controller.categoryHomeDelegate = self
        embededController?.present(controller, animated: true, completion: nil)
    }
}

extension SettingsCategoryView:CategoryHomeSelectionDelegate {
    func didSelectCategoryAndSubcategory(category: CategoryModel, subCategory: CategoryModel) {
        categoryButton.setTitle(category.name, for: .normal)
        subCategoryButton.setTitle(subCategory.name, for: .normal)
        chooseCategoryBtn.isHidden = true
        categoryButton.isHidden = false
        subCategoryButton.isHidden = false
        model.category = category
        model.subCategory = subCategory
//        viewModelChanges.send(model)
        modelChanges?(model)
    }
}
