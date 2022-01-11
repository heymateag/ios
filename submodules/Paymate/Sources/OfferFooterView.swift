//
//  OfferFooterView.swift
//  TelegramSample
//
//  Created by Heymate on 20/09/21.
//

import UIKit

class OfferFooterView: UIView {

    private lazy var buttonsStack:UIStackView = {
        let _stack = UIStackView()
        _stack.axis = .horizontal
        _stack.distribution = .fillEqually
//        _stack.alignment = .center
        _stack.spacing = 16
        return _stack
    }()
    
    var saveButton:UIButton?
    var promoteButton:UIButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonsStack)
        let heightAnchor = buttonsStack.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -32)
        heightAnchor.priority = .defaultHigh
        let stackConstraints = [
            buttonsStack.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 32),
            buttonsStack.heightAnchor.constraint(equalToConstant: 44),
            buttonsStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            heightAnchor
        ]
        NSLayoutConstraint.activate(stackConstraints)
        
        let btnSave = UIButton(type: .custom)
        btnSave.setTitle("Save", for: .normal)
        btnSave.setForCorneredBlueButton()
//        btnSave.heightAnchor.constraint(equalToConstant: 44).isActive = true
        btnSave.translatesAutoresizingMaskIntoConstraints = false
        saveButton = btnSave
        
        let btnPromote = UIButton(type: .custom)
        btnPromote.setTitle("Promote", for: .normal)
        btnPromote.setForCorneredBlueButton()
//        btnPromote.heightAnchor.constraint(equalToConstant: 44).isActive = true
        btnPromote.translatesAutoresizingMaskIntoConstraints = false
        promoteButton = btnPromote
        
        buttonsStack.addArrangedSubview(btnSave)
        buttonsStack.addArrangedSubview(btnPromote)
    }
    
    
}
