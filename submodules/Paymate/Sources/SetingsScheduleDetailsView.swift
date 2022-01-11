//
//  SetingsLocationDetailsView.swift
//  TelegramSample
//
//  Created by Heymate on 13/09/21.
//

import UIKit
//import Combine

class SetingsScheduleDetailsView: UIView {
    
    var embedController:UIViewController?
    private var schedules:[OfferSchedule] = []
//    var viewModelChanges = PassthroughSubject<[OfferSchedule],Never>()
    var modelChanges:(([OfferSchedule]) -> Void)?
    
    private lazy var scheduleStackView:UIStackView = {
        let _stackView = UIStackView()
        _stackView.axis = .vertical
        _stackView.distribution = .fill
        _stackView.translatesAutoresizingMaskIntoConstraints = false
        _stackView.alignment = .fill
        _stackView.spacing = 16
        return _stackView
    }()

    private lazy var userSchedulesSV:UIStackView = {
        let _stackView = UIStackView()
        _stackView.axis = .vertical
        _stackView.distribution = .fill
        _stackView.translatesAutoresizingMaskIntoConstraints = false
        _stackView.alignment = .fill
        _stackView.spacing = 16
        return _stackView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showSchedules()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func showSchedules() {
        addSubview(scheduleStackView)
        let bottomConstraint = scheduleStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        bottomConstraint.priority = .defaultHigh
        let stackConstraints = [
            scheduleStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 32),
            scheduleStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 0),
            bottomConstraint,
            scheduleStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8)
        ]
        
        for schedule in schedules {
            addScheduleView(date: schedule)
        }
        
        let addSlotBtn = AppUtils.sharedInstance.getButtonWithLeftImageAndRightText(image: UIImage(named: "close")!, title: "Add New Schedule")
        addSlotBtn.addTarget(self, action: #selector(onNewSchedule), for: .touchUpInside)
        
        scheduleStackView.addArrangedSubview(userSchedulesSV)
        scheduleStackView.addArrangedSubview(addSlotBtn)
        NSLayoutConstraint.activate(stackConstraints)
    }
    
    private func addScheduleView(date:OfferSchedule) {
        let removeScheduleBtn = UIButton(type: .custom)
        removeScheduleBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        removeScheduleBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true

//        let fromDates = AppUtils.getScheduleDateAndTime(date: date.scheduleDate)
//
//        let dateLabel = AppUtils.sharedInstance.getSubHeadLabel()
//        dateLabel.text = fromDates.date
//
//        let toDates = AppUtils.getScheduleDateAndTime(date: date.endDate)
//
//        let timeLabel = AppUtils.sharedInstance.getSubHeadLabel()
//        timeLabel.text = "\(fromDates.time) TO \(toDates.time)"
//
//        let _timeSlotsSV = UIStackView(arrangedSubviews: [removeScheduleBtn,dateLabel,timeLabel])
//        _timeSlotsSV.axis = .horizontal
//        _timeSlotsSV.distribution = .fill
//        _timeSlotsSV.alignment = .fill
//        _timeSlotsSV.translatesAutoresizingMaskIntoConstraints = false
//        _timeSlotsSV.spacing = 16
//
//        userSchedulesSV.addArrangedSubview(_timeSlotsSV)
    }
    
    @objc func onNewSchedule() {
        let controller = DatePickerViewController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        controller.dateDelegate = self
        embedController?.present(controller, animated: true, completion: nil)
    }
}

//extension SetingsScheduleDetailsView:DatePickerSelectionDelegate {
//    func didSelectDateFromDatePicker(_ date: Date) {
//        let offerDate = OfferSchedule(scheduleDate: date,endDate: AppUtils.getDateByAdding(component: .hour, value: 1, toDate: date))
//        schedules.append(offerDate)
//        addScheduleView(date: offerDate)
////        viewModelChanges.send(schedules)
//        modelChanges?(schedules)
//
//        self.superview?.updateConstraintsIfNeeded()
//        self.superview?.layoutIfNeeded()
//    }
//}
