//
//  PaymateAlerts.swift
//  _idx_Paymate_FE0C62F9_ios_min9.0
//
//  Created by Heymate on 15/11/21.
//

import Foundation
import UIKit

protocol PaymateAlerts {
    typealias onAccept = () -> Void
    typealias onCancel = () -> Void
    func showAlertWithMessage(title:String?,message:String)
    func showPromptMessage(title:String?,message:String?,acceptTitle:String,cancelTitle:String,onAccept:@escaping(onAccept),onReject:@escaping(onCancel))
    func showMessageAlertWithHandler(title:String?,message:String?,btnTitle:String,onAccept:@escaping(onAccept))
    func showImageSelectionChannelType(onCamera:@escaping(onAccept),onGallery:@escaping(onCancel))
    func showToastMessage(text:String)
}

extension PaymateAlerts where Self:UIViewController {
    func showMessageAlertWithHandler(title:String?,message:String?,btnTitle:String,onAccept:@escaping(onAccept)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: { (_) in
            onAccept()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func showAlertWithMessage(title:String?,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPromptMessage(title:String?,message:String?,acceptTitle:String,cancelTitle:String,onAccept:@escaping(onAccept),onReject:@escaping(onCancel)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: acceptTitle, style: .default, handler: { (_) in
            onAccept()
        }))
        if cancelTitle != "" {
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { (_) in
                onReject()
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showImageSelectionChannelType(onCamera:@escaping(onAccept),onGallery:@escaping(onCancel)) {
        let alert = UIAlertController(title: "Photos", message: "Choose option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            onCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_) in
            onGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showToastMessage(text:String) {
        let alertDisapperTimeInSeconds = 2.0
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .actionSheet)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
          alert.dismiss(animated: true)
        }
    }
}

protocol PaymateServiceErrorhandler:PaymateAlerts {
    @discardableResult func apiFailedWithError(error:PeyError) -> PeyError?
}

extension PaymateServiceErrorhandler where Self:UIViewController {
    @discardableResult
    func apiFailedWithError(error:PeyError) -> PeyError? {
        switch error {
           case .NoDataAvailableInResponseError(let error):
//            if let msg = error.message {
//                self.showAlertWithMessage(title: nil, message: msg)
//            }
                return PeyError.NoDataAvailableInResponseError(error)
            case .UnAuthorized(let nwError):
                if let msg = nwError.error {
                    if msg.lowercased().contains("expir") || msg.lowercased().contains("token") {
                        self.showMessageAlertWithHandler(title: "Error", message: msg, btnTitle: "OK") {
//                            AppUtils.saveAuthToken(token: "")
                        }
                    } else {
                        self.showMessageAlertWithHandler(title: "Error", message: msg, btnTitle: "OK") {
                        }
                    }
                } else {
                    self.showAlertWithMessage(title: "Error", message: "Something went wrong. Please try again.")
                }
            case .Non200StatusCodeError(let error):
                self.showAlertWithMessage(title: "Error", message: error.message ?? "Something went wrong. Please try again")
                break
            case .customError(let msg):
                self.showAlertWithMessage(title: "Error", message: msg)
                break
            case .NoNetworkError:
                self.showAlertWithMessage(title: "No Network", message: "No network connection available. Please try again.")
                break
            default:
                self.showAlertWithMessage(title: "Error", message: "Something went wrong. Please try again.")
                break
        }
        return nil
    }
}

