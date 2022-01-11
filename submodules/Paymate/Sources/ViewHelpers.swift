//
//  ViewHelpers.swift
//  TelegramSample
//
//  Created by Heymate on 28/08/21.
//

import UIKit
import QuartzCore

extension UIView {
    @discardableResult
    func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: CGColor) -> CALayer {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        layer.addSublayer(borderLayer)
        return borderLayer
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat,xValue:CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: xValue, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}

extension UIButton {
    func setForCorneredBlueButton() {
        self.layer.cornerRadius = 4
        self.backgroundColor = AppUtils.COLOR_BLUE()
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = AppUtils.APP_FONT(size: 14)
    }
    private func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
    
    func setBackGroundColor(color:UIColor,state:UIControl.State) {
        self.setBackgroundImage(imageWithColor(color: color), for: state)
    }
}

extension UILabel {
    func roundedLabelWithText(background:UIColor,text:String,textColor:UIColor,width:CGFloat) {
        self.textColor = textColor
        self.text = text
        self.backgroundColor = background
        self.clipsToBounds = true
        self.textAlignment = .center
        self.font = AppUtils.APP_FONT(size: 10)
        self.layer.cornerRadius = width/2
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: width).isActive = true
    }
}

class InputField:UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
