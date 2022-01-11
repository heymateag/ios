//
//  SettingsLocationView.swift
//  TelegramSample
//
//  Created by Heymate on 20/09/21.
//

import UIKit
import Combine

class SettingsLocationView: UIView {

    private var model = LocationViewModel(isOnLineMeeting: true)
//    var viewModelChanges = PassthroughSubject<LocationViewModel,Never>()
    
    var modelChanges:((LocationViewModel) -> Void)!

    
    private lazy var locationStackView:UIStackView = {
        let _stackView = UIStackView()
        _stackView.axis = .horizontal
        _stackView.distribution = .fillProportionally
        _stackView.translatesAutoresizingMaskIntoConstraints = false
        _stackView.spacing = 8
        _stackView.alignment = .leading
        return _stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        addSubview(locationStackView)
        let bottomConstraint = locationStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        bottomConstraint.priority = .defaultHigh
        let stackConstraints = [
            locationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 32),
            locationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 0),
            bottomConstraint,
            locationStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(stackConstraints)
        
        let tickMark = AppUtils.sharedInstance.getTickMark()
        tickMark.addTarget(self, action: #selector(onTickMark), for: .touchUpInside)
        let meeting = AppUtils.sharedInstance.getHeadingLabel()
        meeting.text = "Online Meeting"
        locationStackView.addArrangedSubview(tickMark)
        locationStackView.addArrangedSubview(meeting)
        
    }
    
    @objc func onTickMark(btn:UIButton) {
        btn.isSelected = !btn.isSelected
        model.isOnLineMeeting = btn.isSelected
//        viewModelChanges.send(model)
        modelChanges(model)
    }
}
