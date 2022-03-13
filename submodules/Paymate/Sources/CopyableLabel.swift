//
//  CopyableLabel.swift
//  _idx_Paymate_4585E51E_ios_min12.0
//
//  Created by Sreedeep on 17/01/22.
//

import UIKit

public class CopyableLabel: UILabel {
    override public var canBecomeFirstResponder: Bool {
            get {
                return true
            }
        }

    public override init(frame: CGRect) {
            super.init(frame: frame)
            sharedInit()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            sharedInit()
        }

        func sharedInit() {
            isUserInteractionEnabled = true
            addGestureRecognizer(UILongPressGestureRecognizer(
                target: self,
                action: #selector(showMenu(sender:))
            ))
        }

        public override func copy(_ sender: Any?) {
            UIPasteboard.general.string = text
            UIMenuController.shared.setMenuVisible(false, animated: true)
        }

        @objc func showMenu(sender: Any?) {
            becomeFirstResponder()
            let menu = UIMenuController.shared
            if !menu.isMenuVisible {
                menu.setTargetRect(bounds, in: self)
                menu.setMenuVisible(true, animated: true)
            }
        }

        public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            return (action == #selector(copy(_:)))
        }
}
                
