//
//  CollectionImageCell.swift
//  TelegramSample
//
//  Created by Heymate on 29/08/21.
//

import UIKit

class CollectionImageCell: UICollectionViewCell {
    
    private lazy var parentView:UIView = {
       let _view = UIView()
        _view.backgroundColor = .clear
        _view.layer.cornerRadius = 8
        return _view
    }()
    
    private lazy var image:UIImageView = {
       let _imv = UIImageView()
        _imv.image = UIImage(named: "gridImage")
        _imv.contentMode = .scaleAspectFit
        return _imv
    }()
    
    lazy var crossButton:UIButton = {
        let _btn = UIButton(type: .custom)
        _btn.setImage(UIImage(named: "close"), for: .normal)
        _btn.setTitle("", for: .normal)
        return _btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(parentView)
        parentView.translatesAutoresizingMaskIntoConstraints = false
        let parentConstraints = [parentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
                                 parentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
                                 parentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                                 parentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(parentConstraints)
        parentView.addSubview(image)
        parentView.addSubview(crossButton)
        image.translatesAutoresizingMaskIntoConstraints = false
        crossButton.translatesAutoresizingMaskIntoConstraints = false
        let imageConstraints = [
            image.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: 0),
            image.centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: 0),
            image.widthAnchor.constraint(equalToConstant: 100),
            image.heightAnchor.constraint(equalToConstant: 100)            
        ]
        NSLayoutConstraint.activate(imageConstraints)
        
        let crossConstraints = [
            crossButton.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 4),
            crossButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -4),
            crossButton.widthAnchor.constraint(equalToConstant: 24),
            crossButton.heightAnchor.constraint(equalToConstant: 24)
        ]
        NSLayoutConstraint.activate(crossConstraints)
        
    }
    
    func configureCellWithImage(_ im:UIImage) {
        image.image = im
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
}
