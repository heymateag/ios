//
//  PaymateNavigatornBar.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 06/11/21.
//

import UIKit

enum TadNavigationBarType {
    case NavPlainBackButton
    case NavTitleWithNoBackButton
    case NavCenterTitleWithBackButton
    case NavTitleWithLeftRightButton
}

protocol PaymateNavigationBar {
    func setNavigationBarWithType(navType:TadNavigationBarType,centerTitle:String?,leftSelector:Selector?,rightSelector:Selector?) -> Any?
}

extension PaymateNavigationBar where Self:UIViewController {
    private func clearShadowImageOnNavigationbar() {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = AppUtils.COLOR_PRIMARY2()
        self.navigationController?.navigationBar.backgroundColor = AppUtils.COLOR_PRIMARY2()
    }
    
    private func hideBackButton() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
    }

    private func setOriginalBackImage(selector:Selector) {
        let backButton = UIBarButtonItem(image: UIImage(named: "back_btn")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: selector)
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @discardableResult
    private func addTitleView(title:String?) -> UILabel {
        let label = UILabel(frame: CGRect(x: 100, y: 0, width: self.view.frame.size.width-100, height: 44))
        label.text = title
        label.textColor = .white
        label.textAlignment = .left
        label.center.x = self.view.center.x
        self.navigationItem.titleView = label
        return label
    }
    
    private func setTitleViewOfpage(title:String,leftSelector:Selector) {
        setOriginalBackImage(selector: leftSelector)
        addTitleView(title: title)
    }
    
    @discardableResult
    func setNavigationBarWithType(navType:TadNavigationBarType,centerTitle:String?,leftSelector:Selector?,rightSelector:Selector?) -> Any? {
        hideBackButton()
        clearShadowImageOnNavigationbar()
        switch navType {
        case .NavCenterTitleWithBackButton:
            setTitleViewOfpage(title: centerTitle!, leftSelector: leftSelector!)
        case .NavPlainBackButton:
            setOriginalBackImage(selector: leftSelector!)
        case .NavTitleWithNoBackButton:
            addTitleView(title: centerTitle)
        case .NavTitleWithLeftRightButton:
            setTitleViewOfpage(title: centerTitle!,leftSelector: leftSelector!)
        }
        return nil
    }
}
