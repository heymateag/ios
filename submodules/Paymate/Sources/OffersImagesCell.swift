//
//  OffersImagesCell.swift
//  TelegramSample
//
//  Created by Heymate on 29/08/21.
//

import UIKit

protocol OffersImageDelegate {
    func didSelectAddImage()
    func didDeleteImage(_ image:CreateOfferTableViewController.OfferImageModel)
}

class OffersImagesCell: UITableViewCell {

    var mListener:OffersImageDelegate?
    private var mImages:[CreateOfferTableViewController.OfferImageModel] = []
    
    private lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        layout.itemSize = CGSize(width: 100, height: 100)
//        layout.headerReferenceSize = CGSize(width: 100, height: 100)
//        layout.sectionHeadersPinToVisibleBounds = true
        let _collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        _collection.showsHorizontalScrollIndicator = false
        _collection.backgroundColor = .clear
        return _collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let collectionConstraints = [collectionView.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 8),
                                    collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                                    collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                                    collectionView.heightAnchor.constraint(equalToConstant: 140)]
        NSLayoutConstraint.activate(collectionConstraints)
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.register(CollectionImageCell.self, forCellWithReuseIdentifier: "CollectionImageCell")
        collectionView.register(CollectionHeaderView.self, forCellWithReuseIdentifier: "CollectionHeaderView")
//        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


extension OffersImagesCell:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func reloadCollectionWithImages(_ images:[CreateOfferTableViewController.OfferImageModel]) {
        mImages = images
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(row: mImages.count-1, section: 0), at: .right, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mImages.count+1//+1 for add image btn
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0,let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionHeaderView", for: indexPath) as? CollectionHeaderView { //add media
            return cell
        } else if let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionImageCell", for: indexPath) as? CollectionImageCell {
            imageCell.configureCellWithImage(mImages[indexPath.row-1].image)
            imageCell.crossButton.addTarget(self, action: #selector(didDeleteImage), for: .touchUpInside)
            return imageCell
        }
        return UICollectionViewCell(frame: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            mListener?.didSelectAddImage()
        }
    }
    
    @objc func didDeleteImage(btn:UIButton) {
        if let cell = btn.superview?.superview?.superview as? CollectionImageCell,let path = collectionView.indexPath(for: cell) {
            mListener?.didDeleteImage(mImages[path.row-1])
            mImages.remove(at: path.row-1)
            collectionView.deleteItems(at: [path])
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//            case UICollectionView.elementKindSectionHeader:
//                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
//                headerView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//                return headerView
//            default:
//                break
//        }
//        fatalError("no reusable view supplied")
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        print("insetForSectionAt")
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
//    }

}
