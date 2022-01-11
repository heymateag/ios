//
//  TnCViewController.swift
//  TelegramSample
//
//  Created by Heymate on 25/09/21.
//

import UIKit

protocol TnCControllerDelegate {
    func didDismissTnCWithContent(_ content:String)
}

class TnCViewController: UIViewController {

    @IBOutlet var termsTextView: UITextView!
    @IBOutlet var termsParentView: UIView!
    @IBOutlet var btnConfirm: UIButton!
    @IBOutlet var btnCancel: UIButton!
    var tncDelegate:TnCControllerDelegate?
    var currentTerms = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        termsParentView.layer.cornerRadius = 8
        termsParentView.layer.borderColor = AppUtils.COLOR_GRAY3().cgColor
        termsParentView.layer.borderWidth = 0.6
        
        btnConfirm.roundedPaymateView(cornerRadius: 8)
        btnCancel.roundedPaymateView(cornerRadius: 8)
        
        btnCancel.addTarget(self, action: #selector(onCancel), for: .touchUpInside)
        
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
//        self.view.addGestureRecognizer(gesture)
    }
    
    @IBAction func onCloseTerms(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        termsTextView.text = currentTerms
    }
    
    @objc private func dismissKeyBoard() {
        termsTextView.resignFirstResponder()
    }
    
    @IBAction func onConfirmBtn(_ sender: Any) {
        termsTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        tncDelegate?.didDismissTnCWithContent(termsTextView.text)
    }
    
    @objc private func onCancel() {
        dismiss(animated: true, completion: nil)
    }
   
}
