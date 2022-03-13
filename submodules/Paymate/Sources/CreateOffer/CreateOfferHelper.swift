//
//  CreateOfferHelper.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 11/11/21.
//

import UIKit

extension CreateOfferTableViewController {//model classes used
    struct Schedule {
        let scheduleId:String = Date.getCurrentTimestamp()
        let fromDate:Date
        let toDate:Date
    }
    
    struct PayTerm {
        var percentage:Int
        var constraintTime:Int
        var startHour = 2
        var endHour = 6
    }
    
    struct OfferImageModel {
        let index:Int
        let image:UIImage
    }
}
 

extension CreateOfferTableViewController:CategoryHomeSelectionDelegate { // Category
    func didSelectCategoryAndSubcategory(category: CategoryModel, subCategory: CategoryModel) {
        selectedCategory = category
        selectedSubCategory = subCategory
        updateCategorySelection()
    }
    
    func initializeCategoryActions(cell:COCategoryCell) {
        cell.btnCategory.addTarget(self, action: #selector(showCategories), for: .touchUpInside)
        cell.btnSubCategory.addTarget(self, action: #selector(showCategories), for: .touchUpInside)
        loadCategories()
    }
    
    @objc private func showCategories() {
        let controller = CategoryHomeViewController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        controller.categoryHomeDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    private func loadCategories() {
        CreateOfferViewModel.getCategories {[weak self] (array, error) in
            guard let weakSelf = self,error == nil,!array.isEmpty else {
                return
            }
            if let firstCategory = array.first {
                weakSelf.selectedCategory = firstCategory
                weakSelf.fetchSubCategories()
            }
        }
    }
    
    private func fetchSubCategories() {
        guard let cat = selectedCategory else { return }
        CreateOfferViewModel.getSubCategoriesForCategory(cat) {[weak self] (array, error) in
            guard let self = self,error == nil,!array.isEmpty else {return }
            self.selectedSubCategory = array.first
            self.updateCategorySelection()
        }
    }
    
    private func updateCategorySelection() {
        let path = CreateOfferTableViewController.OfferRowIndex.getCell(row: .Category)
        if let cell = tableView.cellForRow(at: path) as? COCategoryCell {
            cell.updateSelection(category: selectedCategory, subCategory: selectedSubCategory)
        }
    }
}

extension CreateOfferTableViewController:DatePickerSelectionDelegate,ScheduleCellDelegate { //schedules
    
    func initializeScheduleViews(cell:COScheduleCell) {
        cell.dDelegate = self
        cell.btnAddSchedule.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
    }
    
    func didDeleteSchedule(_ id: String) {
        offerSchedules.removeAll { (s) -> Bool in
            return s.scheduleId == id
        }
        updateScheduleCell()
    }
    
    @objc private func showDatePicker() {
        let controller = DatePickerViewController.init(nibName: "DatepickerController", bundle: Bundle.main)
        controller.modalPresentationStyle = .overCurrentContext
        controller.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        controller.dateDelegate = self
        controller.isSingleDateSelection = isExpireDatePicker
        if isExpireDatePicker {
            if !offerSchedules.isEmpty {
                offerSchedules.sort { (s1, s2) -> Bool in
                    return s1.toDate.compare(s2.toDate) == .orderedAscending
                }
                controller.mMinimumDate = offerSchedules[0].toDate
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    private func updateScheduleCell() {
        let path = OfferRowIndex.getCell(row: .Schedule)
        if let cell = tableView.cellForRow(at: path) as? COScheduleCell {
            cell.userSchedules.arrangedSubviews.forEach { (v) in
                v.removeFromSuperview()
            }
            tableView.beginUpdates()
            for(index,schedule) in offerSchedules.enumerated() {
                cell.addScheduleToView(schedule, index: index+1)
            }
            tableView.endUpdates()
        }
    }
    
    @objc private func onDeleteSchedule(sender:UIButton) {
        
    }
    
    func didSelectDateFromDatePicker(fromDate: Date?, toDate: Date?) {
        if isExpireDatePicker {
            if let date = fromDate {
                expireDate = date
            }
            updateExpireDate()
        } else {
            if let from = fromDate,let to = toDate {
                let s = Schedule(fromDate: from, toDate: to)
                offerSchedules.append(s)
                if let cell = tableView.cellForRow(at: OfferRowIndex.getCell(row: .Schedule)) as? COScheduleCell {
                    tableView.beginUpdates()
                    cell.addScheduleToView(s, index: offerSchedules.count)
                    tableView.endUpdates()
                }
                //bhar
//                if to.compare(expireDate) == .orderedAscending {
//                    expireDate = to
////                    self.showAlertWithMessage(title: "Expiratiion", message: "Expiration date has been changed to selected TO date.")
//                }
            }
        }
        isExpireDatePicker = false
    }
}

extension CreateOfferTableViewController {//participants
    func initializeParticipantsViews(cell:COParticipantsCell) {
        cell.unlimitedBtn.addTarget(self, action: #selector(onUnlimited), for: .touchUpInside)
        cell.noofUsersField.addTarget(self, action: #selector(onNoOfUsersEdit), for: .editingChanged)
    }
    
    @objc private func onUnlimited(sender:UIButton) {
        resignKeyboard()
        sender.isSelected = !sender.isSelected
        isUnlimitedParticipants = sender.isSelected
        if sender.isSelected {
            noOfParticipants = ""
        }
        if let cell = tableView.cellForRow(at: OfferRowIndex.getCell(row: .Participant)) as? COParticipantsCell {
            cell.configParticipantsSelection()
        }
    }
    
    @objc private func onNoOfUsersEdit(field:UITextField) {
        if let cell = tableView.cellForRow(at: OfferRowIndex.getCell(row: .Participant)) as? COParticipantsCell {
            cell.unlimitedBtn.isSelected = false
            isUnlimitedParticipants = false
            cell.configParticipantsSelection()
            noOfParticipants = field.text ?? ""
        }
    }
}

extension CreateOfferTableViewController { //price
    func initializePriceView(cell:COPricingCell) {
        cell.bundleCheckbox.addTarget(self, action: #selector(onBundle), for: .touchUpInside)
        cell.subscriptionCheckbox.addTarget(self, action: #selector(onSubscription), for: .touchUpInside)
        cell.fixPriceField.addTarget(self, action: #selector(onFixedPrice), for: .editingChanged)
        cell.bundleSessionsField.addTarget(self, action: #selector(onBundleSessions), for: .editingChanged)
        cell.bundleDiscField.addTarget(self, action: #selector(onBundleDiscount), for: .editingChanged)
        cell.subscField.addTarget(self, action: #selector(onSubscriptionPrice), for: .editingChanged)
        cell.currencyTypeBtn.addTarget(self, action: #selector(onCurrencyTypeSelection), for: .touchUpInside)
        
        cell.bundleSessionsField.isEnabled = cell.bundleCheckbox.isSelected
        cell.bundleDiscField.isEnabled = cell.bundleCheckbox.isSelected
        
        cell.subscField.isEnabled = cell.subscriptionCheckbox.isSelected
        
        cell.bundleCheckbox.changeCheckBoxSelectedState()
        cell.subscriptionCheckbox.changeCheckBoxSelectedState()
        
    }
    
    func resetPricingViews(cell:COPricingCell) {
        cell.bundleSessionsField.isEnabled = cell.bundleCheckbox.isSelected
        cell.bundleDiscField.isEnabled = cell.bundleCheckbox.isSelected
        cell.subscField.isEnabled = cell.subscriptionCheckbox.isSelected
    }
    
    @objc private func onBundle(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        isBundleSelected = sender.isSelected
        sender.changeCheckBoxSelectedState()
        if let cell = sender.superview?.superview?.superview?.superview?.superview?.superview?.superview as? COPricingCell {
            cell.bundleDiscField.isEnabled = sender.isSelected
            cell.bundleSessionsField.isEnabled = sender.isSelected
        }
    }
    @objc private func onSubscription(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        isSubscriptionSelected = sender.isSelected
        sender.changeCheckBoxSelectedState()
        if let cell = sender.superview?.superview?.superview?.superview?.superview?.superview?.superview as? COPricingCell {
            cell.subscField.isEnabled = sender.isSelected
        }
    }
    
    @objc private func onBundleSessions(field:UITextField) {
        bundleSessions = field.text ?? ""
    }
    
    @objc private func onBundleDiscount(field:UITextField) {
        bundleDiscount = field.text ?? ""
    }
    
    @objc private func onFixedPrice(field:UITextField) {
        fixedPrice = field.text ?? ""
    }
    
    @objc private func onSubscriptionPrice(field:UITextField) {
        subscriptionPricePerMonth = field.text ?? ""
    }
    
    func refreshCurrencyType(cell:COPricingCell) {
        cell.currencyTypeBtn.setTitle(mCurrencyType.getDisplayCurrencyDetails().currencySymbol, for: .normal)
    }
    
    @objc private func onCurrencyTypeSelection(btn:UIButton) {
        let eur = OptionsDatasource(optionDisplayValue: CurrencyType.EUR.rawValue, optionModel: nil,leftImage:nil)
        let cUsd = OptionsDatasource(optionDisplayValue: CurrencyType.USD.rawValue, optionModel: nil,leftImage:nil)
//        let real = OptionsDatasource(optionDisplayValue: CurrencyType.REAL.rawValue, optionModel: nil)
        
        self.showPopupOptionsWithOptions([cUsd,eur], onView: btn)
    }
}

extension CreateOfferTableViewController:PercentageINputDelegate { //pay terms
    
    func didSelectApplyWithInputValue(_ value: Int) {
        if let cell = tableView.cellForRow(at: OfferRowIndex.getCell(row: .PaymentTerms)) as? COPaymentTermsCell {
            switch currentInputSelection {
                case .DelayInStartMins:
                    payTermDelayStartMins.constraintTime = value
                    cell.configDelayInStart(term: payTermDelayStartMins)
                case .DelayInStartPercentage:
                    payTermDelayStartMins.percentage = value
                    cell.configDelayInStart(term: payTermDelayStartMins)
                case .DepositPercentage:
                    payTermDeposit.percentage = value
                    cell.configDeposit(term: payTermDeposit)
                case .CancellationHours:
                    payTermCancelHrs.constraintTime = value
                    cell.configCancellationHours(term: payTermCancelHrs)
                case .CancellationHrsPercentage:
                    payTermCancelHrs.percentage = value
                    cell.configCancellationHours(term: payTermCancelHrs)
                case .CancellationStartHrs:
                    payTermCancelRange.startHour = value
                    cell.configCancelRange(term: payTermCancelRange)
                case .CancellationEndHrs:
                    payTermCancelRange.endHour = value
                    cell.configCancelRange(term: payTermCancelRange)
                case .CancellationRangePercentage:
                    payTermCancelRange.percentage = value
                    cell.configCancelRange(term: payTermCancelRange)
            }
        }
//        tableView.reloadRows(at: [OfferRowIndex.getCell(row: .PaymentTerms)], with: .none)
    }
    
    func initializePayterms(cell:COPaymentTermsCell) {
        cell.delayInStartMins.addTarget(self, action: #selector(onDelayStartMins), for: .touchUpInside)
        cell.delayStartPercentage.addTarget(self, action: #selector(onDelayStartPercentage), for: .touchUpInside)
        
        cell.depositPercentage.addTarget(self, action: #selector(onDepositPercentage), for: .touchUpInside)
        
        cell.cancellationHrsStart.addTarget(self, action: #selector(onCancelHoursStart), for: .touchUpInside)
        cell.cancellationHrsStartPercentage.addTarget(self, action: #selector(onCancelHourPercentage), for: .touchUpInside)
        
        cell.cancelHrStart.addTarget(self, action: #selector(onCancelHoursStartRange), for: .touchUpInside)
        cell.cancelHrEnd.addTarget(self, action: #selector(onCancelHoursEndRange), for: .touchUpInside)
        cell.cancelRangePercentage.addTarget(self, action: #selector(onCancelHoursRangePercentage), for: .touchUpInside)
        
        cell.configDelayInStart(term: payTermDelayStartMins)
        cell.configDeposit(term: payTermDeposit)
        cell.configCancellationHours(term: payTermCancelHrs)
        cell.configCancelRange(term: payTermCancelRange)
    }
    
    @objc private func onDelayStartMins() {
        currentInputSelection = .DelayInStartMins
//        showInputWith(title: "Delay in start by Mins", currentValue: payTermDelayStartMins.constraintTime,unitsToDisplay:"Mins")
        showInputWith(title: "Delay in start", currentValue: payTermDelayStartMins.constraintTime,unitsToDisplay:"Mins")
    }
    @objc private func onDelayStartPercentage() {
        currentInputSelection = .DelayInStartPercentage
//        showInputWith(title: "Delay in start > \(payTermDelayStartMins.constraintTime) mins", currentValue: payTermDelayStartMins.percentage,unitsToDisplay:"%")
        showInputWith(title: "Delay in start", currentValue: payTermDelayStartMins.percentage,unitsToDisplay:"%")
    }
    @objc private func onDepositPercentage() {
        currentInputSelection = .DepositPercentage
        showInputWith(title: "Deposit", currentValue: payTermDeposit.percentage,unitsToDisplay:"%")
    }
    @objc private func onCancelHourPercentage() {
        currentInputSelection = .CancellationHrsPercentage
//        showInputWith(title: "Cancellation in > \(payTermCancelHrs.constraintTime) hrs of start", currentValue: payTermCancelHrs.percentage,unitsToDisplay:"%")
        showInputWith(title: "Cancellation", currentValue: payTermCancelHrs.percentage,unitsToDisplay:"%")
    }
    @objc private func onCancelHoursStart() {
        currentInputSelection = .CancellationHours
//        showInputWith(title: "Cancellation in hrs of start", currentValue: payTermCancelHrs.constraintTime,unitsToDisplay:"hrs")
        showInputWith(title: "Cancellation", currentValue: payTermCancelHrs.constraintTime,unitsToDisplay:"hrs")
    }
    @objc private func onCancelHoursStartRange() {
        currentInputSelection = .CancellationStartHrs
//        showInputWith(title: "Cancellation in hrs of start", currentValue: payTermCancelRange.startHour,unitsToDisplay:"hrs")
        showInputWith(title: "Cancellation", currentValue: payTermCancelRange.startHour,unitsToDisplay:"hrs")
    }
    @objc private func onCancelHoursEndRange() {
        currentInputSelection = .CancellationEndHrs
//        showInputWith(title: "Cancellation in hrs of start", currentValue: payTermCancelRange.endHour,unitsToDisplay:"hrs")
        showInputWith(title: "Cancellation", currentValue: payTermCancelRange.endHour,unitsToDisplay:"hrs")
    }
    @objc private func onCancelHoursRangePercentage() {
        currentInputSelection = .CancellationRangePercentage
//        showInputWith(title: "Cancellation in \(payTermCancelRange.startHour) - \(payTermCancelRange.endHour) hrs of start", currentValue: payTermCancelRange.percentage,unitsToDisplay:"%")
        showInputWith(title: "Cancellation", currentValue: payTermCancelRange.percentage,unitsToDisplay:"%")
    }
    
    private func showInputWith(title:String,currentValue:Int,unitsToDisplay:String) {
        let controller = PercentageInputController.init(nibName: "PercentageInputView", bundle: Bundle.main)
        controller.modalPresentationStyle = .overCurrentContext
        controller.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        controller.iDelegate = self
        controller.pageTitle = title
        controller.units = unitsToDisplay
        controller.currentValue = currentValue
        self.present(controller, animated: true, completion: nil)
    }
}

extension CreateOfferTableViewController:TnCControllerDelegate {//terms
    func didDismissTnCWithContent(_ content: String) {
        termsAndConditions = content
        if let cell = tableView.cellForRow(at: OfferRowIndex.getCell(row: .TnC)) as? COTermsCell {
            tableView.beginUpdates()
            cell.configTerms(termsAndConditions)
            tableView.endUpdates()
        }
    }
    
    func initializeTerms(cell:COTermsCell) {
        cell.configTerms(termsAndConditions)
    }
    
    func showTermsController() {
        let controller = TnCViewController.init(nibName: "OfferTncView", bundle: Bundle.main)
        controller.modalPresentationStyle = .overCurrentContext
        controller.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        controller.tncDelegate = self
        controller.currentTerms = termsAndConditions
        self.present(controller, animated: true, completion: nil)
    }
}

extension CreateOfferTableViewController {//location
    func initializeLocation(cell:COLocationCell) {
        cell.isOnlinecheckbox.isSelected = isOnlineMeeting
        cell.isOnlinecheckbox.addTarget(self, action: #selector(onOnlineCheckbox), for: .touchUpInside)
        cell.isOnlinecheckbox.changeCheckBoxSelectedState()
    }
    
    @objc private func onOnlineCheckbox(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        isOnlineMeeting = sender.isSelected
        sender.changeCheckBoxSelectedState()
    }
}

extension CreateOfferTableViewController { //expiration
    func initializeExpiration(cell:COExpirationCell) {
        cell.btnExpiry.addTarget(self, action: #selector(onExpire), for: .touchUpInside)
        updateExpireDate()
    }
    
    func updateExpireDate() {
        print("expire date \(Date.getScheduleDisplayFormat(date: expireDate))")
        if let cell = tableView.cellForRow(at: OfferRowIndex.getCell(row: .Expiration)) as? COExpirationCell {
            cell.btnExpiry.setTitle(Date.getScheduleDisplayFormat(date: expireDate), for: .normal)
        }
    }
    
    @objc private func onExpire() {
        isExpireDatePicker = true
        showDatePicker()
    }
}

extension CreateOfferTableViewController:OffersImageDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func didDeleteImage(_ image: CreateOfferTableViewController.OfferImageModel) {
        offerImages.removeAll { (oI) -> Bool in
            return oI.index == image.index
        }
    }    
    
    func initializeOfferImages(cell:OffersImagesCell) {
        cell.mListener = self
    }
    
    func didSelectAddImage() {
        showPickerAlert()
    }
    
    private func showPickerAlert() {
        
        let alert  = UIAlertController.init(title: "Choose option", message: "", preferredStyle: .actionSheet)
        let gallery = UIAlertAction(title: "Gallery", style: .default) {[weak self] (_) in
            self?.openGallery()
        }
        let camera = UIAlertAction(title: "Camera", style: .default) {[weak self] (_) in
            self?.openCamera()
        }
        let destructive = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            
        }
        alert.addAction(gallery)
        alert.addAction(camera)
        alert.addAction(destructive)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController.init(title: "Offer settings", message: "Camera is unavailable in your device.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .destructive) { (_) in
                
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("didFinishPickingMediaWithInfo")
        picker.dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            if let pickedImage = info[.originalImage] as? UIImage {
                self.offerImages.append(OfferImageModel(index: self.offerImages.count, image: pickedImage))
                self.updateCollectionView()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func updateCollectionView() {
        if let cell = tableView.cellForRow(at: IndexPath(row: OfferImageSectionRows.Images.rawValue, section: OfferSections.Images.rawValue)) as? OffersImagesCell {
            cell.reloadCollectionWithImages(offerImages)
        }
    }
}
