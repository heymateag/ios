//
//  CategoryHomeViewController.swift
//  TelegramSample
//
//  Created by Heymate on 25/09/21.
//

import UIKit

protocol CategoryHomeSelectionDelegate {
    func didSelectCategoryAndSubcategory(category:CategoryModel,subCategory:CategoryModel)
}

class CategoryHomeViewController: UIViewController {

    var categoryHomeDelegate:CategoryHomeSelectionDelegate?
    private let categoriesController = CategoriesTableViewController()
    private let subCategoriesController = SubCategoriesTableController()
    private var selectedCategory:CategoryModel? {
        didSet {
            if let category = selectedCategory {
                subCategoriesController.loadSubCategoriesForCategory(category)
            }
        }
    }
    private var selectedSubCategory:CategoryModel? {
        didSet {
            if let cat = selectedCategory,let subCat = selectedSubCategory {
                dismiss(animated: true, completion: nil)
                categoryHomeDelegate?.didSelectCategoryAndSubcategory(category: cat, subCategory: subCat)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(onViewtapped))
//        view.addGestureRecognizer(gesture)
        addEmbedCategories()
    }

    private func addEmbedCategories() {

        let categoriesContainerView = UIView()
        let subCategoryContainerView = UIView()
        //
        let tableviewHolderView = UIView() // holds stackview
        tableviewHolderView.backgroundColor = .white
        tableviewHolderView.layer.cornerRadius = 8
        tableviewHolderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableviewHolderView)

        var holderViewConstraints:[NSLayoutConstraint] = [
            tableviewHolderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableviewHolderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableviewHolderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ]
        holderViewConstraints.append(NSLayoutConstraint.init(item: tableviewHolderView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 4/5, constant: 0.0))
        NSLayoutConstraint.activate(holderViewConstraints)
        //holds both tableviews
        let embededStackView = UIStackView(arrangedSubviews: [categoriesContainerView,subCategoryContainerView])
        embededStackView.axis = .horizontal
        embededStackView.distribution = .fillEqually
        embededStackView.alignment = .fill
        embededStackView.spacing = 16
        embededStackView.translatesAutoresizingMaskIntoConstraints = false
        tableviewHolderView.addSubview(embededStackView)
        
        let stackContraints:[NSLayoutConstraint] = [
            embededStackView.leadingAnchor.constraint(equalTo: tableviewHolderView.leadingAnchor, constant: 8),
            embededStackView.trailingAnchor.constraint(equalTo: tableviewHolderView.trailingAnchor, constant: -8),
            embededStackView.bottomAnchor.constraint(equalTo: tableviewHolderView.bottomAnchor, constant: 0),
            embededStackView.topAnchor.constraint(equalTo: tableviewHolderView.topAnchor, constant: 16)
        ]
        NSLayoutConstraint.activate(stackContraints)
        //
        
        categoriesController.view.translatesAutoresizingMaskIntoConstraints = false
        subCategoriesController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(categoriesController)
        addChild(subCategoriesController)
        
        categoriesContainerView.addSubview(categoriesController.view)
        subCategoryContainerView.addSubview(subCategoriesController.view)
        
        categoriesController.didMove(toParent: self)
        subCategoriesController.didMove(toParent: self)
        
        categoriesController.categoryDelegate = self
        subCategoriesController.subCategoryDelegate = self
    }
}


extension CategoryHomeViewController:CategorySelectionDelegate,SubCategorySelectionDelegate {
    
    @objc func onViewtapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func didSelectCategory(_ category: CategoryModel) {
        selectedCategory = category
    }
    
    func didSelectSubCategory(_ category: CategoryModel) {
        selectedSubCategory = category
    }
}
