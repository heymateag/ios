//
//  PercentageInputController.swift
//  TelegramSample
//
//  Created by Heymate on 24/09/21.
//

import UIKit

protocol PercentageINputDelegate {
    func didSelectApplyWithInputValue(_ value:Int)
}

class PercentageInputController: UIViewController {

    @IBOutlet var inputField: InputField!
    @IBOutlet var headerTitle: UILabel!
    var iDelegate:PercentageINputDelegate?
    var pageTitle:String?
    var currentValue:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
   }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerTitle.text = pageTitle
        inputField.text = "\(currentValue ?? 0)"
    }
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onApply(_ sender: Any) {
        if let intVal = Int(inputField.text ?? "") {
            iDelegate?.didSelectApplyWithInputValue(intVal)
            dismiss(animated: true, completion: nil)
        }
    }
}
