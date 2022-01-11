//
//  SettingPaymentTermsView.swift
//  TelegramSample
//
//  Created by Heymate on 20/09/21.
//

import UIKit
import Combine

class SettingPaymentTermsView: UIView {
    
    enum PercentageButtonTags:Int {
        case Deposit = 100
        case Promise
        case MoreThan2Hours
        case BetweenHours
        case None
    }

    var embeddedController:UIViewController?
    private var promisesModel:PayTermModel!
    private var cancellationsModel:[PayTermModel] = []
    
//    var promiseObserver = PassthroughSubject<PayTermModel,Never>()
//    var cancellationObserver = PassthroughSubject<[PayTermModel],Never>()
    
    var promiseChanges:((PayTermModel) -> Void)?
    var cancellationChanges:(([PayTermModel]) -> Void)?
    
    private var selectedPercentageChange:PercentageButtonTags = .None
    
    private lazy var paymentTermStackView:UIStackView = {
        let _stackView = UIStackView()
        _stackView.axis = .vertical
        _stackView.distribution = .equalSpacing
        _stackView.alignment = .fill
        _stackView.translatesAutoresizingMaskIntoConstraints = false
        _stackView.spacing = 8
        return _stackView
    }()
    
    private lazy var delayInStartPercentage:UIButton = {
        let _button = UIButton(type: .custom)
        _button.setTitleColor(AppUtils.COLOR_BLUE(), for: .normal)
        _button.setTitle("\(promisesModel.percentage)%", for: .normal)
        return _button
    }()
    private var btnDepositPercentage:UIButton?
    private var btnMoreThan2HoursPercentage:UIButton?
    private var btnBetween2To6Percentage:UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        promisesModel = PayTermModel(initialText: "Delays in start by ",endText: " mins", compareSymbol: .GreaterThan, startRangeValue: 0, endRangeValue: 0, compareValue: 3,percentage: 30)
        let deposit = PayTermModel(initialText: "Deposit",endText: "", compareSymbol: .None, startRangeValue: 0, endRangeValue: 0, compareValue: 0,percentage: 0)
        let cancellation1 = PayTermModel(initialText: "Cancellation in ",endText: " hrs of start", compareSymbol: .LessThan, startRangeValue: 0, endRangeValue: 0, compareValue: 2, percentage: 0)
        let cancellation2 = PayTermModel(initialText: "reCancellation in ",endText: " hrs of start", compareSymbol: .Range, startRangeValue: 2, endRangeValue: 6, compareValue: 0, percentage: 0)
        cancellationsModel.append(deposit)
        cancellationsModel.append(cancellation1)
        cancellationsModel.append(cancellation2)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        paymentTermStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(paymentTermStackView)
        let bottomConstraint = paymentTermStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        bottomConstraint.priority = .defaultHigh
        let stackConstraints = [
            paymentTermStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 32),
            paymentTermStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 0),
            bottomConstraint,
            paymentTermStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(stackConstraints)
        
        let providerPromises = AppUtils.sharedInstance.getHeadingLabel()
        providerPromises.font = UIFont.boldSystemFont(ofSize: 14)
        providerPromises.textColor = AppUtils.COLOR_BLUE()
        providerPromises.text = "Service Provider promises"
        
        let delaySV = UIStackView()
        delaySV.axis = .horizontal
        delaySV.distribution = .equalSpacing
        delaySV.alignment = .center
        delaySV.translatesAutoresizingMaskIntoConstraints = false
        
        let delayInStart = AppUtils.sharedInstance.getSubHeadLabel()
        delayInStart.text = "\(promisesModel.initialText) \(promisesModel.compareSymbol[getSymbol: promisesModel.compareSymbol])\(promisesModel.compareSymbol)\(promisesModel.endText)"
        delayInStart.setContentCompressionResistancePriority(.required, for: .horizontal)
        delayInStartPercentage.tag = PercentageButtonTags.Promise.rawValue
        delayInStartPercentage.addTarget(self, action: #selector(onPercentage), for: .touchUpInside)
        
        delaySV.addArrangedSubview(delayInStart)
        delaySV.addArrangedSubview(delayInStartPercentage)
        
        let advancePayment = AppUtils.sharedInstance.getHeadingLabel()
        advancePayment.font = UIFont.boldSystemFont(ofSize: 14)
        advancePayment.textColor = AppUtils.COLOR_BLUE()
        advancePayment.text = "Advance payment & related cancellation conditions"
        
        paymentTermStackView.addArrangedSubview(providerPromises)
        paymentTermStackView.addArrangedSubview(delaySV)
        paymentTermStackView.addArrangedSubview(advancePayment)
        
        //cancellations
        let depositModel = cancellationsModel[0]
        let moreThan2HoursModel = cancellationsModel[1]
        let hoursRange = cancellationsModel[2]
        
        
        //deposit
        let depositStackView = getCancellationStackView()
        let depositTitle = AppUtils.sharedInstance.getSubHeadLabel()
        depositTitle.text = "\(depositModel.initialText)"
        let depositPercentage = getPercentageButton(model: depositModel)
        depositPercentage.tag = PercentageButtonTags.Deposit.rawValue
        depositPercentage.addTarget(self, action: #selector(onPercentage), for: .touchUpInside)
        
        btnDepositPercentage = depositPercentage
        depositStackView.addArrangedSubview(depositTitle)
        depositStackView.addArrangedSubview(depositPercentage)
        paymentTermStackView.addArrangedSubview(depositStackView)
        
        //> 2 hours
        let moreThan2HourStackView = getCancellationStackView()
        let more2hrsTitle = AppUtils.sharedInstance.getSubHeadLabel()
        more2hrsTitle.text = "\(moreThan2HoursModel.initialText)\(moreThan2HoursModel.compareSymbol[getSymbol: moreThan2HoursModel.compareSymbol])\(moreThan2HoursModel.compareValue)\(moreThan2HoursModel.endText)"
        
        let more2HrsPercentage = getPercentageButton(model: moreThan2HoursModel)
        more2HrsPercentage.tag = PercentageButtonTags.MoreThan2Hours.rawValue
        more2HrsPercentage.addTarget(self, action: #selector(onPercentage), for: .touchUpInside)
        btnMoreThan2HoursPercentage = more2HrsPercentage
        
        moreThan2HourStackView.addArrangedSubview(more2hrsTitle)
        moreThan2HourStackView.addArrangedSubview(more2HrsPercentage)
        paymentTermStackView.addArrangedSubview(moreThan2HourStackView)
        
        //2-6 hours
        let rangeStackView = getCancellationStackView()
        let rangeTitle = AppUtils.sharedInstance.getSubHeadLabel()
        rangeTitle.text = "\(hoursRange.initialText)\(hoursRange.startRangeValue)\(hoursRange.compareSymbol[getSymbol: hoursRange.compareSymbol])\(hoursRange.endRangeValue)\(hoursRange.endText)"
        
        let hoursRangePercentage = getPercentageButton(model: hoursRange)
        hoursRangePercentage.tag = PercentageButtonTags.BetweenHours.rawValue
        hoursRangePercentage.addTarget(self, action: #selector(onPercentage), for: .touchUpInside)
        btnBetween2To6Percentage = hoursRangePercentage
        
        rangeStackView.addArrangedSubview(rangeTitle)
        rangeStackView.addArrangedSubview(hoursRangePercentage)
        paymentTermStackView.addArrangedSubview(rangeStackView)
        //
        
//        for model in cancellationsModel {
//            let advanceHorizantalSV = UIStackView() //each horizantal element
//            advanceHorizantalSV.axis = .horizontal
//            advanceHorizantalSV.distribution = .equalSpacing
//            advanceHorizantalSV.alignment = .center
//            advanceHorizantalSV.translatesAutoresizingMaskIntoConstraints = false
//
//            let title = AppUtils.sharedInstance.getSubHeadLabel()
//            if model.compareSymbol == .Range {
//                title.text = "\(model.initialText)\(model.startRangeValue)\(model.compareSymbol[getSymbol: model.compareSymbol])\(model.endRangeValue)\(model.endText)"
//            } else if model.compareSymbol == .None {
//                title.text = "\(model.initialText)"
//            } else {
//                title.text = "\(model.initialText)\(model.compareSymbol[getSymbol: model.compareSymbol])\(model.compareValue)\(model.endText)"
//            }
//            title.setContentCompressionResistancePriority(.required, for: .horizontal)
//            let percentage = UIButton(type: .custom)
//            percentage.setTitleColor(AppUtils.COLOR_BLUE(), for: .normal)
//            percentage.setTitle("\(model.percentage)%", for: .normal)
//            percentage.addTarget(self, action: #selector(onPercentage), for: .touchUpInside)
//
//            advanceHorizantalSV.addArrangedSubview(title)
//            advanceHorizantalSV.addArrangedSubview(percentage)
//            paymentTermStackView.addArrangedSubview(advanceHorizantalSV)
//        }
    }
    
    private func getCancellationStackView() -> UIStackView {
        let advanceHorizantalSV = UIStackView() //each horizantal element
        advanceHorizantalSV.axis = .horizontal
        advanceHorizantalSV.distribution = .equalSpacing
        advanceHorizantalSV.alignment = .center
        advanceHorizantalSV.translatesAutoresizingMaskIntoConstraints = false
        return advanceHorizantalSV
    }
    
    private func getPercentageButton(model:PayTermModel) -> UIButton {
        let percentage = UIButton(type: .custom)
        percentage.setTitleColor(AppUtils.COLOR_BLUE(), for: .normal)
        percentage.setTitle("\(model.percentage)%", for: .normal)
        return percentage
    }
    
    @objc func onPercentage(button:UIButton) {
        selectedPercentageChange = PercentageButtonTags(rawValue: button.tag)!
        let controller = PercentageInputController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.view.backgroundColor = AppUtils.POPOVER_BACKGROUND()
        controller.iDelegate = self
        embeddedController?.present(controller, animated: true, completion: nil)
    }
}

extension SettingPaymentTermsView:PercentageINputDelegate {
    func didSelectApplyWithInputValue(_ value: Int) {
        switch selectedPercentageChange {
            case .Promise:
                delayInStartPercentage.setTitle("\(value)%", for: .normal)
                promisesModel.percentage = value
                promiseChanges?(promisesModel)
//                promiseObserver.send(promisesModel)
            case .Deposit:
                btnDepositPercentage?.setTitle("\(value)%", for: .normal)
                cancellationsModel[0].percentage = value
                cancellationChanges?(cancellationsModel)
//                cancellationObserver.send(cancellationsModel)
            case .MoreThan2Hours:
                btnMoreThan2HoursPercentage?.setTitle("\(value)%", for: .normal)
                cancellationsModel[1].percentage = value
                cancellationChanges?(cancellationsModel)
//                cancellationObserver.send(cancellationsModel)
            case .BetweenHours:
                btnBetween2To6Percentage?.setTitle("\(value)%", for: .normal)
                cancellationsModel[2].percentage = value
                cancellationChanges?(cancellationsModel)
//                cancellationObserver.send(cancellationsModel)
            default:break
        }
    }
}
