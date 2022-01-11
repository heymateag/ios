//
//  SettingsExpirationView.swift
//  TelegramSample
//
//  Created by Heymate on 25/09/21.
//

import UIKit
import Combine

class SettingsExpirationView: UIView {

    var embedController:UIViewController?
    private var model:ExpirationModel = ExpirationModel(expireDate: Date())
//    var viewModelChanges = PassthroughSubject<ExpirationModel,Never>()
    var modelChanges:((ExpirationModel) -> Void)?
    
    private lazy var expireStackView:UIStackView = {
        let _stackView = UIStackView()
        _stackView.axis = .horizontal
        _stackView.distribution = .fill
        _stackView.translatesAutoresizingMaskIntoConstraints = false
        _stackView.spacing = 8
        _stackView.alignment = .leading
        return _stackView
    }()
    
    private lazy var expireDateBtn:UIButton = {
        let _btn = UIButton(type: .custom)
        _btn.setTitleColor(AppUtils.COLOR_BLUE(), for: .normal)
        _btn.contentHorizontalAlignment = .left
        return _btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(expireStackView)
        let bottomConstraint = expireStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        bottomConstraint.priority = .defaultHigh
        let stackConstraints = [
            expireStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 32),
            expireStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 0),
            bottomConstraint,
            expireStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(stackConstraints)

        expireDateBtn.setTitle(AppUtils.getExpireDateView(model.expireDate), for: .normal)
        expireDateBtn.addTarget(self, action: #selector(showExpireDateSelection), for: .touchUpInside)
        expireStackView.addArrangedSubview(expireDateBtn)
//        viewModelChanges.send(model)
        modelChanges?(model)
    }
    
    @objc func showExpireDateSelection() {
        let controller = DatePickerViewController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        controller.dateDelegate = self
        embedController?.present(controller, animated: true, completion: nil)
    }

}

//extension SettingsExpirationView:DatePickerSelectionDelegate {
//    func didSelectDateFromDatePicker(_ date: Date) {
//        expireDateBtn.setTitle(AppUtils.getExpireDateView(date), for: .normal)
//        model.expireDate = date
////        viewModelChanges.send(model)
//        modelChanges?(model)
//    }
//}
// 
