//
//  CategoryCell.swift
//  TelegramSample
//
//  Created by Heymate on 25/09/21.
//

import UIKit

class CategoryCell: UITableViewCell {

    lazy var categoryButton:UIButton = {
        let _button = UIButton(type: .roundedRect)
        _button.setBackGroundColor(color: AppUtils.COLOR_BLUE(), state: .normal)
        _button.setBackGroundColor(color: AppUtils.COLOR_GREEN5(), state: .selected)
        _button.isSelected = false
        _button.clipsToBounds = true
        _button.layer.cornerRadius = 8
        _button.titleLabel?.lineBreakMode = .byWordWrapping
        _button.titleLabel?.numberOfLines = 0
        _button.setTitleColor(UIColor.white, for: .normal)
        _button.translatesAutoresizingMaskIntoConstraints = false
        _button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return _button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        let stackView = UIStackView(arrangedSubviews: [categoryButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .center
        contentView.addSubview(stackView)
        let constraints:[NSLayoutConstraint] = [
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:0),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ]
        NSLayoutConstraint.activate(constraints)
        self.contentView.addSubview(stackView)
    }
    
    func configCategory(category:CategoryModel) {
        categoryButton.setTitle(category.name, for: .normal)
        categoryButton.isSelected = category.isSelected
    }
}
