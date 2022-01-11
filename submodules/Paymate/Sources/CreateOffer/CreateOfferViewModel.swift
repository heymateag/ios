//
//  CreateOfferViewModel.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 11/11/21.
//

import Foundation

struct CreateOfferViewModel {
    
    static func getCategories(onCompletion:@escaping(_ categories:[CategoryModel],_ error:PeyError?) -> Void) {
        PeyServiceController.shared.getCategories(request: EmptyRequest()) { (result, _) in
            switch result {
            case .success(let response):
                let categories = response.data.map({ (category) -> CategoryModel in
                    return CategoryModel(name: category, isSelected: false)
                })
                onCompletion(categories,nil)
            case .failure(let error):
                print("error \(error)")
                onCompletion([],error)
                break
            }
        }
    }
    
    static func getSubCategoriesForCategory(_ category:CategoryModel,onCompletion:@escaping(_ categories:[CategoryModel],_ error:PeyError?) -> Void) {
        PeyServiceController.shared.getSubCategories(request: SubCategoryRequest(category: category.name)) {(result, _) in
            switch result {
            case .success(let response):
                let subCategories = response.data.map({ (subCat) -> CategoryModel in
                    return CategoryModel(name: subCat, isSelected: false)
                })
                onCompletion(subCategories,nil)
            case .failure(let error):
                print("error sub cat \(error)")
                onCompletion([],error)
            }
        }
    }
    
}
