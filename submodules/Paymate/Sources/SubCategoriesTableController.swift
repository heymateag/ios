//
//  SubCategoriesTableController.swift
//  TelegramSample
//
//  Created by Heymate on 25/09/21.
//

import UIKit

protocol SubCategorySelectionDelegate {
    func didSelectSubCategory(_ category:CategoryModel)
}

class SubCategoriesTableController: UITableViewController {

    var subCategoryDelegate:SubCategorySelectionDelegate?
    private var subCategories:[CategoryModel] = [] {
        didSet {
            if subCategories.isEmpty {
                let headLineLabel = AppUtils.sharedInstance.getHeadingLabel()
                headLineLabel.text = "No Data Available"
                headLineLabel.textAlignment = .center
                tableView.tableFooterView = headLineLabel
            } else {
                tableView.reloadData()
            }
        }
    }
    private var currentSelectedIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }
}

extension SubCategoriesTableController {
    func loadSubCategoriesForCategory(_ category:CategoryModel) {
        PeyServiceController.shared.getSubCategories(request: SubCategoryRequest(category: category.name)) {[weak self] (result, _) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.subCategories = response.data.map({ (subCat) -> CategoryModel in
                    return CategoryModel(name: subCat, isSelected: false)
                })
            case .failure(let error):
                print("error sub cat \(error)")
            }
        }
    }
}

extension SubCategoriesTableController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell {
            let category = subCategories[indexPath.row]
            cell.configCategory(category: category)
            cell.categoryButton.isSelected = category.isSelected
            cell.categoryButton.addTarget(self, action: #selector(onSubCategory), for: .touchUpInside)
            return cell
        }
        return UITableViewCell(frame: .zero)
    }
    
    @objc func onSubCategory(btn:UIButton) {
        if let cell = btn.superview?.superview?.superview as? CategoryCell,let path = tableView.indexPath(for: cell) {
            if !btn.isSelected {
                btn.isSelected = !btn.isSelected
                subCategories[currentSelectedIndex].isSelected = !subCategories[currentSelectedIndex].isSelected
                subCategories[path.row].isSelected = !subCategories[path.row].isSelected
                tableView.reloadRows(at: [IndexPath(row: currentSelectedIndex, section: 0),path], with: .none)
                subCategoryDelegate?.didSelectSubCategory(subCategories[path.row])
                currentSelectedIndex = path.row
            }
        }
    }
}
