////
////  CreateOfferViewController.swift
////  _idx_Paymate_4CB4E97A_ios_min9.0
////
////  Created by Heymate on 01/11/21.
////
//
//import UIKit
//
//struct OfferImageModel {
//    let index:Int
//    let image:UIImage
//}
//
//class CreateOfferViewController: UIViewController {
//
//    struct RowItem {
//        let imageName:String
//        let title:String
//    }
//
//    private enum OfferSections:Int,CaseIterable {
//        case Offers = 0,OfferSettings
//    }
//
//    private enum OffersRows:Int {
//        case Images = 0
//        case Title
//        case Description
//    }
//
//    private lazy var offerTableView:UITableView = {
//       let _tv = UITableView()
//        _tv.separatorStyle = .none
////        _tv.alwaysBounceVertical = false
//        _tv.allowsSelection = true
//        _tv.allowsSelection = true
//        _tv.estimatedRowHeight = UITableView.automaticDimension
//        _tv.rowHeight = UITableView.automaticDimension
//       return _tv
//    }()
//
//    private var offerImages:[OfferImageModel] = []
//    private let offerSettings:[RowItem] = [
//        RowItem(imageName: "category", title: "Category"),
//        RowItem(imageName: "location", title: "Location"),
//        RowItem(imageName: "participant", title: "Participant"),
//        RowItem(imageName: "calendar", title: "Schedule"),
//        RowItem(imageName: "pricing", title: "Pricing"),
//        RowItem(imageName: "payment_terms", title: "Payment Terms"),
//        RowItem(imageName: "expiration", title: "Expiration"),
//        RowItem(imageName: "terms", title: "Terms and Conditions")
//    ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        addViews()
//        addFooterView()
//        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
//    }
//}
//
//extension CreateOfferViewController {
//    private func addViews() {
//        let safeMargins = self.view.layoutMarginsGuide
//        self.view.addSubview(offerTableView)
//        offerTableView.backgroundColor = .clear
//        offerTableView.translatesAutoresizingMaskIntoConstraints = false
//        let tvConstraints = [offerTableView.topAnchor.constraint(equalTo: safeMargins.topAnchor, constant: 0),
//                             offerTableView.bottomAnchor.constraint(equalTo: safeMargins.bottomAnchor, constant: 0),
//                             offerTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
//                             offerTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
//        ]
//        offerTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
//        NSLayoutConstraint.activate(tvConstraints)
//        offerTableView.register(OffersImagesCell.self, forCellReuseIdentifier: "OffersImagesCell")
//        offerTableView.register(OffersInputCell.self, forCellReuseIdentifier: "OffersInputCell")
//        offerTableView.register(OfferSettingsCell.self, forCellReuseIdentifier: "OfferSettingsCell")
//        offerTableView.tableFooterView = nil
//        offerTableView.delegate = self
//        offerTableView.dataSource = self
//        offerTableView.reloadData()
//    }
//}
//
//extension CreateOfferViewController:UITableViewDelegate,UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return OfferSections.allCases.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (section == OfferSections.Offers.rawValue) ? 3 : offerSettings.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == OfferSections.Offers.rawValue {
//            if indexPath.row == OffersRows.Images.rawValue,let cell = tableView.dequeueReusableCell(withIdentifier: "OffersImagesCell") as? OffersImagesCell {
//                cell.mListener = self
//                return cell
//            } else if let cell = tableView.dequeueReusableCell(withIdentifier: "OffersInputCell") as? OffersInputCell {
//                if indexPath.row == 1 {
//                    cell.showRightCounterLabel()
//                }
//                return cell
//            }
//        } else if indexPath.section == OfferSections.OfferSettings.rawValue {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "OfferSettingsCell") as? OfferSettingsCell {
//                cell.configureFor(item: offerSettings[indexPath.row],category: OfferSettingCategory(rawValue: indexPath.row)!,controller: self)
////                cell.embeddedController = self
//
//                observeParticipantChanges(cell: cell)
//                observeScheduleChanges(cell: cell)
//                observerPriceChanges(cell: cell)
//                observerCategorySelection(cell: cell)
//                observeLocationChanges(cell: cell)
//                observePaymentTermChanges(cell: cell)
//                observerOfferExpireChanges(cell: cell)
//
//                return cell
//            }
//        }
//        return UITableViewCell(frame: .zero)
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
//        v.backgroundColor = .white
//        let _label = UILabel(frame: CGRect(x: 16, y: 8, width: v.frame.size.width, height: v.frame.size.height))
//        _label.backgroundColor = .white
//         _label.textColor = UIColor(red: 0.161, green: 0.663, blue: 0.922, alpha: 1)
//        _label.font = UIFont.boldSystemFont(ofSize: 14.0)
//        _label.numberOfLines = 0
//        _label.lineBreakMode = .byWordWrapping
//        if section == OfferSections.Offers.rawValue {
//            _label.text = "Offer Details"
//        } else {
//            _label.text = "Offer Settings"
//        }
//        v.addSubview(_label)
//        return v
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == OfferSections.Offers.rawValue {
//            return 16
//        }
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if section == OfferSections.Offers.rawValue {
//            let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 16))
//            v.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
//            return v
//        }
////        else {
////            let footer = OfferFooterView()
////            footer.saveButton?.addTarget(self, action: #selector(onSaveOffer), for: .touchUpInside)
////            return footer
////        }
//        return nil
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == OfferSections.OfferSettings.rawValue {
//            return UITableView.automaticDimension
//        }
//        if indexPath.row == OffersRows.Images.rawValue { return 140 }
//        return 60
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == OfferSettingCategory.TandC.rawValue {
//            showTermsConditions()
//        } else {
//            UIView.animate(withDuration: 0.3) {
//                if #available(iOS 11.0, *) {
//                    tableView.performBatchUpdates(nil)
//                } else {
//
//                }
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) as? OfferSettingsCell {
//            cell.hideDetailView()
//        }
//    }
//
//    private func showTermsConditions() {
//        let controller = TnCViewController()
//        controller.modalPresentationStyle = .overCurrentContext
//        controller.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        self.present(controller, animated: true, completion: nil)
//    }
//}
//
//extension CreateOfferViewController:TnCControllerDelegate {
//    private func observeParticipantChanges(cell:OfferSettingsCell) {
//        cell.participantView.modelChanges = { model in
//            print("participantView received \(model.noOfUsers) \(model.allUsers)")
//        }
//
////        cell.participantView.viewModelChanges.sink(receiveValue: { (model) in
////            print("received \(model.noOfUsers) \(model.allUsers)")
////        }).store(in: &anyObservers)
//    }
//
//    private func observeScheduleChanges(cell:OfferSettingsCell) {
//        cell.scheduleView.modelChanges = { schedules in
//            print("schedules \(schedules)")
//        }
////        cell.scheduleView.viewModelChanges.sink { (schedules) in
////            print("schedules \(schedules)")
////        }.store(in: &anyObservers)
//    }
//
//    private func observerPriceChanges(cell:OfferSettingsCell) {
//
//        cell.priceView.modelChanges = { model in
//            print("price model \(model)")
//        }
////        cell.priceView.viewModelChanges.sink { (priceModel) in
////            print("price model \(priceModel)")
////        }.store(in: &anyObservers)
//    }
//
//    private func observePaymentTermChanges(cell:OfferSettingsCell) {
//        cell.paymentTerms.promiseChanges = { model in
//            print("promise model \(model)")
//        }
//
//        cell.paymentTerms.cancellationChanges = { models in
//            print("cancellation models \(models)")
//        }
////        cell.paymentTerms.promiseObserver.sink { (model) in
////            print("promise model \(model)")
////        }.store(in: &anyObservers)
////
////        cell.paymentTerms.cancellationObserver.sink { (models) in
////            print("cancellation models \(models)")
////        }.store(in: &anyObservers)
//    }
//
//    private func observerCategorySelection(cell:OfferSettingsCell) {
//        cell.categoryView.modelChanges = { model in
//            print("category selections \(model)")
//        }
//
////        cell.categoryView.viewModelChanges.sink { (model) in
////            print("category selections \(model)")
////        }.store(in: &anyObservers)
//    }
//
//    private func observeLocationChanges(cell:OfferSettingsCell) {
//        cell.locationView.modelChanges = { model in
//            print("closure location \(model)")
//        }
//
////        cell.locationView.viewModelChanges.sink { (model) in
////            print("location model \(model)")
////        }.store(in: &anyObservers)
//    }
//
//    private func observerOfferExpireChanges(cell:OfferSettingsCell) {
//        cell.expirationView.modelChanges = { model in
//            print("expiration model \(model)")
//        }
////        cell.expirationView.viewModelChanges.sink { (model) in
////            print("expiration model \(model)")
////        }.store(in: &anyObservers)
//    }
//
//    func didDismissTnCWithContent(_ content: String) {
//        print("terms conditions \(content)")
//    }
//}
//
//extension CreateOfferViewController:OffersImageDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
//    func didSelectAddImage() {
//        showPickerAlert()
//    }
//
//    func didDeleteImage(_ image: OfferImageModel) {
//        offerImages.removeAll { (oI) -> Bool in
//            return oI.index == image.index
//        }
//    }
//
//    private func showPickerAlert() {
//
//        let alert  = UIAlertController.init(title: "Choose option", message: "", preferredStyle: .actionSheet)
//        let gallery = UIAlertAction(title: "Gallery", style: .default) {[weak self] (_) in
//            self?.openGallery()
//        }
//        let camera = UIAlertAction(title: "Camera", style: .default) {[weak self] (_) in
//            self?.openCamera()
//        }
//        let destructive = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
//
//        }
//        alert.addAction(gallery)
//        alert.addAction(camera)
//        alert.addAction(destructive)
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func openGallery() {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
//            imagePicker.allowsEditing = true
//            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//    }
//
//    func openCamera() {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
//            imagePicker.sourceType = UIImagePickerController.SourceType.camera
//            imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//        } else {
//            let alert  = UIAlertController.init(title: "Offer settings", message: "Camera is unavailable in your device.", preferredStyle: .alert)
//            let ok = UIAlertAction(title: "OK", style: .destructive) { (_) in
//
//            }
//            alert.addAction(ok)
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print("didFinishPickingMediaWithInfo")
//        picker.dismiss(animated: true, completion: nil)
//        DispatchQueue.main.async {[weak self] in
//            guard let self = self else { return }
//            if let pickedImage = info[.originalImage] as? UIImage {
//                self.offerImages.append(OfferImageModel(index: self.offerImages.count, image: pickedImage))
//                self.updateCollectionView()
//            }
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        print("imagePickerControllerDidCancel")
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    private func updateCollectionView() {
//        if let cell = offerTableView.cellForRow(at: IndexPath(row: OffersRows.Images.rawValue, section: OfferSections.Offers.rawValue)) as? OffersImagesCell {
//            cell.reloadCollectionWithImages(offerImages)
//        }
//    }
//
//    private func addFooterView() {
//        let footer = OfferFooterView()
//        footer.saveButton?.addTarget(self, action: #selector(onSaveOffer), for: .touchUpInside)
//        offerTableView.tableFooterView = footer
//    }
//
//    @objc func onSaveOffer() {
//        print("onSaveOffer")
//    }
//
//}
//
