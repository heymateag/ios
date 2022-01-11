//
//  OffersInputCell.swift
//  TelegramSample
//
//  Created by Heymate on 28/08/21.
//

import UIKit

class OffersInputCell: UITableViewCell {

    private lazy var parentView:UIView = {
       let _view = UIView()
        _view.backgroundColor = .clear
        return _view
    }()
    
    lazy var inputField:UITextField = {
        let _field = UITextField()
        _field.placeholder = "Text"
        _field.borderStyle = .none
        return _field
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        parentView.translatesAutoresizingMaskIntoConstraints = false
        inputField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(parentView)
        parentView.addSubview(inputField)
        let parentConstraints = [
            parentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            parentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-16),
            parentView.heightAnchor.constraint(equalToConstant: 44),
            parentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)
        ]
        
        let fieldConstraints = [
            inputField.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 0),
            inputField.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: 0),
            inputField.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant:0),
            inputField.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 0)
        ]
        inputField.rightView = nil
        parentView.addBottomBorderWithColor(color: UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1), width: 1,xValue: 0)
        NSLayoutConstraint.activate(parentConstraints)
        NSLayoutConstraint.activate(fieldConstraints)
    }
    
    func showRightCounterLabel() {
        let rightView = UILabel()
        rightView.text = "500"
        rightView.textColor = UIColor.lightGray
        inputField.rightView = rightView
        inputField.rightViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
