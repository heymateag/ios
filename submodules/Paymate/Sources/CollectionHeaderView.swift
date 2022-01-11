//
//  CollectionHeaderCollectionReusableView.swift
//  TelegramSample
//
//  Created by Heymate on 29/08/21.
//

import UIKit

//class CollectionHeaderView: UICollectionReusableView {
class CollectionHeaderView: UICollectionViewCell {
    private lazy var addImage :UIImageView = {
        let  _image = UIImageView()
        _image.image = UIImage(named: "add_image")
        _image.contentMode = .scaleAspectFit
        return _image
    }()
    
    private lazy var addTitle:UILabel = {
        let _label = UILabel()
        _label.textColor = UIColor(red: 41/255, green: 169/255, blue: 235/255, alpha: 1.0)
        _label.text = "Add Media"
        _label.font = UIFont.systemFont(ofSize: 11)
        _label.textAlignment = .center
        return _label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addLineDashedStroke(pattern: [2,2], radius: 8, color: UIColor(red: 95/255, green: 150/255, blue: 188/255, alpha: 1.0).cgColor)
        self.addSubview(addImage)
        self.addSubview(addTitle)
        addImage.translatesAutoresizingMaskIntoConstraints = false
        addTitle.translatesAutoresizingMaskIntoConstraints = false
        let addImageConstraints = [addImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -16),
                          addImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                          addImage.widthAnchor.constraint(equalToConstant: 19),
                          addImage.heightAnchor.constraint(equalToConstant: 19)
            ]
        NSLayoutConstraint.activate(addImageConstraints)

        let addTitleConstraints = [addTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                   addTitle.topAnchor.constraint(equalTo: addImage.bottomAnchor, constant: 8)]
        NSLayoutConstraint.activate(addTitleConstraints)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
}
