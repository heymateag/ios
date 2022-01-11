//
//  SettingsParticipantDetailView.swift
//  TelegramSample
//
//  Created by Heymate on 14/09/21.
//

import UIKit
import Combine



class SettingsParticipantDetailView: UIView {

    private var viewModel = ParticipantModel()
//    var viewModelChanges = PassthroughSubject<ParticipantModel,Never>()
    var modelChanges:((ParticipantModel) -> Void)?
    
    private lazy var participantStackView:UIStackView = {
        let _stackView = UIStackView()
        _stackView.axis = .vertical
        _stackView.distribution = .fill
        _stackView.translatesAutoresizingMaskIntoConstraints = false
        _stackView.spacing = 16
        return _stackView
    }()
    
    private lazy var participantHeading:UILabel = {
        let _label = AppUtils.sharedInstance.getSubHeadLabel()
        _label.text = "Maximum number of participants who can attend the meeting at the same time."
        return _label
    }()
    
    private lazy var usersField:UITextField = {
        let _field = UITextField()
        _field.borderStyle = .none
        _field.keyboardType = .numberPad
        SettingsPriceDetailView.getBorder(field: _field)
        _field.translatesAutoresizingMaskIntoConstraints = false
        let fieldWidth = _field.widthAnchor.constraint(equalToConstant: 50)
        fieldWidth.priority = .defaultHigh
        NSLayoutConstraint.activate([fieldWidth])
        return _field
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        participantStackView.translatesAutoresizingMaskIntoConstraints = false
        participantHeading.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(participantStackView)
        let bottomConstraint = participantStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        bottomConstraint.priority = .defaultHigh
        let stackConstraints = [
            participantStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 32),
            participantStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 0),
            bottomConstraint,
            participantStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8)
        ]
        
        let usersSV = UIStackView()
        usersSV.axis = .horizontal
        usersSV.distribution = .fill
        usersSV.translatesAutoresizingMaskIntoConstraints = false
        usersSV.spacing = 8
        usersSV.alignment = .center
        
        let userLabel = AppUtils.sharedInstance.getSubHeadLabel()
        userLabel.text = "user(s)"
        userLabel.setContentHuggingPriority(UILayoutPriority(260), for: .horizontal)
        userLabel.textColor = AppUtils.COLOR_GRAY4()
        userLabel.widthAnchor.constraint(equalToConstant: 43).isActive = true
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let unlimitedLabel = AppUtils.sharedInstance.getSubHeadLabel()
        unlimitedLabel.textColor = AppUtils.COLOR_GRAY4()
        unlimitedLabel.setContentHuggingPriority(UILayoutPriority(259), for: .horizontal)
//        unlimitedLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        unlimitedLabel.text = "Unlimited"
        
        let tickMark = AppUtils.sharedInstance.getTickMark()
        tickMark.addTarget(self, action: #selector(onCheckBox), for: .touchUpInside)
        
        let _field = UITextField()
        _field.borderStyle = .none
        _field.keyboardType = .numberPad
        let width = _field.widthAnchor.constraint(equalToConstant: 60)
        _field.addTarget(self, action: #selector(onNoOfUsersChange), for: .editingChanged)
        width.isActive = true
        SettingsPriceDetailView.getBorder(field: _field)
        
        usersSV.addArrangedSubview(_field)
        usersSV.addArrangedSubview(userLabel)
        usersSV.addArrangedSubview(tickMark)
        usersSV.addArrangedSubview(unlimitedLabel)
        
        participantStackView.addArrangedSubview(participantHeading)
        participantStackView.addArrangedSubview(usersSV)
        NSLayoutConstraint.activate(stackConstraints)
    }
    
    @objc func onCheckBox(btn:UIButton) {
        btn.isSelected = !btn.isSelected
        viewModel.allUsers = btn.isSelected
//        viewModelChanges.send(viewModel)
        modelChanges?(viewModel)
    }

    @objc func onNoOfUsersChange(field:UITextField) {
        if let text = field.text,let intValue = Int(text) {
            viewModel.noOfUsers = intValue
//            viewModelChanges.send(viewModel)
            modelChanges?(viewModel)
        }
    }

}
