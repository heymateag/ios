//
//  DatePickerViewController.swift
//  TelegramSample
//
//  Created by Heymate on 24/09/21.
//

import UIKit

protocol DatePickerSelectionDelegate {
    func didSelectDateFromDatePicker(fromDate:Date?,toDate:Date?)
}

class DatePickerViewController: UIViewController {

    @IBOutlet var mNavigationBar: UINavigationBar!
    @IBOutlet var mDatePicker: UIDatePicker!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    var dateDelegate:DatePickerSelectionDelegate?
    var isSingleDateSelection = false
    var mMinimumDate = Date()
    private var fromDate:Date?
    private var toDate:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.4, *) {
            mDatePicker.preferredDatePickerStyle = .wheels
        }
        if !isSingleDateSelection {
            mNavigationBar.topItem?.title = "FROM"
            doneBarButton.title = "Next"
        } else {
            mNavigationBar.topItem?.title = "Choose Date"
            doneBarButton.title = "Done"
        }
        mDatePicker.minimumDate = mMinimumDate
//        addDatePicker()
    }
    
    @IBAction func onCancelDatePicker(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onConfirmDateSelection(_ sender: Any) {
        if !isSingleDateSelection {
            if fromDate == nil {
                fromDate = mDatePicker.date
                mNavigationBar.topItem?.title = "TO"
                doneBarButton.title = "Done"
                mDatePicker.minimumDate = AppUtils.getDateByAdding(component: .hour, value: 1, toDate: mDatePicker.date)
            } else {
                toDate = mDatePicker.date
                self.dismiss(animated: true, completion: nil)
                self.dateDelegate?.didSelectDateFromDatePicker(fromDate: fromDate, toDate: toDate)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
            self.dateDelegate?.didSelectDateFromDatePicker(fromDate: mDatePicker.date, toDate: nil)
        }
    }
    
//    private func addDatePicker() {
//
//
//        let parentView = UIView(frame: CGRect(x: 16, y: 0, width: view.frame.size.width-32, height: 250))
//        parentView.center = self.view.center
//        parentView.backgroundColor = .white
//        parentView.layer.cornerRadius = 4
//
//        let navigationBar = UINavigationBar(frame: CGRect(x: 1, y: 0, width: parentView.frame.size.width-2, height:44))
//        navigationBar.backgroundColor = UIColor.white
//
//        let navigationItem = UINavigationItem()
//        navigationItem.title = "Schedule"
//
//        let rightButton =  UIBarButtonItem(title: "Done", style:   .plain, target: self, action: #selector(onDone))
//        let leftButton =  UIBarButtonItem(title: "Cancel", style:   .plain, target: self, action: #selector(onCancel))
//
//        navigationItem.leftBarButtonItem = leftButton
//        navigationItem.rightBarButtonItem = rightButton
//
//        navigationBar.items = [navigationItem]
//
//        datePicker.frame = CGRect(x: 0, y: navigationBar.frame.size.height, width: parentView.frame.size.width, height: parentView.frame.size.height-navigationBar.frame.size.height)
//
//        parentView.addSubview(navigationBar)
//        parentView.addSubview(datePicker)
//
//        self.view.addSubview(parentView)
//    }
    
//    @objc func onCancel() {
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    @objc func onDone() {
//        dateDelegate?.didSelectDateFromDatePicker(datePicker.date)
//        dismiss(animated: true, completion: nil)
//    }
}
