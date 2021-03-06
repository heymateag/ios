//
//  CategoriesTableViewController.swift
//  TelegramSample
//
//  Created by Heymate on 25/09/21.
//

import UIKit

protocol CategorySelectionDelegate {
    func didSelectCategory(_ category:CategoryModel)
}

class CategoriesTableViewController: UITableViewController {

    var categoryDelegate:CategorySelectionDelegate?
    private var currentSelectedIndex:Int = 0
    
    private var categories:[CategoryModel] = []
//    {
//        didSet {
//            if categories.isEmpty {
//                let headLineLabel = AppUtils.sharedInstance.getHeadingLabel()
//                headLineLabel.text = "No Data Available"
//                headLineLabel.textAlignment = .center
//                tableView.tableFooterView = headLineLabel
//            } else {
//                currentSelectedIndex = 0
//                categories[currentSelectedIndex].isSelected = true
//                categoryDelegate?.didSelectCategory(categories[0])//load for very first category
//                tableView.tableFooterView = nil
//                tableView.reloadData()
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        getCategories()
    }
}

extension CategoriesTableViewController {
    private func getCategories() {
        PeyServiceController.shared.getCategories(request: EmptyRequest()) {[weak self] (result, _) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.categories = response.data.map({ (category) -> CategoryModel in
                    return CategoryModel(name: category, isSelected: false)
                })
                if self.categories.isEmpty {
                    let headLineLabel = AppUtils.sharedInstance.getHeadingLabel()
                    headLineLabel.text = "No Data Available"
                    headLineLabel.textAlignment = .center
                    self.tableView.tableFooterView = headLineLabel
                } else {
                    self.currentSelectedIndex = 0
                    self.categories[self.currentSelectedIndex].isSelected = true
                    self.categoryDelegate?.didSelectCategory(self.categories[0])//load for very first category
                    self.tableView.tableFooterView = nil
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("error \(error)")
                break
            }
        }
    }
}

extension CategoriesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell {
            let category = categories[indexPath.row]
            cell.configCategory(category: category)
            cell.categoryButton.addTarget(self, action: #selector(onCategory), for: .touchUpInside)
            cell.categoryButton.isSelected = category.isSelected
            return cell
        }
        return UITableViewCell(frame: .zero)
    }

    @objc func onCategory(btn:UIButton) {
        if let cell = btn.superview?.superview?.superview as? CategoryCell,let path = tableView.indexPath(for: cell) {
            if !btn.isSelected {
                btn.isSelected = !btn.isSelected
//                categories[currentSelectedIndex].isSelected = false
                print("categories before \(categories)")
//                categories.forEach { var model in
//                    model.isSelected = false
//                }
//                categories = categories.map{$0.isSelected = false}
                var updatedCategories:[CategoryModel] = []
                for i in 0..<categories.count {
//                    if categories[i].isSelected {
                        categories[i].isSelected = false
//                    }
                    updatedCategories.append(categories[i])
                }
                categories = updatedCategories
                print("categories after \(categories)")
                categories[path.row].isSelected = true
//                tableView.reloadRows(at: [IndexPath(row: currentSelectedIndex, section: 0),path], with: .none)
                categoryDelegate?.didSelectCategory(categories[path.row])
                currentSelectedIndex = path.row
                tableView.reloadData()
            }
        }
    }
}
