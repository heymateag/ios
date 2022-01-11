//
//  SchedulePickerView.swift
//  TelegramSample
//
//  Created by Heymate on 24/09/21.
//

import UIKit

class SchedulePickerView: UIView {

    private lazy var schedulePickerView:UIDatePicker = {
        let _picker = UIDatePicker()
        _picker.datePickerMode = .dateAndTime
        return _picker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let parentView = UIView()
    }

}
